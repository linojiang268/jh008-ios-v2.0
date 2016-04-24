//
//  BaseTableViewController.h
//  Gather
//
//  Created by Ray on 14-12-27.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "UIViewController+Gesture.h"
#import "BaseNavigationController.h"

@interface BaseTableViewController : UITableViewController {
    UIStatusBarStyle _statusBarStyle;
    BOOL _shouldHideNavigationBar;
    BOOL _shouldTranslucentNavigationBar;
    BOOL _interactivePopGestureRecognizerEnabled;
    BOOL _hidesBottomBarWhenPushed;
    NavigationBarBackButtonStyle _navigationBarBackButtonStyle;
    NavigationBarBackgroundStyle _navigationBarBackgroundStyle;
}

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) int totalNumber;

@property (nonatomic, strong) UINavigationBar *customNavigationBar;
@property (nonatomic, strong) UINavigationItem *customNavigationItem;

- (void)addCustomNavigationBar;

@end
