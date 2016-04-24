//
//  Network+Pay.m
//  Gather
//
//  Created by apple on 15/3/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+Pay.h"

@implementation Network (Pay)

+ (void)getOrderNumberWithGoodsName:(NSString *)goodsName goodsDesc:(NSString *)goodsDesc totalFee:(CGFloat)totalFee success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (!string_is_empty(goodsName)) {
        [params setObject:goodsName forKey:@"subject"];
    }
    if (!string_is_empty(goodsDesc)) {
        [params setObject:goodsDesc forKey:@"body"];
    }
    [params setObject:[NSNumber numberWithFloat:totalFee] forKey:@"totalFee"];
    
    [self POST:@"act/pay/createOrder" params:params success:success failure:failure];
}

@end
