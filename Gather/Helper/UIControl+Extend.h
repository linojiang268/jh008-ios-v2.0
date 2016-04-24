//
//  UIControl+Extend.h
//  Gather
//
//  Created by Ray on 14-12-24.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Extend)

- (void)addEvent:(UIControlEvents)event handler:(void(^)(id sender))handler;
- (void)removeHandlerForEvent:(UIControlEvents)event;

@end
