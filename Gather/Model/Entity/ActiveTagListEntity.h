//
//  ActiveTagListEntity.h
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol ActiveTagEntity <NSObject>

@end

@interface ActiveTagEntity : OptionalJSONModel

@property (nonatomic, strong) NSString *name;

@end


@interface ActiveTagListEntity : BaseEntity

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<ActiveTagEntity> *tags;

@end
