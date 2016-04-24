//
//  individualityTagListEntity.m
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "TagListEntity.h"

@implementation TagEntity

@end

@implementation TagListEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        self.sourceJson = dict;
    }
    return self;
}

@end
