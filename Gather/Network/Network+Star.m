//
//  Network+Star.m
//  Gather
//
//  Created by apple on 15/1/20.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+Star.h"

@implementation Network (Star)

+ (void)getStarInfoListWithCityId:(NSUInteger)cityId tagId:(NSUInteger)tagId sex:(Sex)sex userTagId:(NSUInteger)userTagId keyWords:(NSString *)keyWords page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(StarListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (cityId > 0) {
        [params setObject:@(cityId) forKey:@"cityId"];
    }
    if (tagId > 0) {
        [params setObject:@(tagId) forKey:@"tagId"];
    }
    if (sex > 0) {
        [params setObject:@(sex) forKey:@"sex"];
    }
    if (userTagId > 0) {
        [params setObject:@(userTagId) forKey:@"userTagId"];
    }
    if (!string_is_empty(keyWords)) {
        [params setObject:keyWords forKey:@"keyWords"];
    }
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    
    [self GET:@"act/vip/users" params:params responseClass:[StarListEntity class] success:success failure:failure];
}

@end
