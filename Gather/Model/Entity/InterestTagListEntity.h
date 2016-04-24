//
//  InterestTagListEntity.h
//  Gather
//
//  Created by Ray on 14-12-25.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol InterestTagEntity <NSObject>

@end

@interface InterestTagEntity : OptionalJSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int count;

@end

@interface InterestTagListEntity : BaseEntity

@property (nonatomic, strong) NSArray<InterestTagEntity> *list;

@end
