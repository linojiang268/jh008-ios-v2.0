//
//  UIStoryboard+Extend.h
//  Gather
//
//  Created by apple on 15/1/4.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (Extend)

+ (instancetype)mainStoryboard;

+ (instancetype)dynamicStoryboard;

+ (instancetype)messageStoryboard;

+ (instancetype)personalCenterStoryboard;

+ (instancetype)photoCellControllerStoryboard;

#pragma mark - 3.0
+ (instancetype)activeGroupStoryboard;

+ (instancetype)clubStoryboard;

@end
