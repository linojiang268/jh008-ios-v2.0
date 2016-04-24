//
//  LoginViewController.m
//  Gather
//
//  Created by Ray on 14-12-23.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "LoginViewController.h"
#import "InputNumberViewController.h"
#import "NSString+Extend.h"
#import "Network+Account.h"
#import "NSUserDefaults+Extend.h"
#import "Network+UserInfo.h"
#import "PerfectInfoViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApi.h>
#import "WXApi.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UIButton *weiboButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wechatMarginLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqMarginRight;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) wself = self;
    [self.navigationItem addLeftItem:[[BlockBarButtonItem alloc] initWithImage:image_with_name(@"btn_login_back") highlight:nil clickHandler:^(BlockBarButtonItem *item) {
        [wself back:nil];
    }]];
    
    BOOL qqIsInstalled = [QQApi isQQInstalled];
    BOOL wechatIsInstalled = [WXApi isWXAppInstalled];
    
    if (!wechatIsInstalled && !qqIsInstalled) {
        self.wechatButton.hidden = YES;
        self.qqButton.hidden = YES;
    }else {
        if (!wechatIsInstalled) {
            
            CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]) / 3;
            self.wechatMarginLeft.constant = -(width / 2);
            self.qqMarginRight.constant = width / 2;
            self.wechatButton.hidden = YES;
        }
        if (!qqIsInstalled) {
            
            CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]) / 3;
            self.wechatMarginLeft.constant = width / 2;
            self.qqMarginRight.constant = -(width / 2);
            self.qqButton.hidden = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainView];
}

- (IBAction)weChat:(id)sender {
    [self loginWithType:LoginTypeWeChat];
}

- (IBAction)weibo:(id)sender {
    [self loginWithType:LoginTypeSinaWeibo];
}

- (IBAction)qq:(id)sender {
    [self loginWithType:LoginTypeQQ];
}

- (void)loginWithType:(LoginType)loginType {
    
    __weak typeof(self) wself = self;
    [Network loginWithLoginType:loginType success:^(id response) {
        NSUInteger isRegist = [response[@"body"][@"is_regist"] intValue];
        DISMISS_HUD;
        if (isRegist > 0) {
            [Common setIsLogin:YES];
            [Common setCurrentUsesrId:@([response[@"body"][@"uid"] intValue])];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainView];
            if ([Common getCurrentCityId] > 0) {
                [Network getUserInfoWithUserId:[Common getCurrentUserId] cityID:[Common getCurrentCityId]
                                       success:^(FullUserInfoEntity *entity) {}
                                       failure:^(NSString *errorMsg, StatusCode code) {}];
            }
        }else {
            [Common setCurrentUsesrId:@([response[@"body"][@"uid"] intValue])];
            PerfectInfoViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"PerfectInfo"];
            controller.isPhoneRegistered = NO;
            [self.navigationController pushViewController:controller animated:YES];
        }
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }];
}

- (void)rightItemButtonClick {
    if (string_is_empty(self.phoneTextfield.text)){
         alert(nil, @"请输入手机号");
        return;
    }
    if (![self.phoneTextfield.text validateMobile]){
        alert(nil, @"请输入正确的手机号");
        return;
    }
    if (string_is_empty(self.passwordTextfield.text)) {
        alert(nil, @"请输入密码");
        return;
    }
    
    if (self.passwordTextfield.text.length < 6 || self.passwordTextfield.text.length > 18) {
        alert(nil, @"密码长度为6-18位");
        return;
    }
    
    [self login];
}

- (void)login {
    
    [self.view endEditing:YES];
    SHOW_LOAD_HUD;
    [Network loginWithPhoneNumber:self.phoneTextfield.text password:[[self.passwordTextfield.text md5] lowercaseString] success:^(id response) {
        DISMISS_HUD;
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainView];
        [Common setIsLogin:YES];
        [Common setCurrentUsesrId:@([response[@"body"][@"uid"] intValue])];
        if ([Common getCurrentCityId]) {
            [Network getUserInfoWithUserId:[Common getCurrentUserId] cityID:[Common getCurrentCityId]
                                   success:^(FullUserInfoEntity *entity) {}
                                   failure:^(NSString *errorMsg, StatusCode code) {}];
        }
    } failure:^(NSString *errorMsg, StatusCode code) {
        if (code == StatusCodeUserNameInvalid || code == StatusCodeUserNameOrUserPassInvalid) {
            [SVProgressHUD showErrorWithStatus:@"用户名或密码错误"];
        }else {
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    InputNumberViewController *nextController = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"ForgetPassword"]){
        nextController.title = @"找回密码";
        nextController.pageType = VerifyCodeTypeForgetPassword;
    }else {
        nextController.title = @"手机注册";
        nextController.pageType = VerifyCodeTypeNewUser;
    }
}


@end
