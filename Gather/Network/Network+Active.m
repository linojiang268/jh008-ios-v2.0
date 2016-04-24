//
//  Network+Active.m
//  Gather
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+Active.h"

@implementation Network (Active)

+ (void)getActiveListWithCityId:(NSUInteger)cityId tagId:(NSUInteger)tagId keyWords:(NSString *)keyWords startTime:(NSString *)startTime endTime:(NSString *)endTime page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (cityId > 0) {
        [params setObject:@(cityId) forKey:@"cityId"];
    }
    if (tagId > 0) {
        [params setObject:@(tagId) forKey:@"tagId"];
    }
    if (!string_is_empty(keyWords)) {
        [params setObject:keyWords forKey:@"keyWords"];
    }
    if (!string_is_empty(startTime)) {
        [params setObject:startTime forKey:@"startTime"];
    }
    if (!string_is_empty(endTime)) {
        [params setObject:endTime forKey:@"endTime"];
    }
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    
    [self GET:@"act/activity/acts" params:params responseClass:[ActiveListEntity class] success:success failure:failure];
}

+ (void)getHotActiveListWithCityId:(NSUInteger)cityId  page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (cityId > 0) {
        [params setObject:@(cityId) forKey:@"cityId"];
    }
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    
    [self GET:@"act/activity/recommendActs" params:params responseClass:[ActiveListEntity class] success:success failure:failure];

}

+ (void)getNearbyActiveWithSearchType:(BaiduCloudSearchType)searchType location:(NSString *)location bounds:(NSString *)bounds filter:(NSString *)filter page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(NearbyActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    if (!NETWORK_REACHABLE && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        failure(@"网络异常",StatusCodeNetworkError);
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:kBaidu_Cloud_Search_AK forKey:@"ak"];
    [params setObject:@(kBaidu_Cloud_Search_Table_ID) forKey:@"geotable_id"];
    [params setObject:@"" forKey:@"q"];
    [params setObject:filter forKey:@"filter"];
    [params setObject:@(page) forKey:@"page_index"];
    [params setObject:@(size) forKey:@"page_size"];
    
    
    NSString *url = @"";
    if (searchType == BaiduCloudSearchTypeNearby) {
        url = kBaidu_Cloud_Nearby_Search_URL;
        [params setObject:location forKey:@"location"];
        [params setObject:@(kBaidu_Cloud_Search_Radius) forKey:@"radius"];
    }
    if (searchType == BaiduCloudSearchTypeBounds) {
        url = kBaidu_Cloud_Bounds_Search_URL;
        [params setObject:bounds forKey:@"bounds"];
    }
    
    [[AFHTTPRequestOperationManager manager] GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        log_value(@"response:%@",responseObject);
        
        Class responseClass = NSClassFromString(@"NearbyActiveListEntity");
        NSUInteger statusCode = [responseObject[@"code"] intValue];
        if (statusCode == 0) {
            if (responseClass != NULL) {
                NSError *error = nil;
                if ([responseClass instancesRespondToSelector:@selector(initWithDictionary:error:)]) {
                    id entity = [[responseClass alloc] initWithDictionary:responseObject error:&error];
                    if(entity){
                        success(entity);
                    }else{
                        failure(@"解析数据失败", StatusCodeParseError);
                        log_error(@"解析数据失败,创建失败");
                    }
                }else {
                    failure(@"解析数据失败", StatusCodeParseError);
                    log_error(@"解析数据失败,responseClass设置错误");
                }
            }else {
                failure(@"解析数据失败", StatusCodeParseError);
                log_error(@"解析数据失败，未设置responseClass");
            }
        }else {
            failure(@"请求失败",StatusCodeNetworkError);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(@"网络异常",StatusCodeNetworkError);
        log_error(@"%@",error);
    }];
}

+ (void)getActiveDetailWithId:(NSUInteger)activeId success:(void (^)(ActiveDetailEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
#ifdef __Gather_2_0_2__
    [self GET:@"act/actMore/info_v2" params:@{@"actId": @(activeId)} responseClass:[ActiveDetailEntity class] success:success failure:failure];
#else
    [self GET:@"act/activity/act" params:@{@"actId": @(activeId)} responseClass:[ActiveDetailEntity class] success:success failure:failure];
#endif
    
}

+ (void)getNewsWithActiveId:(NSUInteger)activeId typeId:(NewsType)typeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(NewsListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (activeId > 0) {
        [params setObject:@(activeId) forKey:@"actId"];
    }
    if (typeId > 0) {
        [params setObject:@(typeId) forKey:@"typeId"];
    }
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    
    [self GET:@"act/activity/listNews" params:params responseClass:[NewsListEntity class] success:success failure:failure];
}

+ (void)getStarWithActiveId:(NSUInteger)activeId cityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(StarListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (activeId > 0) {
        [params setObject:@(activeId) forKey:@"actId"];
    }
    if (cityId > 0) {
        [params setObject:@(cityId) forKey:@"cityId"];
    }
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    
    [self GET:@"act/activity/listVips" params:params responseClass:[StarListEntity class] success:success failure:failure];
}

+ (void)getCommentWithActiveId:(NSUInteger)activeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveCommentListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (activeId > 0) {
        [params setObject:@(activeId) forKey:@"actId"];
    }
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
     [self GET:@"act/activity/comments" params:params responseClass:[ActiveCommentListEntity class] success:success failure:failure];
}

