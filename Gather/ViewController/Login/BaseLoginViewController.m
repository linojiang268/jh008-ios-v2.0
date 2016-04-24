//
//  BaseLoginViewController.m
//  Gather
//
//  Created by Ray on 14-12-26.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "BaseLoginViewController.h"

@interface BaseLoginViewController ()

@end

@implementation BaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _rightitemButtonTitle = @"下一步";
    
    _shouldTranslucentNavigationBar = YES;
    _shouldShowRightItemButton = YES;
    _navigationBarBackgroundStyle = NavigationBarBackgroundStyleTranslucent;
    _navigationBarBackButtonStyle = NavigationBarBackButtonStyleWhite;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SET_STATUSBAR_STYLE(UIStatusBarStyleLightContent);
    
    if (_shouldShowRightItemButton && !self.navigationItem.rightBarButtonItem) {
        __weak typeof(self) wself = self;
        [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:_rightitemButtonTitle clickHandler:^(BlockBarButtonItem *item) {
            [wself rightItemButtonClick];
        }]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    SET_STATUSBAR_STYLE(UIStatusBarStyleDefault);
}

- (void)rightItemButtonClick {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
