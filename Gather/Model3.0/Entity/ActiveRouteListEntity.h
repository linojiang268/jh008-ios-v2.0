//
//  ActiveRouteListEntity.h
//  Gather
//
//  Created by apple on 15/4/20.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol ActiveRouteEntity <NSObject>

@end

@interface ActiveRouteEntity : OptionalJSONModel

/// double	纬度
@property (nonatomic, assign) double lat;
/// Double	经度
@property (nonatomic, assign) double lng;
/// string	该点的地址
@property (nonatomic, strong) NSString *addr;
/// String	该点的描述
@property (nonatomic, strong) NSString *desc;

@end

@interface ActiveRouteListEntity : BaseEntity

///	Int	活动Id
@property (nonatomic, assign) int act_id;
///	Int	线路id
@property (nonatomic, assign) int act_route_id;
/// String	线路名称
@property (nonatomic, strong) NSString *act_route_name;
/// Long	线路创建时间
@property (nonatomic, assign) NSString *act_route_create_time;
/// 点
@property (nonatomic, strong) NSArray<ActiveRouteEntity> *act_route_points;

@end
