//
//  Network+Apply30.h
//  Gather
//
//  Created by apple on 15/3/31.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "OrderEntity.h"
#import "ActiveApplyCustomFieldsListEntity.h"
#import "MyApplyActiveListEntity.h"

typedef NS_ENUM(NSUInteger, PayPlatformType) {
    PayPlatformTypeAlipay   =   1,
    PayPlatformTypeWeChat   =   2,
    PayPlatformTypeUnionPay =   3
};

@interface Network (Apply30)

+ (void)getCustomFieldsListWithActiveId:(NSUInteger)activeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveApplyCustomFieldsListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)appplyWithParams:(NSDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)placeOrderWithProductId:(NSUInteger)productId number:(NSUInteger)number payPlatform:(PayPlatformType)platform success:(void (^)(OrderEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getMyApplyActiveHistoryWithUserId:(NSUInteger)userId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(MyApplyActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
