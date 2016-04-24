//
//  Network+Dynamic.m
//  Gather
//
//  Created by apple on 15/1/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+Dynamic.h"
#import "Network+UploadFile.h"

@implementation Network (Dynamic)

+ (void)getAllDynamicWithUserId:(NSUInteger)userId cityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(DynamicListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId > 0) {
        [params setObject:@(userId) forKey:@"uid"];
    }
    [params setObject:@(cityId) forKey:@"cityId"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    
    [self GET:@"act/dynamic/friends" params:params responseClass:[DynamicListEntity class] success:success failure:failure];
}

+ (void)getDynamicDetailWithDynamicId:(NSUInteger)dynamicId success:(void (^)(DynamicEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/dynamic/profile" params:@{@"dynamicId": @(dynamicId)} responseClass:[DynamicDetailEntity class] success:success failure:failure];
}

+ (void)getPersonalDynamicWithUserId:(NSUInteger)userId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(DynamicListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId > 0) {
        [params setObject:@(userId) forKey:@"uid"];
    }
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    
    [self GET:@"act/dynamic/list" params:params responseClass:[DynamicListEntity class] success:success failure:failure];

}

+ (void)getDynamicCommentWithDynamicId:(NSUInteger)dynamicId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(DynamicCommentListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/dynamic/comments" params:@{@"dynamicId": @(dynamicId), @"page": @(page), @"size": @(size)} responseClass:[DynamicCommentListEntity class] success:success failure:failure];
}

+ (void)addCommentWithDynamicId:(NSUInteger)dynamicId atId:(NSUInteger)atId content:(NSString *)content success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(dynamicId) forKey:@"dynamicId"];
    if (atId > 0) {
        [params setObject:@(atId) forKey:@"atId"];
    }
    [params setObject:content forKey:@"content"];
    
    [self POST:@"act/dynamic/addComment" params:params success:success failure:failure];
}

+ (void)deleteDynamicWithDynamicId:(NSUInteger)dynamicId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/dynamic/delete" params:@{@"dynamicId": @(dynamicId)} success:success failure:failure];
}

+ (void)deleteDynamicCommnetWithDynamicId:(NSUInteger)commentId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/dynamic/delComment" params:@{@"commentId": @(commentId)} success:success failure:failure];
}

@end
