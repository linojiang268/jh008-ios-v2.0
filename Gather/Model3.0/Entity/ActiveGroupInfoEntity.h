//
//  ActiveGroupInfoEntity.h
//  Gather
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@interface ActiveGroupInfoEntity : BaseEntity

///subject	String	名称
@property (nonatomic, strong) NSString *subject;
///people_num	int	人数
@property (nonatomic, assign) int people_num;
///create_time	String	创建时间（例：1970-11-11 11:11:11）
@property (nonatomic, strong) NSString *create_time;

@end
