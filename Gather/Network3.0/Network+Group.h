//
//  Network+Group.h
//  Gather
//
//  Created by apple on 15/3/18.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "FriendListEntity.h"
#import "ActiveConfigEntity.h"
#import "GroupMessageBoardListEntity.h"
#import "ActiveGroupInfoEntity.h"
#import "CheckInInfoListEntity.h"

@interface Network (Group)

+ (void)getMessageBoardListWithActiveId:(NSUInteger)activeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(GroupMessageBoardListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getMemberListWithActiveId:(NSUInteger)activeId cityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(FriendListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getAdministratorListWithActiveId:(NSUInteger)activeId cityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(FriendListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getActiveConfigWithActiveId:(NSUInteger)activeId success:(void (^)(ActiveConfigEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getActiveMoreConfigWithActiveId:(NSUInteger)activeId success:(void (^)(ActiveMoreConfigEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)sendMsg:(NSUInteger)activeId content:(NSString *)content success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getMyGroupMemberListWithGroupId:(NSUInteger)groupId cityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(FriendListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getGroupInfoWithGroupId:(NSUInteger)groupId success:(void (^)(ActiveGroupInfoEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)checkInWithId:(NSUInteger)checkInId lon:(double)lon lat:(double)lat address:(NSString *)address success:(void (^)(CheckInInfoEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getCheckInListWithActiveId:(NSUInteger)activeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(CheckInInfoListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)confirmCheckInWithId:(NSUInteger)checkInId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;


@end
