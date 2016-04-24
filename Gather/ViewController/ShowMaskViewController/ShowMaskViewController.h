//
//  ShowMaskViewController.h
//  Gather
//
//  Created by apple on 15/1/31.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMaskViewController : NSObject

+ (instancetype)sharedController;

- (void)showInView:(UIView *)view otherView:(UIView *)otherView;
- (void)showInWindow:(UIView *)view otherView:(UIView *)otherView;
- (void)showInView:(UIView *)view otherView:(UIView *)otherView otherViewFrame:(CGRect)otherViewFrame;
- (void)showInWindow:(UIView *)window otherView:(UIView *)otherView otherViewFrame:(CGRect)otherViewFrame;

- (void)dismiss;
- (void)dismissComplete:(void(^)(void))complete;

@end
