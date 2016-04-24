//
//  Network+Account.h
//  Gather
//
//  Created by Ray on 14-12-23.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "Network.h"
#import "InterestTagListEntity.h"

typedef NS_ENUM(NSUInteger, LoginType) {
    LoginTypeSinaWeibo      = 3,
    LoginTypeQQ             = 4,
    LoginTypeWeChat         = 5
};

@interface Network (Account)

+ (void)getAuthCodeWithNewPhoneNumber:(NSString *)number success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getAuthCodeWithOldPhoneNumber:(NSString *)number success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)verifyAuthCodeWithType:(VerifyCodeType)type PhoneNumber:(NSString *)number code:(NSString *)code success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)perfectInfoWithNickname:(NSString *)nickname password:(NSString *)password sex:(Sex)sex birthDay:(NSString *)birthDay address:(NSString *)address email:(NSString *)email headImageId:(NSUInteger)headImageId  success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getUserInterestTagWithSuccess:(void (^)(InterestTagListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)updatePassword:(NSString *)newPassword success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)loginWithLoginType:(LoginType)loginType success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;



@end
