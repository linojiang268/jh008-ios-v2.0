//
//  Network+Push.m
//  Gather
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+Push.h"
#import "BPush.h"
#import <Foundation/NSZone.h>

@implementation Network (Push)

+ (void)setUpWithCityId:(NSUInteger)cityId platform:(PlatformType)platform baiduUserId:(NSString *)baiduUserId baiduChannelId:(NSString *)baiduChannelId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (cityId > 0) {
        [params setObject:@(cityId) forKey:@"cityId"];
    }
    if (platform > 0) {
        [params setObject:@(platform) forKey:@"platform"];
    }
    if (!string_is_empty(baiduUserId)) {
        [params setObject:baiduUserId forKey:@"baiduUserId"];
    }
    if (!string_is_empty(baiduChannelId)) {
        [params setObject:baiduChannelId forKey:@"baiduChannelId"];
    }
    [self POST:@"act/user/setBaiduPush" params:params success:success failure:failure];
}

/*
 * $secret_key //应用的secret key
 * $method //GET或POST
 * $url url
 * $arrContent //请求参数(包括GET和POST的所有参数，不含计算的sign)
 * return $sign string
 
function genSign($secret_key, $method, $url, $arrContent) {
    $gather = $method.$url;
    ksort($arrContent);
    foreach($arrContent as $key => $value) {
        $gather .= $key.'='.$value;
    }
    $gather .= $secret_key;
    $sign = md5(urlencode($gather));
    return $sign;
}

$secret_key = 'xxxxxxxx';//此处替换为应用的secret key
$method = 'POST';
$url = 'http://channel.api.duapp.com/rest/2.0/channel/channel';
$arrContent = array(
                    'method'=>'token',
                    'timestamp'=>1313293563,
                    'expires'=>1313293565,
                    );
$sign = genSign($secret_key, $method, $url, $arrContent);

 */

+ (NSString *)encodeURL:(NSString *)urlString
{
    NSString *encodedValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                (CFStringRef)urlString, nil,
                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    if (encodedValue) {
        return encodedValue;
    }
    return @"";
}

+ (NSString *)genSignWithSecretKey:(NSString *)secretKey method:(NSString *)method url:(NSString *)url contentDict:(NSDictionary *)contentDict {
    
    NSMutableString *gather = [NSMutableString stringWithFormat:@"%@%@",method,url];
    NSArray *contentArray = [[contentDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [contentArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [gather appendFormat:@"%@=%@",obj,contentDict[obj]];
    }];
    [gather appendString:secretKey];
    [gather setString:[self encodeURL:gather]];
    [gather setString:[gather md5]];
    
    return gather;
}

+ (void)pushMsgWithUserId:(NSString *)user_id
               channel_id:(NSString *)channel_id
              device_type:(NSUInteger)device_type
                 messages:(NSString *)messages
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"push_msg" forKey:@"method"];
    [params setObject:@"W04WEydvC7ab9G9tFyToKSHY" forKey:@"apikey"];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:@(1) forKey:@"push_type"];
    [params setObject:channel_id forKey:@"channel_id"];
    [params setObject:@(device_type) forKey:@"device_type"];
    [params setObject:@(1) forKey:@"message_type"];
    [params setObject:messages forKey:@"messages"];
    [params setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"msg_keys"];
    [params setObject:@(kPUSH_STATUS) forKey:@"deploy_status"];
    [params setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"timestamp"];
    [params setObject:[self genSignWithSecretKey:@"L0SEOyZr8hIyeAyUdeKBpa2rtoMVDrrl" method:@"POST" url:@"https://channel.api.duapp.com/rest/2.0/channel/channel" contentDict:params] forKey:@"sign"];
    
    [[AFHTTPRequestOperationManager manager] POST:@"https://channel.api.duapp.com/rest/2.0/channel/channel" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        log_value(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        log_error(@"%@",error);
    }];
}

@end
