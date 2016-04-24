//
//  CityEntity.h
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol CityEntity <NSObject>


@end

@interface CityEntity : OptionalJSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int status;

@end

@interface CityListEntity : BaseEntity

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<CityEntity> *cities;

@end
