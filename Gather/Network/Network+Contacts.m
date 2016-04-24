//
//  Network+ContactsList.m
//  Gather
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+Contacts.h"

@implementation Network (Contacts)

+ (void)getContactsListWithCityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ContactsListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(cityId) forKey:@"cityId"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    [self GET:@"act/message/contacts" params:params responseClass:[ContactsListEntity class] success:success failure:failure];
}

+ (void)deleteContactWithId:(NSUInteger)contactId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/message/delContact" params:@{@"contactId": @(contactId)} success:success failure:failure];
}

@end
