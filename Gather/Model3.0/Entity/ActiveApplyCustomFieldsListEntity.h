//
//  ActiveApplyCustomFields.h
//  Gather
//
//  Created by apple on 15/3/31.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"


@protocol ActiveApplyCustomFieldsEntity <NSObject>


@end

@interface ActiveApplyCustomFieldsEntity : BaseEntity

@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *hint;
@property (nonatomic, strong) NSString *descri;

@end

@interface ActiveApplyCustomFieldsListEntity : BaseEntity

@property (nonatomic, strong) NSArray<ActiveApplyCustomFieldsEntity> *custom_keys;
@property (nonatomic, assign) int total_num;

@end
