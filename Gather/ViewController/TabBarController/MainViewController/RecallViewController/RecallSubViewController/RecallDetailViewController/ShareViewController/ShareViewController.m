//
//  ShareViewController.m
//  Gather
//
//  Created by apple on 15/1/31.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ShareViewController.h"
#import "Network+News.h"
#import <TencentOpenAPI/QQApi.h>
#import "WXApi.h"

@interface ShareViewController ()

@property (weak, nonatomic) IBOutlet UIView *weChatView;
@property (weak, nonatomic) IBOutlet UIView *weChatFriendsView;
@property (weak, nonatomic) IBOutlet UIView *qqZoneView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sinaWeiboMarginLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqZoneMarginRight;

@property (nonatomic, copy) void(^cancelHandler)(void);

@end

@implementation ShareViewController

- (void)cancelHandler:(void(^)(void))cancelHandler {
    self.cancelHandler = cancelHandler;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL qqIsInstalled = [QQApi isQQInstalled];;
    BOOL wechatIsInstalled = [WXApi isWXAppInstalled];
    
    if (!wechatIsInstalled && !qqIsInstalled) {
        self.weChatView.hidden = YES;
        self.weChatFriendsView.hidden = YES;
        self.qqZoneView.hidden = YES;
        
        CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]) / 4;
        
        self.sinaWeiboMarginLeft.constant = (width * 2) - (width / 2);
        self.qqZoneMarginRight.constant = -((width * 2) - (width / 2));
    }else {
        if (!wechatIsInstalled) {
            self.weChatView.hidden = YES;
            self.weChatFriendsView.hidden = YES;
        }
        if (!qqIsInstalled) {
            
            CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]) / 4;
            self.sinaWeiboMarginLeft.constant = width / 2;
            self.qqZoneMarginRight.constant = -(width / 2);
            self.qqZoneView.hidden = YES;
        }
    }
}

- (IBAction)cancel:(id)sender {
    if (self.cancelHandler) {
        self.cancelHandler();
    }
}

- (IBAction)sinaWeibo:(id)sender {
    [self shareWithShareType:ShareTypeSinaWeibo activeShareType:GatherShareTypeSinaWeibo];
}

- (IBAction)weChat:(id)sender {
    [self shareWithShareType:ShareTypeWeixiSession activeShareType:GatherShareTypeWeChat];
}

- (IBAction)weChatFriends:(id)sender {
    [self shareWithShareType:ShareTypeWeixiTimeline activeShareType:GatherShareTypeWeChatFriend];
}

- (IBAction)QQZone:(id)sender {
    [self shareWithShareType:ShareTypeQQSpace activeShareType:GatherShareTypeQQZone];
}

- (void)shareWithShareType:(ShareType)shareType activeShareType:(GatherShareType)activeShareType  {
    [TalkingData trackEvent:[Common eventStringFromShareType:activeShareType]];
    [self cancel:nil];
    if (!NETWORK_REACHABLE && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        return;
    }
    if (![[ShareSDK getClientWithType:shareType] isClientInstalled] && shareType != ShareTypeSinaWeibo) {
        [SVProgressHUD showErrorWithStatus:@"请先安装客户端"];
        return;
    }
    __weak typeof(self) wself = self;
    [ShareSDK clientShareContent:self.content type:shareType statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
        if (end) {
            if (state == SSPublishContentStateSuccess)
            {
                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                [wself cancel:nil];
                [Network newsShareWithNewsId:self.sharedId shareType:activeShareType success:^(id response) {
                    
                } failure:^(NSString *errorMsg, StatusCode code) {
                    
                }];
            }else {
                if (state == SSPublishContentStateFail) {
                    [SVProgressHUD showErrorWithStatus:@"分享失败"];
                }
                [wself cancel:nil];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
