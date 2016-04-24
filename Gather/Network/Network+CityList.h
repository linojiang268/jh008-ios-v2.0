//
//  Network+CityList.h
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "CityListEntity.h"

@interface Network (CityList)

+ (void)getCityListWithSuccess:(void (^)(CityListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
