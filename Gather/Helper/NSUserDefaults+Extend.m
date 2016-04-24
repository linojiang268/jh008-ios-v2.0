//
//  NSUserDefaults+Extend.m
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "NSUserDefaults+Extend.h"

@implementation NSUserDefaults (Extend)

+ (instancetype)userDefaults {
    return [NSUserDefaults standardUserDefaults];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName {
    [[self userDefaults] setObject:value forKey:defaultName];
    [[self userDefaults] synchronize];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName {
    [[self userDefaults] setBool:value forKey:defaultName];
    [[self userDefaults] synchronize];
}

+ (id)objectForKey:(NSString *)defaultName {
    return [[self userDefaults] objectForKey:defaultName];
}

+ (BOOL)boolForKey:(NSString *)defaultName {
    return [[self userDefaults] boolForKey:defaultName];
}

@end
