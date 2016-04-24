//
//  Network+IndividualityTagList.m
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+Tag.h"

@implementation Network (Tag)

+ (void)getTagListWithType:(TagType)tagType page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(TagListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/tag/userTags" params:@{@"type": @(tagType), @"page": @(page), @"size": @(size)} responseClass:[TagListEntity class] success:^(id entity) {
        
        TagListEntity *temp = entity;
        if (tagType == TagTypeCategory) {
            [Common setCategoryTagList:temp.sourceJson];
        }
        if (tagType == TagTypeIndividuality) {
            [Common setIndividualityTagList:temp.sourceJson];
        }
        success(entity);
    } failure:failure];
}

@end
