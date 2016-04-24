//
//  ClubListEntity.h
//  Gather
//
//  Created by apple on 15/4/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol ClubEntity <NSObject>

@end

@interface ClubEntity : BaseEntity
/// subject	String	名称
@property (nonatomic, strong) NSString *subject;
/// 图标url
@property (nonatomic, strong) NSString *icon_url;
/// 关注用户数
@property (nonatomic, assign) int lov_user_num;
/// 发布的活动数
@property (nonatomic, assign) int act_num;
/// 是否已关注：-1，0否，1是
@property (nonatomic, assign) int is_loved;

@end

@interface ClubDetailEntity : ClubEntity
/// 简介
@property (nonatomic, strong) NSString *intro;

@end

@interface ClubListEntity : BaseEntity

@property (nonatomic, strong) NSArray<ClubEntity> *orgs;
@property (nonatomic, assign) int total_num;

@end