+ (void)collectActiveWithId:(NSUInteger)activeId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/activity/lov" params:@{@"actId": @(activeId)} success:success failure:failure];
}

+ (void)cancelCollectActiveWithId:(NSUInteger)activeId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/activity/delLov" params:@{@"actId": @(activeId)} success:success failure:failure];
}

+ (void)applyWithActiveId:(NSUInteger)activeId name:(NSString *)name phone:(NSString *)phone peopleNumber:(NSUInteger)peopleNumber lon:(CGFloat)lon lat:(CGFloat)lat address:(NSString *)address success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (activeId > 0) {
        [params setObject:@(activeId) forKey:@"actId"];
    }
    if (!string_is_empty(name)) {
        [params setObject:name forKey:@"name"];
    }
    if (!string_is_empty(phone)) {
        [params setObject:phone forKey:@"phone"];
    }
    if (peopleNumber > 0) {
        [params setObject:@(peopleNumber) forKey:@"peopleNum"];
    }
    if (lon != 0) {
        [params setObject:@(lon) forKey:@"lon"];
    }
    if (lat != 0) {
        [params setObject:@(lat) forKey:@"lat"];
    }
    if (!string_is_empty(address)) {
        [params setObject:address forKey:@"address"];
    }
    
    [self POST:@"act/activity/enroll" params:params success:success failure:failure];
}

+ (void)activeCommentWithActiveId:(NSUInteger)activeId content:(NSString *)content success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/activity/comment" params:@{@"actId": @(activeId), @"content": content} success:success failure:failure];
}

+ (void)activeShareWithActiveId:(NSUInteger)activeId shareType:(GatherShareType)shareType success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/activity/share" params:@{@"actId": @(activeId), @"shareType": @(shareType)} success:success failure:failure];
}

+ (void)getMyApplyActiveWithUserId:(NSUInteger)userId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(MyApplyActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId > 0) {
        [params setObject:@(userId) forKey:@"uid"];
    }
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    
    [self GET:@"act/activity/enrollActs" params:params responseClass:[MyApplyActiveListEntity class] success:success failure:failure];
}

+ (void)getMyCheckInActiveWithUserId:(NSUInteger)userId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(MyCheckInActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId > 0) {
        [params setObject:@(userId) forKey:@"uid"];
    }
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    
    [self GET:@"act/activity/checkinActs" params:params responseClass:[MyCheckInActiveListEntity class] success:success failure:failure];
}

+ (void)getMyCommentActiveWithUserId:(NSUInteger)userId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId > 0) {
        [params setObject:@(userId) forKey:@"uid"];
    }
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    
    [self GET:@"act/activity/commentActs" params:params responseClass:[ActiveListEntity class] success:success failure:failure];
}

+ (void)getMyFocusActiveWithUserId:(NSUInteger)userId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId > 0) {
        [params setObject:@(userId) forKey:@"uid"];
    }
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    
    [self GET:@"act/activity/lovActs" params:params responseClass:[ActiveListEntity class] success:success failure:failure];
}

+ (void)activeCheckInWithActiveId:(NSUInteger)activeId lon:(CGFloat)lon lat:(CGFloat)lat address:(NSString *)address success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (activeId > 0) {
        [params setObject:@(activeId) forKey:@"actId"];
    }
    if (lon != 0) {
        [params setObject:@(lon) forKey:@"lon"];
    }
    if (lat != 0) {
        [params setObject:@(lat) forKey:@"lat"];
    }
    if (!string_is_empty(address)) {
        [params setObject:address forKey:@"address"];
    }
    
    [self POST:@"act/activity/checkin" params:params success:success failure:failure];
}

+ (void)tipOffWithCityId:(NSUInteger)cityId phone:(NSString *)phone address:(NSString *)address intro:(NSString *)intro imgIds:(NSArray *)imgIds lon:(CGFloat)lon lat:(CGFloat)lat locationAddress:(NSString *)locationAddress success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (cityId > 0) {
        [params setObject:@(cityId) forKey:@"cityId"];
    }
    if (!string_is_empty(phone)) {
        [params setObject:phone forKey:@"contactPhone"];
    }
    if (!string_is_empty(address)) {
        [params setObject:address forKey:@"contactAddress"];
    }
    if (!string_is_empty(intro)) {
        [params setObject:intro forKey:@"intro"];
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
    
    [self POST:@"act/activity/brokeNews" params:params success:success failure:failure];
}

@end
