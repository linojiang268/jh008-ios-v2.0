//
//  Network+ActiveFlow.h
//  Gather
//
//  Created by apple on 15/3/24.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "ActiveFlowListEntity.h"
#import "BanquetMenuListEntity.h"
#import "AttentionListEntity.h"

typedef NS_ENUM(NSUInteger, MenuType) {
    MenuTypeLunch   = 1,
    MenuTypeDinner  = 2,
};

@interface Network (ActiveFlow)

+ (void)getActiveFlowListWithActiveId:(NSUInteger)activeId cityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveFlowListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getBanquetMenuListWithActiveId:(NSUInteger)activeId type:(MenuType)type page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(BanquetMenuListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getActiveAttentineListWithActiveId:(NSUInteger)activeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(AttentionListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;



@end
