//
//  UserHobbyEntity.h
//  Gather
//
//  Created by apple on 14/12/31.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol UserHobby <NSObject>

@end

@interface UserHobby : OptionalJSONModel

@property (nonatomic, strong) NSString *name;

@end

@interface UserHobbyEntity : BaseEntity

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<UserHobby> *tags;

@end
