//
//  Network+CityList.m
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+CityList.h"

@implementation Network (CityList)

+ (void)getCityListWithSuccess:(void (^)(CityListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/city/cities" params:nil responseClass:[CityListEntity class] success:success failure:failure];
}

@end
