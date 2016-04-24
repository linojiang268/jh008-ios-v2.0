//
//  Network+Graphic.m
//  Gather
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+Graphic.h"

@implementation Network (Graphic)

+ (void)getAddressParkingSpaceListWithActiveId:(NSUInteger)activeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(AddressParkingSpaceListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/addrs_v2" params:@{@"actId":@(activeId), @"page": @(page), @"size": @(size)} responseClass:[AddressParkingSpaceListEntity class] success:success failure:failure];
}

+ (void)getSitePlanListWithActiveId:(NSUInteger)activeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(SitePlanListEntty *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/placeImgs_v2" params:@{@"actId":@(activeId), @"page": @(page), @"size": @(size)} responseClass:[SitePlanListEntty class] success:success failure:failure];
}

+ (void)getActiveRoutesWithActiveId:(NSUInteger)activeId success:(void (^)(ActiveRouteListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/ActInfo/actRoutes" params:@{@"act_id":@(activeId)} responseClass:[ActiveRouteListEntity class] success:success failure:failure];
}

+ (void)uploadUserLocationWithLat:(double)lat lon:(double)lon loc_time:(NSTimeInterval)loc_time success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"user/UserLocation/report" params:@{@"lat": @(lat), @"lng": @(lon), @"loc_time": @(loc_time)} success:success failure:failure];
}

+ (void)getGroupTeammateLocationWithGroupId:(NSUInteger)groupId success:(void (^)(ActiveRoadmapTeammateLocationListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"user/UserLocation/getGroup" params:@{@"group_id": @(groupId)} responseClass:[ActiveRoadmapTeammateLocationListEntity class] success:success failure:failure];
}

@end
