//
//  ActiveConfigEntity.h
//  Gather
//
//  Created by apple on 15/3/18.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

/// 未开启改功能的提示语
extern NSString *const kHintNoOpenString;

typedef NS_ENUM(NSInteger, ActiveConfigStatus) {
    ActiveConfigStatusNone      = -1,
    ActiveConfigStatusNoSet     =  0,
    ActiveConfigStatusHasSet    =  1,
};

@interface ActiveConfigEntity : BaseEntity

/// 	报名模块：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_enroll;
/// 	报名审核模块：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_verify;
///     报名支付模块：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_pay;
///     自定义报名信息模块：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_enroll_custom;
///     管理员模块：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_manager;
///	 	流程状态：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_process;
/// 	菜单：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_menu;
///		注意事项：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_attention;
///	 	主办方介绍：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_busi;
///	 	导航：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_navi;
///	 	场地平面图：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_place_img;
///	 	路线图：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_route_map;
///	 	位置共享：-1无，1未设置，1已设置
@property (nonatomic, assign) int show_location_share;
///	 	相册：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_album;
///	 	视频：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_video;
///	 	留言：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_message;
///	 	分组：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_group;
///	 	最新通知：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_notice;
///	 	更多地点：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_more_addr;
///	 	奖品模块：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_prize;
///	 	签到模块：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_checkin;
///		订购模块：-1无，0未设置，1已设置
@property (nonatomic, assign) int show_order;

+ (instancetype)sharedConfig;
 
@end

@interface Product : OptionalJSONModel

///     商品名称
@property (nonatomic, strong) NSString *subject;
///     商品描述
@property (nonatomic, strong) NSString *body;
///     商品单价
@property (nonatomic, assign) double unit_price;

@end

@interface ActiveMoreConfigEntity : BaseEntity

///     是否限制报名人数：0否，1是
@property (nonatomic, assign) int enroll_limit;
/// 	报名限制人数
@property (nonatomic, assign) int enroll_limit_num;
///     是否分性别限制
@property (nonatomic, assign) int limit_sex_num;
///     限制男性人数
@property (nonatomic, assign) int limit_male_num;
///     限制女性人数
@property (nonatomic, assign) int limit_female_num;
///     是否允许携带随行人员：0否，1是
@property (nonatomic, assign) int can_with_people;
///     随行人员限制人数
@property (nonatomic, assign) int with_people_limit_num;
///     注意事项
@property (nonatomic, strong) NSString *attention;
///     主办方介绍url
@property (nonatomic, strong) NSString *busi_url;
///     场地平面图url
@property (nonatomic, strong) NSString *place_img_url;
///     自己的相册id：-1无
@property (nonatomic, assign) int album_id;
///     自己的分组id：-1无
@property (nonatomic, assign) int group_id;
///     报名状态：-1、0未报名，1待审核，2审核中，3已通过，4已拒绝
@property (nonatomic, assign) int enroll_status;
///     已成功报名的人数
@property (nonatomic, assign) int enroll_num;
///     已成功报名的男性人数
@property (nonatomic, assign) int enroll_male_num;
///     已成功报名的女性人数
@property (nonatomic, assign) int enroll_female_num;
///     自己是否是该活动管理员：0否，1是
@property (nonatomic, assign) int is_manager;
///     序号，报名成功后的id
@property (nonatomic, assign) int serial_no;
///     编号，分组后可能有的编号
@property (nonatomic, strong) NSString *pass_no;
///     商品信息
@property (nonatomic, strong) Product *product;

+ (instancetype)sharedMoreConfig;

@end

@interface ActiveConfigSingleton : NSObject

+ (instancetype)singleton;

@property (nonatomic, strong) ActiveConfigEntity *config;
@property (nonatomic, strong) ActiveMoreConfigEntity *moreConfig;

@end
