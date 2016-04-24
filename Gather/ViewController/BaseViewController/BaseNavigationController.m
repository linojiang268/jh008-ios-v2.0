//
//  BaseNavigationController.m
//  Gather
//
//  Created by Ray on 14-12-27.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@property (nonatomic, strong) UIViewController *rootVC;

@end

@implementation BaseNavigationController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.visibleViewController preferredStatusBarStyle];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count == 2) {
        [self.rootVC setHidesBottomBarWhenPushed:NO];
    }
    return [super popViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count == 1) {
        [self setRootVC:self.visibleViewController];
        [self.rootVC setHidesBottomBarWhenPushed:YES];
    }
    [super pushViewController:viewController animated:animated];
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
