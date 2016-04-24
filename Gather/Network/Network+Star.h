//
//  Network+Star.h
//  Gather
//
//  Created by apple on 15/1/20.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "StarListEntity.h"

@interface Network (Star)

+ (void)getStarInfoListWithCityId:(NSUInteger)cityId tagId:(NSUInteger)tagId sex:(Sex)sex userTagId:(NSUInteger)userTagId keyWords:(NSString *)keyWords page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(StarListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;


@end
