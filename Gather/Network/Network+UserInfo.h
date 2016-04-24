//
//  Network+UserInfo.h
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "Network.h"
#import "FullUserInfoEntity.h"
#import "NewsListEntity.h"

@interface Network (UserInfo)

/// 自己不需要传uid
+ (void)getUserInfoWithUserId:(NSUInteger)userId cityID:(NSUInteger)cityID success:(void (^)(FullUserInfoEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;
+ (void)updateUserInfoWithParams:(NSDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getInterviewInfoWithUserId:(NSUInteger)userId success:(void (^)(NewsListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;


@end
