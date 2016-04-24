//
//  Network+SystemMessage.m
//  Gather
//
//  Created by apple on 15/2/3.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+SystemMessage.h"

@implementation Network (SystemMessage)

+ (void)getSystemMessageListWithPage:(NSUInteger)page size:(NSUInteger)size success:(void (^)(SystemMessageListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/user/systemMsgs" params:@{@"page": @(page), @"size": @(size)} responseClass:[SystemMessageListEntity class] success:success failure:failure];
}

@end
