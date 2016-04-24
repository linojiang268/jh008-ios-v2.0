//
//  Network+Banner.h
//  Gather
//
//  Created by apple on 15/2/3.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "NewsListEntity.h"

@interface Network (Banner)

+ (void)getBannerListWithCityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(NewsListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
