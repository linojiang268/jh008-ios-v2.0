//
//  UIViewController+Gesture.m
//  Gather
//
//  Created by apple on 15/3/23.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "UIViewController+Gesture.h"

@implementation UIViewController (Gesture)

- (void)setupGesture {
    if (self.navigationController.viewControllers.count > 1) {
        __weak typeof(self) wself = self;
        void(^setup)(id obj) = ^(id obj){
            [wself.navigationController.interactivePopGestureRecognizer.rac_gestureSignal subscribeNext:^(id x) {
                UIScreenEdgePanGestureRecognizer *gesture = x;
                if (gesture.state == UIGestureRecognizerStateBegan) {
                    [obj panGestureRecognizer].enabled = NO;
                    [obj setScrollEnabled:NO];
                }
                if (gesture.state != UIGestureRecognizerStateChanged) {
                    [obj panGestureRecognizer].enabled = YES;
                    [obj setScrollEnabled:YES];
                }
            }];
        };
        [[self.view subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIScrollView class]]) {
                setup(obj);
                *stop = YES;
            }
            if ([obj isKindOfClass:[UIWebView class]]) {
                setup([(UIWebView *)obj scrollView]);
                *stop = YES;
            }
            
        }];
    }
}

@end
