//
//  Network+MessageRecordList.m
//  Gather
//
//  Created by apple on 15/1/8.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+Message.h"

@implementation Network (Message)

+ (void)getRecordListWithContactId:(NSUInteger)contactId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(MessageRecordListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (contactId > 0) {
        [params setObject:@(contactId) forKey:@"contactId"];
    }
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    [self GET:@"act/message/history" params:params responseClass:[MessageRecordListEntity class] success:success failure:failure];
}

+ (void)sendMsg:(NSString *)msg revId:(NSUInteger)revId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/message/add" params:@{@"revId": @(revId), @"content": msg} success:success failure:failure];
}

+ (void)deleteMsg:(NSUInteger)msgId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/message/delete" params:@{@"messageId": @(msgId)} success:success failure:failure];
}

+ (void)shieldingContact:(NSUInteger)userId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/message/shieldContact" params:@{@"contactId": @(userId)} success:success failure:failure];
}

+ (void)cancelShieldingContact:(NSUInteger)userId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    [self POST:@"act/message/delShield" params:@{@"contactId": @(userId)} success:success failure:failure];
}

@end
