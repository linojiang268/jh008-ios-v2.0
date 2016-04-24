//
//  PersonalHomePageEntity.m
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "PersonalHomePageEntity.h"

@implementation PersonalHomePageEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    
    NSDictionary *body = [dict objectForKey:@"body"][@"user"];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:dict];
    [temp removeObjectForKey:@"body"];
    [temp addEntriesFromDictionary:body];
    
    return [super initWithDictionary:temp error:err];
}

@end
