//
//  DynamicListEntity.h
//  Gather
//
//  Created by apple on 15/1/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"
#import "FullUserInfoEntity.h"

@protocol DynamicEntity <NSObject>

@end

@protocol Img <NSObject>

@end

@protocol Imgs <NSObject>

@end

@interface Img : OptionalJSONModel

@property (nonatomic, strong) NSString *img_url;

@end

@interface Imgs : OptionalJSONModel

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<Img> *imgs;

@end

@interface DynamicEntity : OptionalJSONModel

@property (nonatomic, strong) SimpleUserInfoEntity *user;

@property (nonatomic, assign) int author_id;
@property (nonatomic, assign) int comment_num;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) Imgs *imgs;

@end

/// 用于PUSH过来请求时用，需重写构造方法
@interface DynamicDetailEntity : DynamicEntity

@end


@interface DynamicListEntity : BaseEntity

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<DynamicEntity> *dynamics;

@end
