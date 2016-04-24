//
//  GroupMessageBoardListEntity.h
//  Gather
//
//  Created by apple on 15/3/18.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"
#import "FullUserInfoEntity.h"

@protocol GroupMessageBoardEntity <NSObject>

@end

@interface GroupMessageBoardEntity : OptionalJSONModel

@property (nonatomic, assign) int author_id;
@property (nonatomic, assign) int is_admin;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) SimpleUserInfoEntity *user;

@end


@interface GroupMessageBoardListEntity : BaseEntity

@property (nonatomic, strong) NSArray<GroupMessageBoardEntity> *messages;
@property (nonatomic, assign) int total_num;

@end
