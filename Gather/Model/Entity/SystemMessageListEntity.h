//
//  SystemMessageListEntity.h
//  Gather
//
//  Created by apple on 15/2/3.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol SystemMessageEntity <NSObject>

@end

@interface SystemMessageEntity : OptionalJSONModel

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *create_time;
/// 0:未读，1：已读
@property (nonatomic, assign) int status;

@end

@interface SystemMessageListEntity : BaseEntity

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<SystemMessageEntity> *system_msgs;

@end
