//
//  AppDelegate.h
//  Gather
//
//  Created by Ray on 14-12-23.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;

- (void)showNeedLoginView;

- (void)showLoginView;
- (void)showMainView;

@end

