//
//  DynamicCacheEntity.h
//  Gather
//
//  Created by apple on 15/1/19.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DynamicCacheEntity : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * create_time;
@property (nonatomic, retain) NSString * imgNames;
/// 1:正在发布 2:发布失败，需要重发
@property (nonatomic) double status;

@end
