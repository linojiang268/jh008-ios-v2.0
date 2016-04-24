//
//  MyCheckInViewController.h
//  Gather
//
//  Created by apple on 15/2/2.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseTableViewController.h"

@interface MyCheckInViewController : BaseTableViewController

@property (nonatomic, assign) NSUInteger userId;
@property (nonatomic, weak) UIViewController *parentVC;

@end
