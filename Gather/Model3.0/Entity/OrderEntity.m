//
//  OrderEntity.m
//  Gather
//
//  Created by apple on 15/4/16.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "OrderEntity.h"

@implementation OrderWeChatEntity

@end

@implementation OrderEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    NSDictionary *body = [dict objectForKey:@"body"][@"order"];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:dict];
    [temp removeObjectForKey:@"body"];
    [temp addEntriesFromDictionary:body];
    
    self = [super initWithDictionary:temp error:nil];
    if (self) {
        
    }
    return self;
}

@end
