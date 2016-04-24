//
//  NSString+Extend.h
//  Gather
//
//  Created by Ray on 14-12-23.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extend)

- (BOOL)validateMobile;
- (BOOL)validateEmail;
- (BOOL)isChinese;
- (int)countWord;

- (NSString *)md5;

- (NSString *)dateString;
- (NSString *)monthAndDayString;
- (NSString *)yearMonthDayString;
- (NSString *)yearMonthDayPointString;

+ (NSString *)sexFromInt:(int)sex;
- (NSInteger)intSexFromSelf;

@end
