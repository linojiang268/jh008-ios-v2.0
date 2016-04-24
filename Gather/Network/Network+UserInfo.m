//
//  Network+UserInfo.m
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "Network+UserInfo.h"

@implementation Network (UserInfo)

+ (void)getUserInfoWithUserId:(NSUInteger)userId cityID:(NSUInteger)cityID success:(void (^)(FullUserInfoEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    if (userId > 0) {
        [parms setObject:@(userId) forKey:@"uid"];
    }
    [parms setObject:@(cityID) forKey:@"cityId"];
    [self GET:@"act/user/fullprofile" params:parms responseClass:[FullUserInfoEntity class] success:success failure:failure];
}

+ (void)updateUserInfoWithParams:(NSDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/user/updateFullprofile" params:params success:success failure:failure];
}

+ (void)getInterviewInfoWithUserId:(NSUInteger)userId success:(void (^)(NewsListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    if (userId > 0) {
        [parms setObject:@(userId) forKey:@"uid"];
    }
    [self GET:@"act/vip/interview" params:parms responseClass:[NewsListEntity class] success:success failure:failure];
}

@end
