//
//  NewsListEntity.m
//  Gather
//
//  Created by apple on 15/1/28.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "NewsListEntity.h"

@implementation NewsEntity

@end

@implementation NewsDetailEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    NSDictionary *body = [dict objectForKey:@"body"][@"news"];
    return [super initWithDictionary:body error:err];
}

@end

@implementation NewsListEntity

@end
