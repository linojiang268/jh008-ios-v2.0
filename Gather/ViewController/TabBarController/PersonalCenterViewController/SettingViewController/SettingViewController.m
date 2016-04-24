//
//  SettingViewController.m
//  Gather
//
//  Created by apple on 15/1/31.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "SettingViewController.h"
#import "ShareViewController.h"
#import "ShowMaskViewController.h"
#import <StoreKit/StoreKit.h>
#import "AboutUsViewController.h"

@interface SettingViewController ()<SKStoreProductViewControllerDelegate>

@property (nonatomic, strong) ShareViewController *shareController;

@end

@implementation SettingViewController

- (ShareViewController *)shareController {
    if (!_shareController) {
        _shareController = [[ShareViewController alloc] init];
        
        /*id<ISSContent> content = [ShareSDK content:self.newsInfo.intro defaultContent:nil image:nil title:self.newsInfo.title url:self.newsInfo.detail_url description:nil mediaType:SSPublishContentMediaTypeNews];
        
        _shareController.sharedId = self.newsInfo.id;*/
        //_shareController.content = content;
    }
    return _shareController;
}

- (void)share {
    
    ShowMaskViewController *controlelr = [ShowMaskViewController sharedController];
    [controlelr showInWindow:self.view.window otherView:self.shareController.view];
    [self.shareController cancelHandler:^{
        [[ShowMaskViewController sharedController] dismiss];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 20;
            break;
        case 1:
            return 20;
            break;
    }
    return 40;
}

- (void)clearCookies {
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [storage cookiesForURL:[NSURL URLWithString:kSERVER_BASE_URL]];
    [cookies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [storage deleteCookie:obj];
    }];
}

- (void)logout {
    __weak typeof(self) wself = self;
    [[[BlockAlertView alloc] initWithTitle:nil message:@"您确定要退出登录？" handler:^(UIAlertView *alertView, NSUInteger index) {
        
        if (index) {
            [Common setIsLogin:NO];
            [Common saveSelfUserInfo:nil];
            [Common setCurrentUsesrId:@(0)];
            [wself clearCookies];
            [wself.tabBarController setSelectedIndex:0];
            [wself.navigationController popViewControllerAnimated:YES];
            [(AppDelegate *)[UIApplication sharedApplication].delegate
             showLoginView];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定"] show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
//                case 0:
//                {
//                    [Common checkVersionUpdateWithManual:YES];
//                }
//                    break;
                case 0:
                {
                    [Common skipToGradePageWithPresentingController:self];
                }
                    break;
                case 1:
                {
                    [[[BlockAlertView alloc] initWithTitle:nil message:@"您确定要清理缓存？" handler:^(UIAlertView *alertView, NSUInteger index) {
                        
                        if (index) {
                            SHOW_LOAD_HUD;
                            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                                [SVProgressHUD showSuccessWithStatus:@"清理成功"];
                            }];
                        }
                    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定"] show];
                    
                }
                    break;
                case 2:
                {
                    /**
                     *  V2.2 新增
                     */
                    AboutUsViewController *controller = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"AboutUs"];
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
            break;
//        case 1:
//        {
//            [self share];
//        }
            break;
        case 1:
        {
            [self logout];
        }
            break;
    }
}

@end
