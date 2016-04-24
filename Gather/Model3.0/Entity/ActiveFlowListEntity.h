//
//  ActiveFlowListEntity.h
//  Gather
//
//  Created by apple on 15/3/24.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol ActiveFlowEntity <NSObject>

@end

@interface ActiveFlowEntity : BaseEntity

@property (nonatomic, strong) NSString *b_time;
@property (nonatomic, strong) NSString *e_time;
@property (nonatomic, strong) NSString *subject;
/// 状态：-1已删除，0未设置，1即将开始，2正在进行，3已完成
@property (nonatomic, assign) int status;

@end

@interface ActiveFlowListEntity : BaseEntity

@property (nonatomic, strong) NSArray<ActiveFlowEntity> *act_process;
@property (nonatomic, assign) int total_num;

+ (instancetype)sharedActiveFlow;

@end
