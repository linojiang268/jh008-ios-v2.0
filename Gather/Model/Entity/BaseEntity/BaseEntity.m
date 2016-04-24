//
//  BaseEntity.m
//  Gather
//
//  Created by Ray on 14-12-23.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@implementation StatusEntity

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation BaseEntity

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    
    NSDictionary *body = [dict objectForKey:@"body"];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:dict];
    [temp removeObjectForKey:@"body"];
    [temp addEntriesFromDictionary:body];
    
    return [super initWithDictionary:temp error:err];
}

@end

@implementation OptionalJSONModel

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end
