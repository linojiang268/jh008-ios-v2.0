//
//  ShowMaskViewController.m
//  Gather
//
//  Created by apple on 15/1/31.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ShowMaskViewController.h"

@interface ShowMaskViewController ()

@property (nonatomic, strong) UIView *window;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, strong) UIView *otherView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGRect otherViewFrame;

@property (nonatomic, copy) void(^dismissComplete)(void);

@end

@implementation ShowMaskViewController

+ (instancetype)sharedController {
    static ShowMaskViewController *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[ShowMaskViewController alloc] init];
    });
    return _shared;
}

- (void)setupView {
    self.window = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.targetView.bounds), CGRectGetWidth(self.targetView.bounds), CGRectGetHeight(self.targetView.bounds))];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.window.bounds];
    self.otherView.frame = CGRectEqualToRect(self.otherViewFrame, CGRectZero) ? self.targetView.bounds : self.otherViewFrame;
    self.blackView = [[UIView alloc] initWithFrame:self.targetView.bounds];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0.0;

    [self.scrollView addSubview:self.blackView];
    [self.scrollView addSubview:self.otherView];
    [self.window addSubview:self.scrollView];
    
    [_window addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchGesture:)]];
}

- (void)showInView:(UIView *)view otherView:(UIView *)otherView {
    [self showInView:view otherView:otherView otherViewFrame:CGRectZero];
}

- (void)showInWindow:(UIView *)view otherView:(UIView *)otherView {
    [self showInView:view otherView:otherView otherViewFrame:CGRectZero];
}

- (void)showInWindow:(UIView *)window otherView:(UIView *)otherView otherViewFrame:(CGRect)otherViewFrame{
    [self showInView:window otherView:otherView otherViewFrame:otherViewFrame];
}

- (void)showInView:(UIView *)view otherView:(UIView *)otherView otherViewFrame:(CGRect)otherViewFrame{
    [self setTargetView:view];
    [self setOtherView:otherView];
    [self setOtherViewFrame:otherViewFrame];
    [self setupView];
    [self.blackView setAlpha:0.0];
    [view addSubview:self.window];
    
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.25 animations:^{
        wself.window.frame = CGRectMake(0, 0, CGRectGetWidth(self.targetView.bounds), CGRectGetHeight(self.targetView.bounds));
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            wself.blackView.alpha = 0.5;
        }];
    }];
}

- (void)dismiss {
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.25 animations:^{
        wself.blackView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            wself.window.frame = CGRectMake(0, CGRectGetMaxY(self.targetView.bounds), CGRectGetWidth(self.targetView.bounds), CGRectGetHeight(self.targetView.bounds));
        } completion:^(BOOL finished) {
            [wself.window removeFromSuperview];
            if (wself.dismissComplete) {
                wself.dismissComplete();
            }
        }];
    }];
}

- (void)dismissComplete:(void(^)(void))complete {
    if (complete) {
        self.dismissComplete = complete;
    }
}

- (void)touchGesture:(UITapGestureRecognizer *)gesture {
    [self dismiss];
}

@end
