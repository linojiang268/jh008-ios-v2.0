//
//  Network+UserHobby.h
//  Gather
//
//  Created by apple on 14/12/31.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "Network.h"
#import "UserHobbyEntity.h"

@interface Network (UserHobby)

+ (void)getUserHobbyWithPage:(NSUInteger)page size:(NSUInteger)size uccess:(void (^)(UserHobbyEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
