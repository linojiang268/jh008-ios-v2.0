//
//  NSString+Extend.m
//  Gather
//
//  Created by Ray on 14-12-23.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "NSString+Extend.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extend)

- (BOOL)validateMobile
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
         || ([regextestcm evaluateWithObject:self] == YES)
         || ([regextestct evaluateWithObject:self] == YES)
         || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//邮箱格式校验
- (BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isChinese {
    int i,n = [self length];
    unichar c;
    for (i=0; i<n; i++) {
        c = [self characterAtIndex:i];
        if (isblank(c)) {
            return NO;
        }else if(isascii(c)){
            return NO;
        }
    }
    return YES;
}

- (int)countWord//汉字算一个，英文字母和数字算半个
{
    int i,n = [self length],l = 0,a=0,b=0;
    unichar c;
    for (i=0; i<n; i++) {
        c = [self characterAtIndex:i];
        if (isblank(c)) {
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if (a==0 && l==0) {
        return 0;
    }
    return (l+(int)ceilf((float)(a+b)/2.0));
}

- (NSString *)md5 {
    const char *cStr = [self UTF8String];//转换成utf-8
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
}

- (NSString *)dateString
{
    return [self dateStringWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)monthAndDayString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:self];
    NSDate *currentDate = [NSDate date];
    
    NSTimeInterval timeInterval1 = [date timeIntervalSince1970];
    NSTimeInterval timeInterval2 = [currentDate timeIntervalSince1970];
    
    if (timeInterval1 < timeInterval2) {
        date = currentDate;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%d月%d日",[dateComponents month],[dateComponents day]];
}

- (NSString *)yearMonthDayString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:self];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%02d-%02d-%02d",[dateComponents year],[dateComponents month],[dateComponents day]];
}

- (NSString *)yearMonthDayPointString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:self];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%02d.%02d.%02d",[dateComponents year],[dateComponents month],[dateComponents day]];
}

//• 刚刚（10分钟内）
//• XX分钟前（10分钟后-1小时内）
//• XX小时前（1小时后-24小时内）
//• 昨天09:35（24小时后-48小时内）
//• 前天09:35（48小时后-72小时内）
//• 09.23 09:35 （当年72小时后）
//• 2014.08.21 12:30（不在当年）
- (NSString *)dateStringWithFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    NSDate *date = [dateFormatter dateFromString:self];
    return [NSString stringFromDate:date];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDate *curDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *curDateComponents = [calendar components:unitFlags fromDate:curDate];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    
    if (curDateComponents.year == dateComponents.year) {
        
        if (curDateComponents.month == dateComponents.month) {
            if (curDateComponents.day == dateComponents.day) {
                return [NSString stringWithFormat:@"今天%02ld:%02ld",(long)dateComponents.hour,(long)dateComponents.minute];
            }else if ((curDateComponents.day - dateComponents.day == 1)) {
                return [NSString stringWithFormat:@"昨天%02ld:%02ld", (long)dateComponents.hour, (long)dateComponents.minute];
            }else if ((curDateComponents.day - dateComponents.day == 2)) {
                return [NSString stringWithFormat:@"前天%02ld:%02ld", (long)dateComponents.hour, (long)dateComponents.minute];
            }
        }
        return [NSString stringWithFormat:@"%02ld月%02ld日 %02ld:%02ld", (long)dateComponents.month, (long)dateComponents.day, (long)dateComponents.hour, (long)dateComponents.minute];
    }
    return [NSString stringWithFormat:@"%ld年%02ld月%02ld日 %02ld:%02ld", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day, (long)dateComponents.hour, (long)dateComponents.minute];
}

+ (NSString *)sexFromInt:(int)sex {
    if (sex == 1) {
        return @"男";
    }
    return @"女";
}

- (NSInteger)intSexFromSelf {
    if ([self isEqualToString:@"男"]) {
        return SexMan;
    }
    return SexWoman;
}

@end
