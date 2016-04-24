//
//  Network+AboutUs.h
//  Gather
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"

@interface Network (AboutUs)

+ (void)feedbackWithCityId:(NSUInteger)cityId content:(NSString *)content imgIds:(NSArray *)imgIds lon:(CGFloat)lon lat:(CGFloat)lat locationAddress:(NSString *)locationAddress success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
