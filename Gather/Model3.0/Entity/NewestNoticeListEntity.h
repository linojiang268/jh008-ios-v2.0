//
//  NewestNoticeListEntity.h
//  Gather
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol NewestNoticeEntity <NSObject>


@end

@interface NewestNoticeEntity : BaseEntity

@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *descri;
@property (nonatomic, strong) NSString *create_time;

@property (nonatomic, assign) BOOL read;

@end

@interface NewestNoticeListEntity : BaseEntity

@property (nonatomic, strong) NSArray<NewestNoticeEntity> *act_notices;
@property (nonatomic, assign) int total_num;

@end
