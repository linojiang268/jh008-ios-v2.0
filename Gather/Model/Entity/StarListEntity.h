//
//  StarListEntity.h
//  Gather
//
//  Created by apple on 15/1/20.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"
#import "FullUserInfoEntity.h"

@interface StarListEntity : BaseEntity

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<SimpleUserInfoEntity> *queue;
@property (nonatomic, strong) NSArray<SimpleUserInfoEntity> *users;

@end
