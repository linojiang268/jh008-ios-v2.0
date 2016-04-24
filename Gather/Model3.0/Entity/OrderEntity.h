//
//  OrderEntity.h
//  Gather
//
//  Created by apple on 15/4/16.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@interface OrderWeChatEntity : BaseEntity

/// 订单号
@property (nonatomic, assign) NSString *trade_no;

/// app id
@property (nonatomic, strong) NSString *appid;
/// 商户 id
@property (nonatomic, strong) NSString *mch_id;
/// 随机串 防重发
@property (nonatomic, strong) NSString *nonce_str;
/// 预支付订单 id
@property (nonatomic, strong) NSString *prepay_id;
/// 商家根据微信开放平台文档对数据做的签名
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *trade_type;

@property (nonatomic, strong) NSString *result_code;
@property (nonatomic, strong) NSString *return_code;
@property (nonatomic, strong) NSString *return_msg;

@end

@interface OrderEntity : BaseEntity

/// 订单号
@property (nonatomic, assign) NSString *trade_no;

@property (nonatomic, strong) OrderWeChatEntity *wx;

@end
