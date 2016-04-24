//
//  ActiveGroupInfoEntity.m
//  Gather
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveGroupInfoEntity.h"

@implementation ActiveGroupInfoEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    NSDictionary *body = [dict objectForKey:@"body"][@"group"];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:dict];
    [temp removeObjectForKey:@"body"];
    [temp addEntriesFromDictionary:body];
    
    self = [super initWithDictionary:temp error:err];
    if (self) {

    }
    return self;
}

@end
