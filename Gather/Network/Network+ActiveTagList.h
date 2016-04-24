//
//  Network+ActiveTagList.h
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "ActiveTagListEntity.h"

@interface Network (ActiveTagList)

+ (void)getActiveTagListWithPage:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveTagListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
