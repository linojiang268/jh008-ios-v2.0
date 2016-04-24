//
//  Network+MessageRecordList.h
//  Gather
//
//  Created by apple on 15/1/8.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "MessageRecordListEntity.h"

@interface Network (Message)

+ (void)getRecordListWithContactId:(NSUInteger)contactId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(MessageRecordListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)sendMsg:(NSString *)msg revId:(NSUInteger)revId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)deleteMsg:(NSUInteger)msgId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)shieldingContact:(NSUInteger)userId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)cancelShieldingContact:(NSUInteger)userId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;


@end
