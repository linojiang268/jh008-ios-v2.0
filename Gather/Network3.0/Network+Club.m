//
//  Network+Club.m
//  Gather
//
//  Created by apple on 15/4/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+Club.h"

@implementation Network (Club)

+ (void)getClubListWithCityId:(NSUInteger)cityId keyWords:(NSString *)keyWords page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ClubListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(cityId) forKey:@"cityId"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    if (!string_is_empty(keyWords)) {
        [params setObject:keyWords forKey:@"keyWords"];
    }
    
    [self GET:@"act/org/orgs_v2" params:params responseClass:[ClubListEntity class] success:success failure:failure];
}

+ (void)getClubDetailWithClubId:(NSUInteger)clubId success:(void (^)(ClubDetailEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/org/org_v2" params:@{@"orgId": @(clubId)} responseClass:[ClubDetailEntity class] success:success failure:failure];
}

+ (void)focusClubWithClubId:(NSUInteger)clubId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/org/lov_v2" params:@{@"orgId": @(clubId)} success:success failure:failure];
}

+ (void)cancelFocusClubWithClubId:(NSUInteger)clubId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/org/unLov_v2" params:@{@"orgId": @(clubId)} success:success failure:failure];
}

+ (void)getClubRecentActiveListWithClubId:(NSUInteger)clubId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/org/acts_v2" params:@{@"orgId": @(clubId), @"page": @(page), @"size": @(size)} responseClass:[ActiveListEntity class] success:success failure:failure];
}

+ (void)getClubPastActiveListWithClubId:(NSUInteger)clubId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(NewsListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/org/pastEvents_v2" params:@{@"orgId": @(clubId), @"page": @(page), @"size": @(size)} responseClass:[NewsListEntity class] success:success failure:failure];
}


+ (void)getClubManagerListWithClubId:(NSUInteger)clubId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(FriendListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/org/managers_v2" params:@{@"orgId": @(clubId), @"page": @(page), @"size": @(size)} responseClass:[FriendListEntity class] success:success failure:failure];
}

+ (void)getClubMemberListWithClubId:(NSUInteger)clubId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(FriendListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/org/lovs_v2" params:@{@"orgId": @(clubId), @"page": @(page), @"size": @(size)} responseClass:[FriendListEntity class] success:success failure:failure];
}

@end
