//
//  ActiveNewestNoticeCacheEntity.h
//  Gather
//
//  Created by apple on 15/3/28.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ActiveNewestNoticeCacheEntity : NSManagedObject

@property (nonatomic, retain) NSString * create_time;
@property (nonatomic, retain) NSString * descri;
@property (nonatomic) double id;
@property (nonatomic, retain) NSString * subject;

@end
