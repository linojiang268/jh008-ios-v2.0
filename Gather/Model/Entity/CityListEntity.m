//
//  CityEntity.m
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "CityListEntity.h"

@implementation CityEntity

@end

@implementation CityListEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        [Common saveCityList:dict];
    }
    return self;
}

@end
