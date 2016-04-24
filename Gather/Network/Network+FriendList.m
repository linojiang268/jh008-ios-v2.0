//
//  Network+FriendList.m
//  Gather
//
//  Created by apple on 14/12/31.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "Network+FriendList.h"

@implementation Network (FriendList)

+ (void)getListWithType:(FriendType)type uid:(NSUInteger)uid cityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size uccess:(void (^)(FriendListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setObject:@(type) forKey:@"type"];
    if (uid > 0) {
        [parms setObject:@(uid) forKey:@"uid"];
    }
    [parms setObject:@(cityId) forKey:@"cityId"];
    [parms setObject:@(page) forKey:@"page"];
    [parms setObject:@(size) forKey:@"size"];
    [self GET:@"act/friend/list" params:parms responseClass:[FriendListEntity class] success:success failure:failure];
}

+ (void)addFocusWithUserId:(NSUInteger)userId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/friend/add" params:@{@"focusId": @(userId)} success:success failure:failure];
}

+ (void)cancelFocusWithUserId:(NSUInteger)userId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/friend/delete" params:@{@"focusId": @(userId)} success:success failure:failure];
}

@end
