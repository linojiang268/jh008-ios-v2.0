//
//  Network+Dynamic.h
//  Gather
//
//  Created by apple on 15/1/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "DynamicListEntity.h"
#import "DynamicCommentListEntity.h"

@interface Network (Dynamic)

+ (void)getAllDynamicWithUserId:(NSUInteger)userId cityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(DynamicListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getDynamicDetailWithDynamicId:(NSUInteger)dynamicId success:(void (^)(DynamicEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getPersonalDynamicWithUserId:(NSUInteger)userId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(DynamicListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getDynamicCommentWithDynamicId:(NSUInteger)dynamicId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(DynamicCommentListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)addCommentWithDynamicId:(NSUInteger)dynamicId atId:(NSUInteger)atId content:(NSString *)content success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;;

+ (void)deleteDynamicWithDynamicId:(NSUInteger)dynamicId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;;

+ (void)deleteDynamicCommnetWithDynamicId:(NSUInteger)commentId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;;

@end
