//
//  RecallDetailViewController.h
//  Gather
//
//  Created by apple on 15/1/30.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseWebViewController.h"

@class NewsEntity;
@interface RecallDetailViewController : BaseWebViewController

@property (nonatomic, assign) NSUInteger pushId;

@property (nonatomic, strong) NewsEntity *newsInfo;

@end
