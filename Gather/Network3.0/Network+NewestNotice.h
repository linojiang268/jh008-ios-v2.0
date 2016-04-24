//
//  Network+NewestNotice.h
//  Gather
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "NewestNoticeListEntity.h"

@interface Network (NewestNotice)

+ (void)getNewestNoticeListWithActiveId:(NSUInteger)activeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(NewestNoticeListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
