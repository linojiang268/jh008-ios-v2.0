//
//  Network.m
//  Gather
//
//  Created by Ray on 14-12-23.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "Network.h"
#import "BaseEntity.h"

@implementation Network

+(AFHTTPRequestOperationManager *)manager{
    static AFHTTPRequestOperationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kSERVER_BASE_URL]];
    });
    return manager;
}

+ (void)alertWithStatusCode:(StatusCode)code {
    
    static NSDictionary *dict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = @{@(StatusCodeUserNameInvalid)   : @"用户名或密码错误",
                 @(StatusCodeUserNameOrUserPassInvalid): @"用户名或密码错误",
                 @(StatusCodeOpenTokenInvalid)  : @"第三方登录失败",
                 @(StatusCodeRequestException)  : @"请求异常",
                 @(StatusCodeLoginInvalid)      : @"请重新登录",
                 @(StatusCodePhoneCodeTimeout)  : @"验证码已过期，请重新获取",
                 @(StatusCodePhoneCodeWrong)    : @"验证码错误",
                 @(StatusCodeUserNameExist)     : @"用户名已存在,请直接登录",
                 @(StatusCodeNetworkError)      : @"网络异常",
                 };
    });
    if ([[dict allKeys] containsObject:@(code)]) {
        [SVProgressHUD showErrorWithStatus:dict[@(code)]];
    }
}

+ (void)needAgainLogin {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showNeedLoginView];
}

+ (void)GET:(NSString *)URLString params:(id)params responseClass:(Class)responseClass success:(void (^)(id entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure{
    
    if (!NETWORK_REACHABLE && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        failure(@"网络异常",StatusCodeNetworkError);
        return;
    }
    
    [[self manager] GET:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        log_value(@"response:%@____msg:%@____%@",responseObject,responseObject[@"msg"],URLString);
        NSUInteger statusCode = [responseObject[@"code"] intValue];
        if (statusCode == StatusCodeNone) {
            if (responseClass != NULL) {
                NSError *error = nil;
                if ([responseClass instancesRespondToSelector:@selector(initWithDictionary:error:)]) {
                    id entity = [[responseClass alloc] initWithDictionary:responseObject error:&error];
                    if(entity){
                        success(entity);
                    }else{
                        failure(@"解析数据失败", StatusCodeParseError);
                        log_error(@"解析数据失败,创建失败");
                    }
                }else {
                    failure(@"解析数据失败", StatusCodeParseError);
                    log_error(@"解析数据失败,responseClass设置错误");
                }
            }else {
                failure(@"解析数据失败", StatusCodeParseError);
                log_error(@"解析数据失败，未设置responseClass");
            }
        }else {
            NSString *errorMsg = [responseObject objectForKey:@"msg"];
            NSUInteger code = [[responseObject objectForKey:@"code"] intValue];
            log_error(@"error msg:%@,code:%lu",errorMsg,(unsigned long)code);
            
            if (code == StatusCodeLoginInvalid) {
                DISMISS_HUD;
                [self needAgainLogin];
            }else {
                failure(errorMsg, code);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(@"网络异常",StatusCodeNetworkError);
        log_error(@"%@___%@",error,URLString);
    }];
}

+ (void)POST:(NSString *)URLString params:(id)params success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    if (!NETWORK_REACHABLE && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        failure(@"网络异常",StatusCodeNetworkError);
        return;
    }
    [[self manager] POST:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        log_value(@"response:%@____msg:%@____%@",responseObject,responseObject[@"msg"],URLString);
        NSUInteger statusCode = [responseObject[@"code"] intValue];
        if (statusCode == StatusCodeNone) {
            success(responseObject);
        }else {
            NSString *errorMsg = [responseObject objectForKey:@"msg"];
            NSUInteger code = [[responseObject objectForKey:@"code"] intValue];
            log_error(@"error msg:%@,code:%lu",errorMsg,(unsigned long)code);
            
            if (code == StatusCodeLoginInvalid) {
                DISMISS_HUD;
                [self needAgainLogin];
            }else {
                failure(errorMsg, code);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(@"网络异常",StatusCodeNetworkError);
        log_error(@"%@___%@",error,URLString);
    }];
}

+ (void)POST:(NSString *)URLString params:(id)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    if (!NETWORK_REACHABLE && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        failure(@"网络异常",StatusCodeNetworkError);
        return;
    }
    [[self manager] POST:URLString parameters:params constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
        log_value(@"response:%@____msg:%@____%@",responseObject,responseObject[@"msg"],URLString);
        NSUInteger statusCode = [responseObject[@"code"] intValue];
        if (statusCode == StatusCodeNone) {
            success(responseObject);
        }else {
            NSString *errorMsg = [responseObject objectForKey:@"msg"];
            NSUInteger code = [[responseObject objectForKey:@"code"] intValue];
            log_error(@"error msg:%@,code:%lu",errorMsg,(unsigned long)code);
            
            if (code == StatusCodeLoginInvalid) {
                DISMISS_HUD;
                [self needAgainLogin];
            }else {
                failure(errorMsg, code);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(@"网络异常",StatusCodeNetworkError);
        log_error(@"%@___%@",error,URLString);
    }];
}

@end
