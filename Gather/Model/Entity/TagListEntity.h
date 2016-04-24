//
//  individualityTagListEntity.h
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol TagEntity <NSObject>

@end

@interface TagEntity : OptionalJSONModel

@property (nonatomic, strong) NSString *name;

@end


@interface TagListEntity : BaseEntity

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<TagEntity> *tags;

@property (nonatomic, strong) NSDictionary *sourceJson;

@end