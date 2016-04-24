//
//  ClubListEntity.m
//  Gather
//
//  Created by apple on 15/4/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ClubListEntity.h"

@implementation ClubEntity

@end

@implementation ClubDetailEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    NSDictionary *body = [dict objectForKey:@"body"][@"org"];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:dict];
    [temp removeObjectForKey:@"body"];
    [temp addEntriesFromDictionary:body];
    
    self = [super initWithDictionary:temp error:nil];
    if (self) {
        
    }
    return self;
}


@end

@implementation ClubListEntity

@end
