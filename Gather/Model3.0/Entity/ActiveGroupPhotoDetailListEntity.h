//
//  ActiveGroupPhotoDetailListEntity.h
//  Gather
//
//  Created by apple on 15/4/2.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol ActiveGroupPhotoDetailEntity <NSObject>

@end

@interface ActiveGroupPhotoDetailEntity : OptionalJSONModel

@property (nonatomic, strong) NSString *img_url;
@property (nonatomic, strong) NSString *create_time;
/// 相册图片的状态：1已提交审核，2审核中，3已通过，4已拒绝
@property (nonatomic, assign) int status;

@end

@interface ActiveGroupPhotoDetailListEntity : BaseEntity

@property (nonatomic, strong) NSArray<ActiveGroupPhotoDetailEntity> *photoes;
@property (nonatomic, assign) int total_num;

@end
