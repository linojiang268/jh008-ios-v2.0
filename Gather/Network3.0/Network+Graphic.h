//
//  Network+Graphic.h
//  Gather
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "AddressParkingSpaceListEntity.h"
#import "SitePlanListEntty.h"
#import "ActiveRouteListEntity.h"
#import "ActiveRoadmapTeammateLocationListEntity.h"

@interface Network (Graphic)

+ (void)getAddressParkingSpaceListWithActiveId:(NSUInteger)activeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(AddressParkingSpaceListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getSitePlanListWithActiveId:(NSUInteger)activeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(SitePlanListEntty *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getActiveRoutesWithActiveId:(NSUInteger)activeId success:(void (^)(ActiveRouteListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)uploadUserLocationWithLat:(double)lat lon:(double)lon loc_time:(NSTimeInterval)loc_time success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getGroupTeammateLocationWithGroupId:(NSUInteger)groupId success:(void (^)(ActiveRoadmapTeammateLocationListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
