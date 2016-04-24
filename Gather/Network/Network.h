//
//  Network.h
//  Gather
//
//  Created by Ray on 14-12-23.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

/// 状态码
typedef NS_ENUM(NSUInteger, StatusCode) {
    StatusCodeNone                      = 0,
    StatusCodeUserNameInvalid           = 1,
    StatusCodeUserNameOrUserPassInvalid = 2,
    StatusCodeOpenTokenInvalid          = 3,
    StatusCodeRequestException          = 4,
    StatusCodeLoginInvalid              = 5,
    StatusCodeSMSSendFail               = 6,
    StatusCodePhoneCodeTimeout          = 7,
    StatusCodePhoneCodeWrong            = 8,
    StatusCodeOperationException        = 9,
    StatusCodeUserNameExist             = 10,
    StatusCodeParamsIllegal             = 11,
    StatusCodeOSSOperationException     = 12,
    StatusCodeFileOperationException    = 13,
    StatusCodeParseError                = 14,
    StatusCodeNetworkError              = 15
};

// 资讯类型
typedef NS_ENUM(NSUInteger, NewsType) {
    NewsTypeCollect     = 0,
    NewsTypeStrategy    = 1,
    NewsTypeRecall      = 2,
    NewsTypeTicket      = 3,
    NewsTypeInterview   = 4
};

static NSUInteger kActiveSize = 10;
static NSUInteger kActiveGroupSize = 50;
static NSUInteger kSize = 20;

@protocol AFMultipartFormData;
@class BaseEntity;
@interface Network : NSObject

+(AFHTTPRequestOperationManager *)manager;

+ (void)alertWithStatusCode:(StatusCode)code;

+ (void)GET:(NSString *)URLString params:(id)params responseClass:(Class)responseClass success:(void (^)(id entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;
+ (void)POST:(NSString *)URLString params:(id)params success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;
+ (void)POST:(NSString *)URLString params:(id)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
