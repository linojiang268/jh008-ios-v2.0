//
//  Network+Banner.m
//  Gather
//
//  Created by apple on 15/2/3.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+Banner.h"

@implementation Network (Banner)

+ (void)getBannerListWithCityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(NewsListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (cityId > 0) {
        [params setObject:@(cityId) forKey:@"cityId"];
    }
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    
    [self GET:@"act/news/homeAdverts" params:params responseClass:[NewsListEntity class] success:success failure:failure];
}

@end
