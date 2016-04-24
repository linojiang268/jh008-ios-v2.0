//
//  ActiveRoadmapTeammateLocationListEntity.h
//  Gather
//
//  Created by apple on 15/4/22.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol ActiveRoadmapTeammateLocationEntity <NSObject>

@end

@interface LocationInfoEntity : OptionalJSONModel

/// double	纬度
@property (nonatomic, assign) double lat;
/// Double	经度
@property (nonatomic, assign) double lng;
/// long	传时的本地时间戳
@property (nonatomic, strong) NSString *loc_time;
/// long	上传时的服务器时间戳
@property (nonatomic, strong) NSString *svr_time;

@end

@interface ActiveRoadmapTeammateLocationEntity : OptionalJSONModel

/// 用户id
@property (nonatomic, assign) int u_id;
/// 用户名称
@property (nonatomic, strong) NSString *name;
/// 分组id
@property (nonatomic, assign) int group_id;
/// 头像url
@property (nonatomic, strong) NSString *head_img_url;
/// 位置信息
@property (nonatomic, strong) LocationInfoEntity *location_info;

@end

@interface ActiveRoadmapTeammateLocationListEntity : BaseEntity

@property (nonatomic, strong) NSArray<ActiveRoadmapTeammateLocationEntity> *locations;

@end
