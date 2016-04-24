//
//  PersonalHomePageViewController.h
//  Gather
//
//  Created by apple on 15/1/4.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseTableViewController.h"

@class PersonalHomePageEntity;
@interface PersonalHomePageViewController : BaseTableViewController

@property (nonatomic, strong) PersonalHomePageEntity *userInfo;

@property (nonatomic, assign) NSUInteger userId;
@property (nonatomic, assign) NSUInteger isFocus;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *headImageUrl;

@end
