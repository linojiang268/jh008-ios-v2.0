//
//  NSDate+Extend.m
//  Gather
//
//  Created by apple on 15/1/21.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "NSDate+Extend.h"

@implementation NSDate (Extend)

+ (NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
