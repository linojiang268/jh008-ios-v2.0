//
//  FriendListViewController.h
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "BaseViewController.h"
#import "Network+FriendList.h"

@interface FriendListViewController : BaseViewController

@property (nonatomic, assign) NSUInteger userId;
@property (nonatomic, assign) FriendType friendType;

@end
