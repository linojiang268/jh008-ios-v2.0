//
//  ActiveConfigEntity.m
//  Gather
//
//  Created by apple on 15/3/18.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveConfigEntity.h"

NSString *const kHintNoOpenString = @"主办方未开启该功能";

@implementation ActiveConfigEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    NSDictionary *body = [dict objectForKey:@"body"][@"act_modules"];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:dict];
    [temp removeObjectForKey:@"body"];
    [temp addEntriesFromDictionary:body];
    
    self = [super initWithDictionary:temp error:err];
    if (self) {
        
    }
    return self;
}

+ (instancetype)sharedConfig {
    return [ActiveConfigSingleton singleton].config ? : nil;
}

@end

@implementation Product

@end

@implementation ActiveMoreConfigEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    NSDictionary *body = [dict objectForKey:@"body"][@"act_info"];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:dict];
    [temp removeObjectForKey:@"body"];
    [temp addEntriesFromDictionary:body];
    
    self = [super initWithDictionary:temp error:err];
    if (self) {
        
    }
    return self;
}

+ (instancetype)sharedMoreConfig{
    return [ActiveConfigSingleton singleton].moreConfig ? : nil;
}

@end


@implementation ActiveConfigSingleton

+ (instancetype)singleton {
    static ActiveConfigSingleton *_activeConfigSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _activeConfigSingleton = [[ActiveConfigSingleton alloc] init];
    });
    return _activeConfigSingleton;
}

@end