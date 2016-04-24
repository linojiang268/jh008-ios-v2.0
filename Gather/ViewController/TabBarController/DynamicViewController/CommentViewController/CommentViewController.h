//
//  CommentViewController.h
//  Gather
//
//  Created by apple on 15/1/14.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseViewController.h"

@class DynamicEntity;
@interface CommentViewController : BaseViewController

@property (nonatomic, assign) NSUInteger pushId;
@property (nonatomic, strong) DynamicEntity *dynamicInfo;

@end
