//
//  DynamicCommentEntity.h
//  Gather
//
//  Created by apple on 15/1/14.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"
#import "FullUserInfoEntity.h"

@protocol DynamicCommentEntity <NSObject>

@end

@interface DynamicCommentEntity : OptionalJSONModel

@property (nonatomic, assign) int author_id;
@property (nonatomic, strong) SimpleUserInfoEntity *author_user;
@property (nonatomic, assign) int at_id;
@property (nonatomic, strong) SimpleUserInfoEntity *at_user;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *create_time;

@end

@interface DynamicCommentListEntity : BaseEntity

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<DynamicCommentEntity> *comments;

@end
