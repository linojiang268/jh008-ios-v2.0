//
//  ActiveFlowListEntity.m
//  Gather
//
//  Created by apple on 15/3/24.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveFlowListEntity.h"

static ActiveFlowListEntity *_sharedActiveFlow;

@implementation ActiveFlowEntity

@end

@implementation ActiveFlowListEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        _sharedActiveFlow = self;
    }
    return self;
}

+ (instancetype)sharedActiveFlow {
    return _sharedActiveFlow ? : nil;
}

@end
