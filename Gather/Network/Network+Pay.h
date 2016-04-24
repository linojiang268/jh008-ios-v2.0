//
//  Network+Pay.h
//  Gather
//
//  Created by apple on 15/3/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"

@interface Network (Pay)

+ (void)getOrderNumberWithGoodsName:(NSString *)goodsName goodsDesc:(NSString *)goodsDesc totalFee:(CGFloat)totalFee success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
