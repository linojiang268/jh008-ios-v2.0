//
//  Network+Strategy.m
//  Gather
//
//  Created by apple on 15/1/30.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+News.h"

@implementation Network (News)

+ (void)getNewsListWithCityId:(NSUInteger)cityId tagId:(NSUInteger)tagId typeId:(NewsType)typeId keyWords:(NSString *)keyWords page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(NewsListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (cityId > 0) {
        [params setObject:@(cityId) forKey:@"cityId"];
    }
    if (tagId > 0) {
        [params setObject:@(tagId) forKey:@"tagId"];
    }
    if (typeId > 0) {
        [params setObject:@(typeId) forKey:@"typeId"];
    }
    if (!string_is_empty(keyWords)) {
        [params setObject:keyWords forKey:@"keyWords"];
    }
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    
    [self GET:@"act/news/news" params:params responseClass:[NewsListEntity class] success:success failure:failure];
}

+ (void)getNewsDetailWithNewsId:(NSUInteger)newsId success:(void (^)(NewsDetailEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/news/newsInfo" params:@{@"newsId": @(newsId)} responseClass:[NewsDetailEntity class] success:success failure:failure];
}

+ (void)collectNewsWithId:(NSUInteger)newsId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/news/lov" params:@{@"newsId": @(newsId)} success:success failure:failure];
}

+ (void)cancelCollectNewsWithId:(NSUInteger)newsId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/news/delLov" params:@{@"newsId": @(newsId)} success:success failure:failure];
}

+ (void)newsShareWithNewsId:(NSUInteger)newsId shareType:(GatherShareType)shareType success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/news/share" params:@{@"newsId": @(newsId), @"shareType": @(shareType)} success:success failure:failure];
}

+ (void)getCollectNewsListWithUserId:(NSUInteger)userId typeId:(NewsType)typeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(NewsListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId > 0) {
        [params setObject:@(userId) forKey:@"uid"];
    }
    if (typeId > 0) {
        [params setObject:@(typeId) forKey:@"typeId"];
    }
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    
    [self GET:@"act/news/lovNews" params:params responseClass:[NewsListEntity class] success:success failure:failure];
}

@end
