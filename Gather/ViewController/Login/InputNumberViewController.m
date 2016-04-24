//
//  InputNumberViewController.m
//  Gather
//
//  Created by Ray on 14-12-23.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "InputNumberViewController.h"
#import "VerifyCodeViewController.h"
#import "NSString+Extend.h"
#import "Network+Account.h"

@interface InputNumberViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextfield;

@end

@implementation InputNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = self.title;
}


/// 进入验证码页面
- (void)rightItemButtonClick{
    if (![self.phoneNumberTextfield.text validateMobile]) {
        alert(nil, @"请输入正确的手机号码");
        return;
    }
    void(^next)(void) = ^{
        VerifyCodeViewController *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthCode"];
        nextController.phoneNumber = self.phoneNumberTextfield.text;
        nextController.pageType = self.pageType;
        [self.navigationController pushViewController:nextController animated:YES];
    };
    switch (self.pageType) {
        case VerifyCodeTypeNewUser: {
            SHOW_LOAD_HUD;
            [Network getAuthCodeWithNewPhoneNumber:self.phoneNumberTextfield.text success:^(id response) {
                DISMISS_HUD;
                next();
            } failure:^(NSString *errorMsg, StatusCode code) {
                if (code == StatusCodeUserNameExist) {
                    [SVProgressHUD showErrorWithStatus:@"手机号已注册，请直接登录"];
                }else {
                    [SVProgressHUD showErrorWithStatus:@"获取验证码失败，请重试"];
                }
            }];
        }
            break;
        case VerifyCodeTypeForgetPassword: {
            SHOW_LOAD_HUD;
            [Network getAuthCodeWithOldPhoneNumber:self.phoneNumberTextfield.text success:^(id response) {
                DISMISS_HUD;
                next();
            } failure:^(NSString *errorMsg, StatusCode code) {
                [SVProgressHUD showErrorWithStatus:@"获取验证码失败，请重试"];
            }];
        }
            break;
    }
}


@end
