//
//  ActiveCommentListEntity.h
//  Gather
//
//  Created by apple on 15/1/28.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"
#import "FullUserInfoEntity.h"

@protocol CommentEntity <NSObject>

@end

@interface CommentEntity : OptionalJSONModel

@property (nonatomic, assign) int author_id;
@property (nonatomic, strong) SimpleUserInfoEntity *user;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *create_time;

@end

@interface ActiveCommentListEntity : BaseEntity

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<CommentEntity> *comments;


@end
