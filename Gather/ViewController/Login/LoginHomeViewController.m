//
//  LoginHomeViewController.m
//  Gather
//
//  Created by Ray on 14-12-23.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "LoginHomeViewController.h"
#import "PerfectInfoViewController.h"
#import "Network+Account.h"
#import "Network+UserInfo.h"


@interface LoginHomeViewController ()

@end

@implementation LoginHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shouldHideNavigationBar = YES;
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
    
    SHOW_LOAD_HUD;
    __weak typeof(self) wself = self;
    [Network loginWithLoginType:loginType success:^(id response) {
        [SVProgressHUD showSuccessWithStatus:@"授权成功"];
        
        NSUInteger isRegist = [response[@"body"][@"is_regist"] intValue];
        
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
        [SVProgressHUD showErrorWithStatus:@"第三方登录失败"];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
