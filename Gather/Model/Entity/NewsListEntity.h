//
//  NewsListEntity.h
//  Gather
//
//  Created by apple on 15/1/28.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"


@protocol NewsEntity <NSObject>

@end

@interface NewsEntity : OptionalJSONModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *detail_url;
@property (nonatomic, strong) NSString *h_img_url;
/// 是否已添加感兴趣：-1不可再添加，0未添加，1已添加
@property (nonatomic, assign) int is_loved;
@property (nonatomic, strong) NSString *publish_time;

/// 类型id：1攻略，2回忆，3票务，4专访，5轮播
@property (nonatomic, assign) int type_id;
/// 价格 订购才有
@property (nonatomic, assign) double price;

@end

@interface NewsDetailEntity : NewsEntity

@property (nonatomic, assign) int loved_num;
@property (nonatomic, assign) int shared_num;

@end

@interface NewsListEntity : BaseEntity

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<NewsEntity> *news;

@end
