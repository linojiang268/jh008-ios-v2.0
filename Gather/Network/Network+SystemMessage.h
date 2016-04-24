//
//  Network+SystemMessage.h
//  Gather
//
//  Created by apple on 15/2/3.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "SystemMessageListEntity.h"

@interface Network (SystemMessage)

+ (void)getSystemMessageListWithPage:(NSUInteger)page size:(NSUInteger)size success:(void (^)(SystemMessageListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;


@end
