//
//  Network+Club.h
//  Gather
//
//  Created by apple on 15/4/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "ClubListEntity.h"
#import "ActiveListEntity.h"
#import "NewsListEntity.h"
#import "FriendListEntity.h"

@interface Network (Club)

+ (void)getClubListWithCityId:(NSUInteger)cityId keyWords:(NSString *)keyWords page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ClubListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getClubDetailWithClubId:(NSUInteger)clubId success:(void (^)(ClubDetailEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)focusClubWithClubId:(NSUInteger)clubId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)cancelFocusClubWithClubId:(NSUInteger)clubId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getClubRecentActiveListWithClubId:(NSUInteger)clubId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getClubPastActiveListWithClubId:(NSUInteger)clubId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(NewsListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getClubManagerListWithClubId:(NSUInteger)clubId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(FriendListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getClubMemberListWithClubId:(NSUInteger)clubId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(FriendListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
