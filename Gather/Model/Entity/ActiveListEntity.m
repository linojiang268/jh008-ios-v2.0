//
//  ActiveListEntity.m
//  Gather
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveListEntity.h"

#pragma mark - 列表

@implementation ActiveEntity

- (NSString *)statusString {
    /// 时间状态：1即将开始，2进行中，3筹备中，4已结束
    switch (self.t_status) {
        case 1:
            return @"即将开始";
            break;
        case 2:
            return @"进行中";
            break;
        case 3:
            return @"筹备中";
            break;
        case 4:
            return @"已结束";
            break;
        default:
            break;
    }
    return @"";
}

@end

@implementation ActiveImageEntity

@end

@implementation ActiveDetailEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    NSDictionary *body = dict[@"body"][@"act"];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:dict];
    [temp removeObjectForKey:@"body"];
    [temp addEntriesFromDictionary:body];
    
    return [super initWithDictionary:temp error:err];
}

@end

@implementation ActiveListEntity

@end

#pragma mark - 附近

@implementation NearbyActiveEntity

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSArray *location = [temp objectForKey:@"location"];
    
    [temp setObject:[[location firstObject] stringValue] forKey:@"lon"];
    [temp setObject:[[location lastObject] stringValue] forKey:@"lat"];
    
    return [super initWithDictionary:temp error:nil];
}

@end

@implementation NearbyActiveListEntity

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end
