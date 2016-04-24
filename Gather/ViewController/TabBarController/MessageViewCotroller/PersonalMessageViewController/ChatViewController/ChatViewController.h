//
//  ChatViewController.h
//  Gather
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseViewController.h"
#import "ContactsListEntity.h"

@interface ChatViewController : BaseViewController

@property (nonatomic, assign) NSUInteger pushId;

@property (nonatomic, strong) NSString *baidu_user_id;
@property (nonatomic, strong) NSString *baidu_channel_id;
@property (nonatomic, assign) NSUInteger last_login_platform;
@property (nonatomic, assign) NSUInteger isShield;
@property (nonatomic, assign) NSUInteger contactId;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *headImageUrl;

@end
