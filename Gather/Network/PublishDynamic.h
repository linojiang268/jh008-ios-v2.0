//
//  PublishDynamic.h
//  Gather
//
//  Created by apple on 15/1/19.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DynamicCacheEntity.h"

@interface PublishDynamic : NSObject

- (instancetype)initWithDynamicEntity:(DynamicCacheEntity *)entity;

- (void)publish;
- (void)cancel;

@end
