//
//  SelectPayWayViewController.m
//  Gather
//
//  Created by apple on 15/4/16.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "SelectPayWayViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "Network+Apply30.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

#import "WXApi.h"

@interface SelectPayWayViewController () {
    
}

@property (nonatomic, strong) OrderEntity *orderInfo;

@property (nonatomic, assign) PayPlatformType payWay;

@property (weak, nonatomic) IBOutlet UIButton *alipayButton;
@property (weak, nonatomic) IBOutlet UIButton *weChatButton;

@end

@implementation SelectPayWayViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWE_CHAT_PAY_END_NOTIFICATION_NAME object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.alipayButton.layer.masksToBounds = YES;
    self.alipayButton.layer.borderColor = [color_with_hex(kColor_c9c9c9) CGColor];
    self.alipayButton.layer.borderWidth = 1.0;
    self.alipayButton.layer.cornerRadius = 2.0;
    self.weChatButton.layer.masksToBounds = YES;
    self.weChatButton.layer.borderColor = [color_with_hex(kColor_c9c9c9) CGColor];
    self.weChatButton.layer.borderWidth = 1.0;
    self.weChatButton.layer.cornerRadius = 2.0;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayEnd:) name:kWE_CHAT_PAY_END_NOTIFICATION_NAME object:nil];
}

- (void)weChatPayEnd:(NSNotification *)noti {
    
    NSDictionary *dict = noti.object;
    if (dict.count > 0) {
        BOOL result = [[dict objectForKey:@"result"] boolValue];
        if (result) {
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kPAY_END_NOTIFICATION_NAME object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"支付失败，请重试"];
        }
    }
}

- (IBAction)alipay:(id)sender {
    _payWay = PayPlatformTypeAlipay;
    [self placeOrder];
}

- (IBAction)weChat:(id)sender {
    if (![WXApi isWXAppInstalled]) {
        [SVProgressHUD showInfoWithStatus:@"请先安装微信"];
    }else if (![WXApi isWXAppSupportApi]) {
        [SVProgressHUD showInfoWithStatus:@"当前版本的微信不支持支付"];
    }else {
        _payWay = PayPlatformTypeWeChat;
        [self placeOrder];
    }
}

- (void)placeOrder {
    
    __weak typeof(self) wself = self;
    [Network placeOrderWithProductId:self.product.id number:1 payPlatform:_payWay success:^(OrderEntity *entity) {
        wself.orderInfo = entity;
        if (wself.payWay == PayPlatformTypeAlipay) {
            [wself alipay];
        }else if (wself.payWay == PayPlatformTypeWeChat) {
            [wself weChatPay];
        }
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"订单创建失败，请重试"];
    }];
}

- (void)alipay {
    Order *order = [[Order alloc] init];
    order.partner = kAliPay_Partner;
    order.seller = kAliPay_Seller;
    order.tradeNO = self.orderInfo.trade_no; //订单ID(由商家□自□行制定)
    order.productName = self.product.subject; //商品标题
    order.productDescription = self.product.body; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",self.product.unit_price]; //商 品价格
    order.notifyURL = kAliPay_Callback_URL; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"comzero2allgather";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description]; NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(kAliPay_RSA_Private);
    NSString *signedString = [signer signString:orderSpec];
    
    if (signedString != nil) {
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
        
        __weak typeof(self) wself = self;
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            log_value(@"%@______%@",resultDic,[resultDic objectForKey:@"memo"]);
            
            int status = [[resultDic objectForKey:@"resultStatus"] intValue];
            
            switch (status) {
                case 9000:
                    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPAY_END_NOTIFICATION_NAME object:nil];
                    [wself.navigationController popViewControllerAnimated:YES];
                    break;
                case 8000:
                    [SVProgressHUD showWithStatus:@"支付中"];
                    break;
                case 4000:
                    [SVProgressHUD showErrorWithStatus:@"支付失败"];
                    break;
                case 6001:
                    //[SVProgressHUD showSuccessWithStatus:@"支付取消"];
                    break;
                case 6002:
                    [SVProgressHUD showSuccessWithStatus:@"网络异常"];
                    break;
            }
        }];
    }
}

//md5 encode
- (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", WE_CHAT_SECRET_ID];
    //得到MD5 sign签名
    NSString *md5Sign =[self md5:contentString];
    
    return md5Sign;
}

- (void)weChatPay {
    if (self.orderInfo) {
        
        time_t now;
        time(&now);
        NSString *time_stamp  = [NSString stringWithFormat:@"%ld", now];
        
        //调起微信支付
        PayReq *req             = [[PayReq alloc] init];
        req.openID              = self.orderInfo.wx.appid;
        req.partnerId           = WE_CHAT_MCH_ID;
        req.prepayId            = self.orderInfo.wx.prepay_id;
        req.nonceStr            = self.orderInfo.wx.nonce_str;
        req.timeStamp           = time_stamp.intValue;
        req.package             = @"Sign=WXPay";
        
        //第二次签名参数列表
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        [signParams setObject:self.orderInfo.wx.appid forKey:@"appid"];
        [signParams setObject:self.orderInfo.wx.nonce_str forKey:@"noncestr"];
        [signParams setObject:@"Sign=WXPay" forKey:@"package"];
        [signParams setObject:WE_CHAT_MCH_ID forKey:@"partnerid"];
        [signParams setObject:time_stamp forKey:@"timestamp"];
        [signParams setObject:self.orderInfo.wx.prepay_id forKey:@"prepayid"];
        
        req.sign = [self createMd5Sign:signParams];
        
        [WXApi safeSendReq:req];
        //日志输出
        log_value(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
