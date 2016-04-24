//
//  Network+PersonalHomePage.h
//  Gather
//
//  Created by apple on 15/1/5.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "PersonalHomePageEntity.h"

@interface Network (PersonalHomePage)

+ (void)getPersonalHomePageInfoWithUserId:(NSUInteger)userId cityId:(NSUInteger)cityId success:(void (^)(PersonalHomePageEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
