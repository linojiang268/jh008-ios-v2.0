//
//  Network+ActiveTagList.m
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+ActiveTagList.h"

@implementation Network (ActiveTagList)

+ (void)getActiveTagListWithPage:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveTagListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/tag/actTags" params:@{@"cityId": @([Common getCurrentCityId]), @"page": @(page), @"size": @(size)} responseClass:[ActiveTagListEntity class] success:success failure:failure];
}

@end
