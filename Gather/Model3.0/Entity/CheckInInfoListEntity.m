//
//  ActiveGroupCheckInInfoEntity.m
//  Gather
//
//  Created by apple on 15/4/3.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "CheckInInfoListEntity.h"

@implementation CheckInInfoEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    NSDictionary *body = [dict objectForKey:@"body"][@"checkin"];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:dict];
    [temp removeObjectForKey:@"body"];
    [temp addEntriesFromDictionary:body];
    
    self = [super initWithDictionary:temp error:nil];
    if (self) {

    }
    return self;
}

@end


@implementation CheckInInfoListEntity

@end

