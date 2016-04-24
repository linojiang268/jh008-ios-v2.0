//
//  ActiveRouteListEntity.m
//  Gather
//
//  Created by apple on 15/4/20.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveRouteListEntity.h"

@implementation ActiveRouteEntity

@end

@implementation ActiveRouteListEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    
    NSDictionary *body = [[dict objectForKey:@"body"] firstObject];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:dict];
    [temp removeObjectForKey:@"body"];
    [temp addEntriesFromDictionary:body];
    
    return [super initWithDictionary:temp error:err];
}

@end
