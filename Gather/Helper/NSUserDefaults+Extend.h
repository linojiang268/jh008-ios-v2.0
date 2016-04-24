//
//  NSUserDefaults+Extend.h
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Extend)

+ (void)setObject:(id)value forKey:(NSString *)defaultName;
+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;

+ (id)objectForKey:(NSString *)defaultName;
+ (BOOL)boolForKey:(NSString *)defaultName;


@end
