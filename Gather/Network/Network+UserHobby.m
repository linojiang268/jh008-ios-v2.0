//
//  Network+UserHobby.m
//  Gather
//
//  Created by apple on 14/12/31.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "Network+UserHobby.h"

@implementation Network (UserHobby)

+ (void)getUserHobbyWithPage:(NSUInteger)page size:(NSUInteger)size uccess:(void (^)(UserHobbyEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/tag/userLovTags" params:@{@"page": @(page), @"size": @(size)} responseClass:[UserHobbyEntity class] success:success failure:failure];
}

@end
