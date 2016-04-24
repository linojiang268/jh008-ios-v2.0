//
//  Network+NewestNotice.m
//  Gather
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+NewestNotice.h"

@implementation Network (NewestNotice)

+ (void)getNewestNoticeListWithActiveId:(NSUInteger)activeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(NewestNoticeListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/notices_v2" params:@{@"actId":@(activeId), @"page": @(page), @"size": @(size)} responseClass:[NewestNoticeListEntity class] success:success failure:failure];
}

@end
