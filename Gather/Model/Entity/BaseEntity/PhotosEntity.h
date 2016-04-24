//
//  PhotosEntity.h
//  Gather
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol PhotoEntity <NSObject>


@end

@interface PhotoEntity : OptionalJSONModel

@property (nonatomic, strong) NSString *img_url;

@end

@interface PhotosEntity : BaseEntity

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<PhotoEntity> *photos;

@end
