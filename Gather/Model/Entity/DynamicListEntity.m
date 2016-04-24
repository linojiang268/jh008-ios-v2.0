//
//  DynamicListEntity.m
//  Gather
//
//  Created by apple on 15/1/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "DynamicListEntity.h"

@implementation Img

@end

@implementation Imgs

@end

@implementation DynamicEntity

@end

@implementation DynamicDetailEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    
    NSDictionary *body = [dict objectForKey:@"body"][@"dynamic"];
    return [super initWithDictionary:body error:err];
}

@end

@implementation DynamicListEntity

@end
