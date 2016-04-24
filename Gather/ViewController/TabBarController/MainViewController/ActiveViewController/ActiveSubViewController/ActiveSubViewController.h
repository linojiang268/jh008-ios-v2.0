//
//  ActiveSubViewController.h
//  Gather
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ActiveSubViewController : BaseTableViewController

@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, weak) UIViewController *parentVC;
@property (nonatomic, assign) NSUInteger activeClassifyId;

@end
