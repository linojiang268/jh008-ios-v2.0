//
//  Network+ContactsList.h
//  Gather
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "ContactsListEntity.h"

@interface Network (Contacts)

+ (void)getContactsListWithCityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ContactsListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)deleteContactWithId:(NSUInteger)contactId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;;


@end
