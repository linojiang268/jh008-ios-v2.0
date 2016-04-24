//
//  BaseCollectionCollectionViewController.h
//  Gather
//
//  Created by apple on 15/3/16.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "UIViewController+Gesture.h"
#import "BaseNavigationController.h"

@interface BaseCollectionViewController : UICollectionViewController  {
    UIStatusBarStyle _statusBarStyle;
    BOOL _shouldHideNavigationBar;
    BOOL _shouldTranslucentNavigationBar;
    BOOL _shouldDelayTranslucentNavigationBar;
    BOOL _interactivePopGestureRecognizerEnabled;
    BOOL _hidesBottomBarWhenPushed;
    NavigationBarBackButtonStyle _navigationBarBackButtonStyle;
    NavigationBarBackgroundStyle _navigationBarBackgroundStyle;
}

@property (nonatomic, strong) UINavigationBar *customNavigationBar;
@property (nonatomic, strong) UINavigationItem *customNavigationItem;

- (void)addCustomNavigationBar;

@end
