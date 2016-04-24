//
//  BanquetMenuListEntity.h
//  Gather
//
//  Created by apple on 15/3/24.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol BanquetMenuEntity <NSObject>

@end

@interface BanquetMenuEntity : OptionalJSONModel

@property (nonatomic, strong) NSString *subject;
/// 类型：1午宴，2晚宴
@property (nonatomic, assign) int type;

@end

@interface BanquetMenuListEntity : BaseEntity

@property (nonatomic, strong) NSArray<BanquetMenuEntity> *act_menus;
@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *addr;

@end
