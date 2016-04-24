//
//  Network+Account.m
//  Gather
//
//  Created by Ray on 14-12-23.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "Network+Account.h"
#import <ShareSDK/ShareSDK.h>

@implementation Network (Account)

+ (void)getAuthCodeWithNewPhoneNumber:(NSString *)number success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"user/userInfo/newPhone" params:@{@"phoneNum": number} success:success failure:failure];
}

+ (void)getAuthCodeWithOldPhoneNumber:(NSString *)number success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"user/userInfo/getPhCode" params:@{@"phoneNum": number} success:success failure:failure];
}

+ (void)verifyAuthCodeWithType:(VerifyCodeType)type PhoneNumber:(NSString *)number code:(NSString *)code  success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"user/userInfo/validPhCode" params:@{@"type": @(type), @"phoneNum": number, @"idfyCode": code} success:success failure:failure];
}

+ (void)perfectInfoWithNickname:(NSString *)nickname password:(NSString *)password sex:(Sex)sex birthDay:(NSString *)birthDay address:(NSString *)address email:(NSString *)email headImageId:(NSUInteger)headImageId  success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (!string_is_empty(nickname)) {
        [dict setObject:nickname forKey:@"nickName"];
    }
    if (!string_is_empty(password)) {
        [dict setObject:password forKey:@"userPass"];
    }
    if (sex) {
        [dict setObject:@(sex) forKey:@"sex"];
    }
    if (!string_is_empty(birthDay)) {
        [dict setObject:birthDay forKey:@"birth"];
    }
    if (!string_is_empty(address)) {
        [dict setObject:address forKey:@"address"];
    }
    if (!string_is_empty(email)) {
        [dict setObject:email forKey:@"email"];
    }
    if (headImageId) {
        [dict setObject:@(headImageId) forKey:@"headImgId"];
    }
    [self POST:@"user/userInfo/regiInfo" params:dict success:success failure:failure];
}

+ (void)getUserInterestTagWithSuccess:(void (^)(InterestTagListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/tagInfo/getUTags" params:nil responseClass:[InterestTagListEntity class] success:success failure:failure];
}

+ (void)updatePassword:(NSString *)newPassword success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"user/userInfo/phRePass" params:@{@"newPass": newPassword} success:success failure:failure];
}

+ (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@(1) forKey:@"loginType"];
    if (!string_is_empty(phoneNumber)) {
        [dict setObject:phoneNumber forKey:@"loginName"];
    }
    if (!string_is_empty(password)) {
        [dict setObject:password forKey:@"userPass"];
    }
    [self POST:@"user/userInfo/login" params:dict success:success failure:failure];
}

+ (void)loginWithLoginType:(LoginType)loginType success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    if (!NETWORK_REACHABLE && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        return;
    }
    ShareType shareType;
    switch (loginType) {
        case LoginTypeQQ:
            shareType = ShareTypeQQSpace;
            break;
        case LoginTypeSinaWeibo:
            shareType = ShareTypeSinaWeibo;
            break;
        case LoginTypeWeChat:
            shareType = ShareTypeWeixiTimeline;
            break;
    }
    if (![[ShareSDK getClientWithType:shareType] isClientInstalled] && shareType != ShareTypeSinaWeibo) {
        [SVProgressHUD showErrorWithStatus:@"请先安装客户端"];
        return;
    }
    [ShareSDK getUserInfoWithType:shareType authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result) {
            id<ISSPlatformCredential> temp = [userInfo credential];
            SHOW_LOAD_HUD;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@(loginType) forKey:@"loginType"];
            [dict setObject:[temp uid] forKey:@"openid"];
            [dict setObject:[temp token] forKey:@"token"];
            [dict setObject:@([[temp expired] timeIntervalSince1970]) forKey:@"expiressIn"];
            [self POST:@"user/userInfo/login" params:dict success:success failure:failure];
        }else {
            if (error) {
                log_error(@"%@______%@_______%d",error,[error errorDescription],[error errorCode]);
            }
            if ([error errorCode] != -103) {
                [SVProgressHUD showErrorWithStatus:@"授权失败"];
            }else {
                DISMISS_HUD;
            }
        }
    }];
}

@end
