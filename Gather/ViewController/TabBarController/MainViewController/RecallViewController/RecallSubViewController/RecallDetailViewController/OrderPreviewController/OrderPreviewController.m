//
//  OrderPreviewController.m
//  Gather
//
//  Created by apple on 15/3/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "OrderPreviewController.h"
#import "OrderPreviewTableViewCell.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@interface OrderPreviewController ()

@property (nonatomic, strong) NSArray *cellTitles;

@end

@implementation OrderPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellTitles = @[@"商品名称",@"商品描述",@"收款方",@"付款方式",@"订单编号",@"支付金额"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        OrderPreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLabel.text = self.cellTitles[indexPath.row];
        switch (indexPath.row) {
            case 0:
                cell.subTitleLabel.text = self.goodsInfo.title;
                break;
            case 1:
                cell.subTitleLabel.text = self.goodsInfo.intro;
                break;
            case 2:
                cell.subTitleLabel.text = @"成都零创科技有限公司";
                break;
            case 3:
                cell.subTitleLabel.text = @"支付宝";
                break;
            case 4:
                cell.subTitleLabel.text = self.orderNumber;
                break;
            case 5:
                cell.subTitleLabel.text = [NSString stringWithFormat:@"¥%.2f",self.goodsInfo.price];
                cell.subTitleLabel.textColor = color_with_hex(kColor_ff9933);
                break;
        }
        
        return cell;
    }
    return [tableView dequeueReusableCellWithIdentifier:@"PayCell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        Order *order = [[Order alloc] init];
        order.partner = kAliPay_Partner;
        order.seller = kAliPay_Seller;
        order.tradeNO = self.orderNumber; //订单ID(由商家□自□行制定)
        order.productName = self.goodsInfo.title; //商品标题
        order.productDescription = self.goodsInfo.intro; //商品描述
        order.amount = [NSString stringWithFormat:@"%.2f",self.goodsInfo.price]; //商 品价格
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
                
                NSLog(@"%@______%@",resultDic,[resultDic objectForKey:@"memo"]);
                
                int status = [[resultDic objectForKey:@"resultStatus"] intValue];
                
                switch (status) {
                    case 9000:
                        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
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
}

@end
