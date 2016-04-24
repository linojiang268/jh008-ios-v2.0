//
//  GroupViewController.h
//  Gather
//
//  Created by apple on 15/3/16.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseViewController.h"

@class ActiveDetailEntity;
@interface GroupViewController : BaseViewController

@property (nonatomic, assign) NSUInteger activeId;
@property (nonatomic, strong) ActiveDetailEntity *activeDetail;

@end
