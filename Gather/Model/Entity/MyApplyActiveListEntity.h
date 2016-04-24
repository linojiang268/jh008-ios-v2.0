//
//  MyApplyActiveListEntity.h
//  Gather
//
//  Created by apple on 15/2/2.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"
#import "ActiveListEntity.h"

#pragma mark - 已签到

@protocol MyCheckInActiveEntity <NSObject>

@end

@interface MyCheckInActiveEntity : OptionalJSONModel

@property (nonatomic, assign) int act_id;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) ActiveEntity *act;

@end

@interface MyCheckInActiveListEntity : BaseEntity

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<MyCheckInActiveEntity> *checkins;

@end

#pragma mark - 已报名

@protocol MyApplyActiveEntity <NSObject>

@end

@interface MyApplyActiveEntity : MyCheckInActiveEntity

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) int people_num __deprecated_msg("2.2版本废弃，改用with_people_num");

#pragma mark - 2.2 新增
@property (nonatomic, assign) int sex;
@property (nonatomic, strong) NSString *birth;
@property (nonatomic, assign) int with_people_num;


@end

@interface MyApplyActiveListEntity : BaseEntity

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<MyApplyActiveEntity> *enrolls;

@end
