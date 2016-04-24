//
//  AttentionListEntity.h
//  Gather
//
//  Created by apple on 15/3/25.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol AttentionEntity <NSObject>

@end

@interface AttentionEntity : OptionalJSONModel

@property (nonatomic, strong) NSString *subject;

@end

@interface AttentionListEntity : BaseEntity

@property (nonatomic, strong) NSArray<AttentionEntity> *act_attentions;
@property (nonatomic, assign) int total_num;

@end
