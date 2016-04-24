//
//  AddressParkingSpaceListEntity.h
//  Gather
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol AddressParkingSpaceEntity <NSObject>

@end

@protocol ParkingSpaceEntity <NSObject>

@end

@interface ParkingSpaceEntity : OptionalJSONModel

///	double	经度
@property (nonatomic, assign) double lon;
///	double	纬度
@property (nonatomic, assign) double lat;
///	String	地址（城市）
@property (nonatomic, strong) NSString *addr_city;
///	String	地址（区）
@property (nonatomic, strong) NSString *addr_area;
///	String	地址（路）
@property (nonatomic, strong) NSString *addr_road;
///	String	地址（号）
@property (nonatomic, strong) NSString *addr_num;
///	String	地址（路线）
@property (nonatomic, strong) NSString *addr_route;
///	String	地址（名称）
@property (nonatomic, strong) NSString *addr_name;

@end

@interface AddressParkingSpaceEntity : ParkingSpaceEntity

///	String	时间（例：11:11:11）
@property (nonatomic, strong) NSString *time;
///	jsonArray	包含以下非加粗字段，属act_addrs
@property (nonatomic, strong) NSArray<ParkingSpaceEntity> *parking_spaces;

@end

@interface AddressParkingSpaceListEntity : BaseEntity

@property (nonatomic, strong) NSArray<AddressParkingSpaceEntity> *act_addrs;
@property (nonatomic, assign) int total_num;

@end
