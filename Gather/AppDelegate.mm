//
//  AppDelegate.m
//  Gather
//
//  Created by Ray on 14-12-23.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

#import "MainViewController.h"
#import "DynamicViewController.h"
#import "MessageViewController.h"
#import "PersonalCenterViewController.h"
#import "BaseNavigationController.h"
#import "ActiveDetailViewController.h"
#import "RecallDetailViewController.h"
#import "ChatViewController.h"
#import "PersonalHomePageViewController.h"
#import "CommentViewController.h"
#import "NSUserDefaults+Extend.h"
#import "Network+CityList.h"
#import "Network+UserInfo.h"
#import "Network+Push.h"
#import <SZTextView.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "Network+Tag.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <QZoneConnection/ISSQZoneApp.h>
#import "WXApi.h"
#import "WeiboSDK.h"//开启QQ空间网页授权开关

#import "BMapKit.h"

#import "BPush.h"

#import <AlipaySDK/AlipaySDK.h>

#if DEBUG
    #import "FLEXManager.h"
#endif

@interface AppDelegate ()<WXApiDelegate, BMKGeneralDelegate, WXApiDelegate, UITabBarControllerDelegate> {
    BMKMapManager* _mapManager;
    BlockAlertView *_alertLoginView;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"GatherDatabase.sqlite"];
    [self initReachabilityManager];
    [self initShareSDK];
    [self initBaiduMap];
    [self getCityList];
    [self getTag];
    [self setKeyboardAppearance];
    [self showMainView];
    [self setupHUD];
    [self initTalkingData];
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    
    #ifdef __IPHONE_8_0
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }  else {
            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
        }
    #else
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    #endif
    
    [self.window makeKeyAndVisible];
    
    NSDictionary *info = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (info && info.count > 0) {
        [self handlerPushNotificationWithInfo:info];
    }
    
#ifdef DEBUG
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIButton *debugButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(bounds)-100, 20, 10, 10)];
    debugButton.backgroundColor = [UIColor redColor];
    circle_view(debugButton);
    debugButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        [[FLEXManager sharedManager] showExplorer];
        return [RACSignal empty];
    }];
    [self.window addSubview:debugButton];
#endif

    return YES;
}

- (void)initReachabilityManager {
    
    self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [self.reachabilityManager startMonitoring];
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        log_value(@"network status:%d",status);
    }];
}

- (void)initBaiduMap {
    
    _mapManager = [[BMKMapManager alloc]init];
#ifdef DEBUG
    BOOL ret = [_mapManager start:@"doM1QVGlV6Pp8Gci5n0uMegM" generalDelegate:self];
#else
    BOOL ret = [_mapManager start:@"v1epimlB0h9NHNik66gKx2G6" generalDelegate:self];
#endif
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (void)initShareSDK {
    
    [ShareSDK registerApp:@"4ee82564c8f7"];
    
    // 采用ShareSDK后端配置
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    /*[ShareSDK connectSinaWeiboWithAppKey:@"2247106580"
                               appSecret:@"a1d70870e62c56c698e900b7174e49e0"
                             redirectUri:@"http://www.jhla.com.cn"];*/
    
   /* //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"2247106580"
                                appSecret:@"a1d70870e62c56c698e900b7174e49e0"
                              redirectUri:@"http://www.jhla.com.cn"
                              weiboSDKCls:[WeiboSDK class]];
    [ShareSDK connectWeChatWithAppId:@"wx325197f88ad7ba47"   //微信APPID
                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"  //微信APPSecret
                           wechatCls:[WXApi class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1103292660"
                           appSecret:@"M7C82lkWpe9IC6Zi"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];*/
    /*id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    [app setIsAllowWebAuthorize:YES];*/
}

- (void)initTalkingData {
    [TalkingData setExceptionReportEnabled:YES];
#ifdef DEBUG
    [TalkingData sessionStarted:@"61A1033D9647DE448813172265273B79" withChannelId:@"ios_testing"];
#else 
    [TalkingData sessionStarted:@"61A1033D9647DE448813172265273B79" withChannelId:@"ios_release"];
#endif
}

- (void)getCityList {
    [Network getCityListWithSuccess:^(CityListEntity *entity) {
        if ([Common getCurrentCityId] > 0) {
            if ([Common isLogin]) {
                [Network getUserInfoWithUserId:[Common getCurrentUserId] cityID:[Common getCurrentCityId]
                                       success:^(FullUserInfoEntity *entity) {}
                                       failure:^(NSString *errorMsg, StatusCode code) {}];
            }
        }else {
            [Common getCurrentLocationWithNeedReverseGeoCode:YES updateHandler:nil];
        }
    }failure:^(NSString *errorMsg, StatusCode code) {}];
}

- (void)getTag {
    [Network getTagListWithType:TagTypeCategory page:1 size:kSize success:^(TagListEntity *entity) {
        
    } failure:^(NSString *errorMsg, StatusCode code) {
        
    }];
    [Network getTagListWithType:TagTypeIndividuality page:1 size:kSize success:^(TagListEntity *entity) {
        
    } failure:^(NSString *errorMsg, StatusCode code) {
        
    }];
}

- (void)setupHUD {
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

- (void)showNeedLoginView {
    
    if (!_alertLoginView) {
        _alertLoginView = [[BlockAlertView alloc] initWithTitle:nil message:@"请重新登陆" handler:^(UIAlertView *alertView, NSUInteger index) {
            
            [Common setIsLogin:NO];
            [Common saveSelfUserInfo:nil];
            [Common setCurrentUsesrId:@(0)];
            [(AppDelegate *)[UIApplication sharedApplication].delegate
             showLoginView];
            
        } cancelButtonTitle:nil otherButtonTitles:@"确定"];;
    }
    
    if (!_alertLoginView.visible) {
        [_alertLoginView show];
    }
}

- (void)setKeyboardAppearance {
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}

- (void)setupMainAppearance {
    SET_STATUSBAR_STYLE(UIStatusBarStyleDefault);
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTintColor:color_with_hex(kColor_ff9933)];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: color_with_hex(kColor_ff9933), NSFontAttributeName: [UIFont systemFontOfSize:20]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: color_with_hex(kColor_ff9933)} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: color_with_hex(0x333333)} forState:UIControlStateNormal];
}

