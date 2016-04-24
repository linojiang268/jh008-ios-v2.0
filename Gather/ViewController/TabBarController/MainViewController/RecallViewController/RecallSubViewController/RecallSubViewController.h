//
//  StrategyViewController.h
//  Gather
//
//  Created by apple on 15/1/30.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseTableViewController.h"

@interface RecallSubViewController : BaseTableViewController

@property (nonatomic, assign) BOOL isAll;
@property (nonatomic, weak) UIViewController *parentVC;
@property (nonatomic, assign) NSUInteger tagId;
@property (nonatomic, assign) NewsType newsType;

@end
