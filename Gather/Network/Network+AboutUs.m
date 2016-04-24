//
//  Network+AboutUs.m
//  Gather
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+AboutUs.h"

@implementation Network (AboutUs)

+ (void)feedbackWithCityId:(NSUInteger)cityId content:(NSString *)content imgIds:(NSArray *)imgIds lon:(CGFloat)lon lat:(CGFloat)lat locationAddress:(NSString *)locationAddress success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (cityId > 0) {
        [params setObject:@(cityId) forKey:@"cityId"];
    }
    if (!string_is_empty(content)) {
        [params setObject:content forKey:@"content"];
    }
    if (imgIds && imgIds.count > 0) {
        [params setObject:imgIds forKey:@"imgIds"];
    }
    if (lon != 0) {
        [params setObject:@(lon) forKey:@"lon"];
    }
    if (lat != 0) {
        [params setObject:@(lat) forKey:@"lat"];
    }
    if (!string_is_empty(locationAddress)) {
        [params setObject:locationAddress forKey:@"address"];
    }
    
    [self POST:@"act/user/feedback" params:params success:success failure:failure];

}

@end
