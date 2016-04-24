//
//  Network+Strategy.h
//  Gather
//
//  Created by apple on 15/1/30.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "NewsListEntity.h"

@interface Network (News)

+ (void)getNewsListWithCityId:(NSUInteger)cityId tagId:(NSUInteger)tagId typeId:(NewsType)typeId keyWords:(NSString *)keyWords page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(NewsListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getNewsDetailWithNewsId:(NSUInteger)newsId success:(void (^)(NewsDetailEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)collectNewsWithId:(NSUInteger)newsId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)cancelCollectNewsWithId:(NSUInteger)newsId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)newsShareWithNewsId:(NSUInteger)newsId shareType:(GatherShareType)shareType success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getCollectNewsListWithUserId:(NSUInteger)userId typeId:(NewsType)typeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(NewsListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
