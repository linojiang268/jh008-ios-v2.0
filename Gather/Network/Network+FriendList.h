//
//  Network+FriendList.h
//  Gather
//
//  Created by apple on 14/12/31.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "Network.h"
#import "FriendListEntity.h"

@interface Network (FriendList)

+ (void)getListWithType:(FriendType)type uid:(NSUInteger)uid cityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size uccess:(void (^)(FriendListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)addFocusWithUserId:(NSUInteger)userId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;
+ (void)cancelFocusWithUserId:(NSUInteger)userId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
