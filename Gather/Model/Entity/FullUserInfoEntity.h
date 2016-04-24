//
//  UserInfoEntity.h
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol SimpleUserInfoEntity <NSObject>

@end

@interface SimpleUserInfoEntity : BaseEntity

@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, assign) int sex;
@property (nonatomic, strong) NSString *birth;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *hobby;
@property (nonatomic, strong) NSString *head_img_url;
/// 在该城市是否成为达人：0否，1是
@property (nonatomic, assign) int is_vip;
/// 是否已关注：0否，1是
@property (nonatomic, assign) int is_focus;
@property (nonatomic, assign) int focus_num;
@property (nonatomic, assign) int fans_num;
// 0正常，1已屏蔽提醒
@property (nonatomic, assign) int is_shield;
// 3:android 4:ios
@property (nonatomic, assign) int last_login_platform;
@property (nonatomic, strong) NSString *baidu_user_id;
@property (nonatomic, strong) NSString *baidu_channel_id;

/// 好友列表
@property (nonatomic, assign) int new_msg_num;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *last_contact_time;
@property (nonatomic, assign) int status; //0正常，1已屏蔽提醒

@end


@interface FullUserInfoEntity : SimpleUserInfoEntity

/// 是否已完成注册：0未注册，1已用手机号注册，2非手机号注册
@property (nonatomic, assign) int is_regist;

@property (nonatomic, strong) NSString *sina_openid;
@property (nonatomic, strong) NSString *sina_token;
@property (nonatomic, strong) NSString *sina_expires_in;

@property (nonatomic, strong) NSString *qq_openid;
@property (nonatomic, strong) NSString *qq_token;
@property (nonatomic, strong) NSString *qq_expires_in;

@property (nonatomic, strong) NSString *wechat_openid;
@property (nonatomic, strong) NSString *wechat_token;
@property (nonatomic, strong) NSString *wechat_expires_in;

@property (nonatomic, strong) NSString *last_login_time;

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *real_name;

@property (nonatomic, strong) NSString *contact_phone;

@end