- (void)setupLoginAppearance {
    SET_STATUSBAR_STYLE(UIStatusBarStyleLightContent);
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTintColor:color_white];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: color_white, NSFontAttributeName: [UIFont systemFontOfSize:20]}];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:13 forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: color_white} forState:UIControlStateNormal];
}

- (void)showLoginView {
    [self setupLoginAppearance];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UINavigationController *controller = [storyboard instantiateViewControllerWithIdentifier:@"LoginNav"];
    
    if (self.window.rootViewController) {
        UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
        UIViewController *visibleViewController = [(UINavigationController *)tab.viewControllers[tab.selectedIndex] visibleViewController];
        
        if (visibleViewController.presentingViewController && [visibleViewController isMemberOfClass:NSClassFromString(@"LoginHomeViewController")]) {
            [visibleViewController dismissViewControllerAnimated:YES completion:nil];
        }else {
            [visibleViewController presentViewController:controller animated:YES completion:nil];
        }
    }else {
        self.window.rootViewController = controller;
    }
}

- (void)showMainView {
    [self setupMainAppearance];
    UIStoryboard *storyboard = [UIStoryboard mainStoryboard];
    
    UITabBarController *tabBarControoler = [[UITabBarController alloc] init];
    tabBarControoler.tabBar.translucent = NO;
    tabBarControoler.delegate = self;
    
    UIViewController *view1 = [storyboard instantiateViewControllerWithIdentifier:@"main22"];
    UIViewController *view2 = [[UIStoryboard dynamicStoryboard] instantiateViewControllerWithIdentifier:@"dynamic"];
    UIViewController *view3 = [[UIStoryboard messageStoryboard] instantiateViewControllerWithIdentifier:@"message"];
    UIViewController *view4 = [[UIStoryboard personalCenterStoryboard] instantiateViewControllerWithIdentifier:@"personalCenter"];
    
    UIImage *view1d = [[UIImage imageNamed:@"tabbar_home_d"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *view1s = [[UIImage imageNamed:@"tabbar_home_h"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *view2d = [[UIImage imageNamed:@"tabbar_dynamic_d"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *view2s = [[UIImage imageNamed:@"tabbar_dynamic_h"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *view3d = [[UIImage imageNamed:@"tabbar_message_d"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *view3s = [[UIImage imageNamed:@"tabbar_message_h"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *view4d = [[UIImage imageNamed:@"tabbar_personal_center_d"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *view4s = [[UIImage imageNamed:@"tabbar_personal_center_h"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *view1Item = [[UITabBarItem alloc] initWithTitle:@"集合啦" image:view1d selectedImage:view1s];
    UITabBarItem *view2Item = [[UITabBarItem alloc] initWithTitle:@"动态" image:view2d selectedImage:view2s];
    UITabBarItem *view3Item = [[UITabBarItem alloc] initWithTitle:@"消息" image:view3d selectedImage:view3s];
    UITabBarItem *view4Item = [[UITabBarItem alloc] initWithTitle:@"我" image:view4d selectedImage:view4s];
    
    view1.title = view1Item.title;
    view2.title = view2Item.title;
    view3.title = view3Item.title;
    view4.title = view4Item.title;
    
    view1.tabBarItem = view1Item;
    view2.tabBarItem = view2Item;
    view3.tabBarItem = view3Item;
    view4.tabBarItem = view4Item;
    
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] initWithRootViewController:view1];
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] initWithRootViewController:view2];
    BaseNavigationController *nav3 = [[BaseNavigationController alloc] initWithRootViewController:view3];
    BaseNavigationController *nav4 = [[BaseNavigationController alloc] initWithRootViewController:view4];
    
    [nav1.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background_white"] forBarMetrics:UIBarMetricsDefault];
    [nav2.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background_white"] forBarMetrics:UIBarMetricsDefault];
    [nav3.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background_white"] forBarMetrics:UIBarMetricsDefault];
    [nav4.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background_white"] forBarMetrics:UIBarMetricsDefault];
    
    if (DYNAMIC_MODULE_IS_SHOW) {
        [tabBarControoler setViewControllers:@[nav1,nav2,nav3,nav4]];
    }else {
        [tabBarControoler setViewControllers:@[nav1,nav3,nav4]];
    }
    if (self.window.rootViewController) {
        
        UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
        UIViewController *visibleViewController = [(UINavigationController *)tab.viewControllers[tab.selectedIndex] visibleViewController];
        
        if (visibleViewController.presentingViewController) {
            [visibleViewController dismissViewControllerAnimated:YES completion:nil];
        }else {
            [visibleViewController presentViewController:tabBarControoler animated:YES completion:nil];
        }
    }else {
        self.window.rootViewController = tabBarControoler;
    }
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    if ([[(UINavigationController *)viewController visibleViewController] isKindOfClass:NSClassFromString(@"MessageViewController")]) {
        UITabBarItem *item = tabBarController.tabBar.items[2];
        item.badgeValue = nil;
    }
    
    if (![Common isLogin]) {
        if ([[(UINavigationController *)viewController topViewController] isMemberOfClass:NSClassFromString(@"MessageViewController")] ||
            [[(UINavigationController *)viewController topViewController] isMemberOfClass:NSClassFromString(@"PersonalCenterViewController")])
        {
            alert_login;
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else {
        void(^callback)(NSDictionary *) = ^(NSDictionary *resultDict) {
            
            NSLog(@"%@______%@",resultDict,[resultDict objectForKey:@"memo"]);
            
            int status = [[resultDict objectForKey:@"resultStatus"] intValue];
            
            switch (status) {
                case 9000:
                    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                    break;
                case 8000:
                    [SVProgressHUD showWithStatus:@"支付中"];
                    break;
                case 4000:
                    [SVProgressHUD showErrorWithStatus:@"支付失败"];
                    break;
                case 6001:
                    [SVProgressHUD showSuccessWithStatus:@"支付取消"];
                    break;
                case 6002:
                    [SVProgressHUD showSuccessWithStatus:@"网络异常"];
                    break;
            }
        };
        
        //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                callback(resultDic);
            }];
        }
        //支付宝钱包快登授权返回 authCode
        if ([url.host isEqualToString:@"platformapi"]) {
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                callback(resultDic);
            }];
        }

    }
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"deviceToken:%@",deviceToken);
    [BPush registerDeviceToken: deviceToken];
    [BPush bindChannel];
}

- (void)onMethod:(NSString*)method response:(NSDictionary*)data {
    log_value(@"baidu push on method:%@", method);
    log_value(@"baidu push data:%@", [data description]);
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == BPushErrorCode_Success) {
            log_value(@"baidu push bind success");
            
            if ([Common isLogin] && [Common getCurrentCityId] > 0) {
                [Network setUpWithCityId:[Common getCurrentCityId]
                                platform:PlatformTypeIos
                             baiduUserId:[BPush getUserId]
                          baiduChannelId:[BPush getChannelId]
                                 success:^(id response) {}
                                 failure:^(NSString *errorMsg, StatusCode code) {}];
            }
        }
    } else if ([BPushRequestMethod_Unbind isEqualToString:method]) {
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == BPushErrorCode_Success) {
            
        }
    }
}

- (void)handlerPushNotificationWithInfo:(NSDictionary *)info {
    
    if ([Common isLogin]) {
        PushType pushType = (PushType)[[info objectForKey:kPUSH_TYPE_KEY] intValue];
        NSUInteger infoId = [[info objectForKey:kPUSH_TYPE_VALUE] intValue];
        if (pushType > 0 && infoId > 0) {
            if (!self.window.rootViewController) {
                [self showMainView];
            }
            
            UIApplication *app = [UIApplication sharedApplication];
            
            UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
            if (app.applicationState == UIApplicationStateActive) {
                
                if (pushType == PushTypeChat) {
                    
                    UILocalNotification *notification=[[UILocalNotification alloc] init];
                    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:1];
                    notification.repeatInterval = 0;
                    notification.timeZone = [NSTimeZone defaultTimeZone];
                    notification.alertBody = [[info objectForKey:@"aps"] objectForKey:@"alert"];
                    notification.userInfo = info;
                    
                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                    AudioServicesPlaySystemSound(1007);
                }
            }else {
            
                UIViewController *topViewController = [(UINavigationController *)tab.viewControllers[tab.selectedIndex] topViewController];
                UIViewController *visibleViewController = [(UINavigationController *)tab.viewControllers[tab.selectedIndex] visibleViewController];
                
                switch (pushType) {
                    case PushTypeActive:
                    {
                        ActiveDetailViewController *controller = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"ActiveDetail"];
                        controller.activeId = infoId;
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                        [visibleViewController presentViewController:nav animated:YES completion:nil];
                    }
                        break;
                    case PushTypeNews:
                    {
                        RecallDetailViewController *controller = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"RecallDetail"];
                        controller.pushId = infoId;
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                        [visibleViewController presentViewController:nav animated:YES completion:nil];
                    }
                        break;
                    case PushTypeUser:
                    {
                        PersonalHomePageViewController *controller = [[UIStoryboard personalCenterStoryboard] instantiateViewControllerWithIdentifier:@"PersonalHomePage"];
                        controller.userId = infoId;
                        
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                        [visibleViewController presentViewController:nav animated:YES completion:nil];
                    }
                        break;
                    case PushTypeDynamic:
                    {
                        CommentViewController *controller = [[UIStoryboard dynamicStoryboard] instantiateViewControllerWithIdentifier:@"Comment"];
                        controller.pushId = infoId;
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                        [visibleViewController presentViewController:nav animated:YES completion:nil];
                    }
                        break;
                    case PushTypeChat:
                    {
                        ChatViewController *controller = [[UIStoryboard messageStoryboard] instantiateViewControllerWithIdentifier:@"Chat"];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                        controller.pushId = infoId;
                        
                        UIViewController *parentViewController = visibleViewController.presentingViewController;
                        
                        
                        if (parentViewController && [visibleViewController isKindOfClass:[ChatViewController class]]) {
                            
                            [visibleViewController dismissViewControllerAnimated:NO completion:nil];
                            visibleViewController = nil;
                        }
                        
                        if (visibleViewController) {
                            [visibleViewController presentViewController:nav animated:YES completion:nil];
                        }else {
                            [topViewController presentViewController:nav animated:YES completion:nil];
                        }
                    }
                        break;
                }
            }
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Receive Notify: %@", userInfo);
    [self handlerPushNotificationWithInfo:userInfo];
    [BPush handleNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (application.applicationState == !UIApplicationStateActive) {
        [self handlerPushNotificationWithInfo:notification.userInfo];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    log_error(@"register remote error:%@",error);
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                log_value(@"支付成功");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kWE_CHAT_PAY_END_NOTIFICATION_NAME object:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"result"]];
            }
                break;
                case WXErrCodeUserCancel:
                break;
            default:
            {
                log_value(@"支付失败， retcode=%d",resp.errCode);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kWE_CHAT_PAY_END_NOTIFICATION_NAME object:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"result"]];
            }
                break;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    DISMISS_HUD;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.  
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}

@end
