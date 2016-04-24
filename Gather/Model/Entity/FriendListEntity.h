//
//  FriendListEntity.h
//  Gather
//
//  Created by apple on 14/12/31.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "BaseEntity.h"
#import "FullUserInfoEntity.h"

@interface FriendListEntity : BaseEntity

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<SimpleUserInfoEntity> *users;

@end
