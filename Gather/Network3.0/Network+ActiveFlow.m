//
//  Network+ActiveFlow.m
//  Gather
//
//  Created by apple on 15/3/24.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+ActiveFlow.h"

@implementation Network (ActiveFlow)

+ (void)getActiveFlowListWithActiveId:(NSUInteger)activeId cityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveFlowListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/process_v2" params:@{@"actId":@(activeId), @"cityId": @(cityId), @"page": @(page), @"size": @(size)} responseClass:[ActiveFlowListEntity class] success:success failure:failure];
}

+ (void)getBanquetMenuListWithActiveId:(NSUInteger)activeId type:(MenuType)type page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(BanquetMenuListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/menus_v2" params:@{@"actId":@(activeId), @"type": @(type), @"page": @(page), @"size": @(size)} responseClass:[BanquetMenuListEntity class] success:success failure:failure];
}

+ (void)getActiveAttentineListWithActiveId:(NSUInteger)activeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(AttentionListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/attentions_v2" params:@{@"actId":@(activeId), @"page": @(page), @"size": @(size)} responseClass:[AttentionListEntity class] success:success failure:failure];
}

@end
