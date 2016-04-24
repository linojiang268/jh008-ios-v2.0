//
//  SitePlanListEntty.h
//  Gather
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol SitePlanEntty <NSObject>

@end

@interface SitePlanEntty : OptionalJSONModel

@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *img_url;

@end

@interface SitePlanListEntty : BaseEntity

@property (nonatomic, strong) NSArray<SitePlanEntty> *place_imgs;
@property (nonatomic, assign) int total_num;

@end
