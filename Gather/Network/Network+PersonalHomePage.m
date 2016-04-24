//
//  Network+PersonalHomePage.m
//  Gather
//
//  Created by apple on 15/1/5.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+PersonalHomePage.h"

@implementation Network (PersonalHomePage)

+ (void)getPersonalHomePageInfoWithUserId:(NSUInteger)userId cityId:(NSUInteger)cityId  success:(void (^)(PersonalHomePageEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId > 0) {
        [params setObject:@(userId) forKey:@"uid"];
    }
    if (cityId > 0) {
        [params setObject:@(cityId) forKey:@"cityId"];
    }
    
    [self GET:@"act/user/profile" params:params responseClass:[PersonalHomePageEntity class] success:success failure:failure];
}

@end
