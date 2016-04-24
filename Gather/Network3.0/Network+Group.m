//
//  Network+Group.m
//  Gather
//
//  Created by apple on 15/3/18.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+Group.h"

@implementation Network (Group)

+ (void)getMessageBoardListWithActiveId:(NSUInteger)activeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(GroupMessageBoardListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/messages_v2" params:@{@"actId":@(activeId), @"page": @(page), @"size": @(size)} responseClass:[GroupMessageBoardListEntity class] success:success failure:failure];
}

+ (void)getMemberListWithActiveId:(NSUInteger)activeId cityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(FriendListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/members_v2" params:@{@"actId":@(activeId), @"cityId": @(cityId), @"page": @(page), @"size": @(size)} responseClass:[FriendListEntity class] success:success failure:failure];
}

+ (void)getAdministratorListWithActiveId:(NSUInteger)activeId cityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(FriendListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/managers_v2" params:@{@"actId":@(activeId), @"cityId": @(cityId), @"page": @(page), @"size": @(size)} responseClass:[FriendListEntity class] success:success failure:failure];
}

+ (void)getActiveConfigWithActiveId:(NSUInteger)activeId success:(void (^)(ActiveConfigEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/modules_v2" params:@{@"actId":@(activeId)} responseClass:[ActiveConfigEntity class] success:success failure:failure];
}

+ (void)getActiveMoreConfigWithActiveId:(NSUInteger)activeId success:(void (^)(ActiveMoreConfigEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/moreInfo_v2" params:@{@"actId":@(activeId)} responseClass:[ActiveMoreConfigEntity class] success:success failure:failure];
}


+ (void)sendMsg:(NSUInteger)activeId content:(NSString *)content success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/actMore/sendMsg_v2" params:@{@"actId":@(activeId), @"content": content} success:success failure:failure];
}


+ (void)getMyGroupMemberListWithGroupId:(NSUInteger)groupId cityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(FriendListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/groupUsers_v2" params:@{@"groupId":@(groupId), @"cityId": @(cityId), @"page": @(page), @"size": @(size)} responseClass:[FriendListEntity class] success:success failure:failure];
}

+ (void)getGroupInfoWithGroupId:(NSUInteger)groupId success:(void (^)(ActiveGroupInfoEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/group_v2" params:@{@"groupId":@(groupId)} responseClass:[ActiveGroupInfoEntity class] success:success failure:failure];
}

+ (void)checkInWithId:(NSUInteger)checkInId lon:(double)lon lat:(double)lat address:(NSString *)address success:(void (^)(CheckInInfoEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/actMore/checkin_v2" params:@{@"checkinId": @(checkInId), @"lon": @(lon), @"lat": @(lat), @"address": address} success:^(id response) {
        CheckInInfoEntity *entity = [[CheckInInfoEntity alloc] initWithDictionary:response];
        success(entity);
    }failure:failure];
}

+ (void)getCheckInListWithActiveId:(NSUInteger)activeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(CheckInInfoListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/checkins_v2" params:@{@"actId": @(activeId), @"page": @(page), @"size": @(size)} responseClass:[CheckInInfoListEntity class] success:success failure:failure];
}

+ (void)confirmCheckInWithId:(NSUInteger)checkInId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/actMore/sureCheckin_v2" params:@{@"checkinId": @(checkInId)} success:success failure:failure];
}

@end
