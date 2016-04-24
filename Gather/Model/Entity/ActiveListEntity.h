//
//  ActiveListEntity.h
//  Gather
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

#pragma mark - 列表

@protocol ActiveEntity <NSObject>

@end

@protocol ActiveImageEntity <NSObject>

@end

@interface ActiveEntity : OptionalJSONModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, assign) double cost;
@property (nonatomic, assign) double lon;
@property (nonatomic, assign) double lat;
@property (nonatomic, strong) NSString *addr_city;
@property (nonatomic, strong) NSString *addr_area;
@property (nonatomic, strong) NSString *addr_road;
@property (nonatomic, strong) NSString *addr_num;
@property (nonatomic, strong) NSString *b_time;
@property (nonatomic, strong) NSString *e_time;
/// 时间状态：1即将开始，2进行中，3筹备中，4已结束
@property (nonatomic, assign) int t_status;
@property (nonatomic, assign) NSString *statusString;
@property (nonatomic, strong) NSString *head_img_url;
/// 是否已添加感兴趣：-1不可再添加，0未添加，1已添加
@property (nonatomic, assign) int is_loved;
@property (nonatomic, strong) NSString *lov_time;
/// 是否已签到：0否，1是
@property (nonatomic, assign) int is_checkin;

@end

@interface ActiveImageEntity : OptionalJSONModel

@property (nonatomic, strong) NSString *img_url;

@end

@interface ActiveDetailEntity : ActiveEntity

@property (nonatomic, strong) NSString *addr_route;
@property (nonatomic, strong) NSString *addr_name;
@property (nonatomic, strong) NSString *contact_way;
@property (nonatomic, strong) NSString *organizer;
@property (nonatomic, assign) int can_enroll;
@property (nonatomic, strong) NSString *share_url;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *detail_url;
@property (nonatomic, assign) int loved_num;
@property (nonatomic, assign) int shared_num;
@property (nonatomic, strong) NSArray<ActiveImageEntity> *act_imgs;

@end

@interface ActiveListEntity : BaseEntity

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<ActiveEntity> *acts;

@end


#pragma mark - 附近

@protocol NearbyActiveEntity <NSObject>

@end

@interface NearbyActiveEntity : JSONModel

@property (nonatomic, assign) int act_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double lon;
@property (nonatomic, assign) double lat;

@end

@interface NearbyActiveListEntity : JSONModel

@property (nonatomic, assign) int size;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int total;
@property (nonatomic, strong) NSArray<NearbyActiveEntity> *contents;

@end


