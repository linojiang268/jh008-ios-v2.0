//
//  Network+Apply30.m
//  Gather
//
//  Created by apple on 15/3/31.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+Apply30.h"

@implementation Network (Apply30)

+ (void)getCustomFieldsListWithActiveId:(NSUInteger)activeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveApplyCustomFieldsListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/enrollCusKeys_v2" params:@{@"actId":@(activeId), @"page": @(page), @"size": @(size)} responseClass:[ActiveApplyCustomFieldsListEntity class] success:success failure:failure];
}

+ (void)appplyWithParams:(NSDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/actMore/enroll_v2" params:params success:success failure:failure];
}

+ (void)placeOrderWithProductId:(NSUInteger)productId number:(NSUInteger)number payPlatform:(PayPlatformType)platform success:(void (^)(OrderEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    [self POST:@"act/pay/placeOrder_v2" params:@{@"productId": @(productId), @"number": @(number), @"payPlatform": @(platform)} success:^(id response) {
            NSError *error = nil;
            if ([[OrderEntity class] instancesRespondToSelector:@selector(initWithDictionary:error:)]) {
                id entity = [[[OrderEntity class] alloc] initWithDictionary:response error:&error];
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
    } failure:failure];
}

+ (void)getMyApplyActiveHistoryWithUserId:(NSUInteger)userId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(MyApplyActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/enrollActs_v2" params:@{@"uid": @(userId), @"page": @(page), @"size": @(size)} responseClass:[MyApplyActiveListEntity class] success:success failure:failure];
}

@end
