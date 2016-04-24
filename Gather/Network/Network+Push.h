//
//  Network+Push.h
//  Gather
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"

typedef NS_ENUM(NSUInteger, PlatformType) {
    PlatformTypeAndroid = 3,
    PlatformTypeIos     = 4,
};

@interface Network (Push)

+ (void)setUpWithCityId:(NSUInteger)cityId platform:(PlatformType)platform baiduUserId:(NSString *)baiduUserId baiduChannelId:(NSString *)baiduChannelId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)pushMsgWithUserId:(NSString *)user_id
               channel_id:(NSString *)channel_id
              device_type:(NSUInteger)device_type
                 messages:(NSString *)messages;

@end
