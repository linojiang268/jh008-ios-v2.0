//
//  Network+ApplyStar.m
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+ApplyStar.h"

@implementation Network (ApplyStar)

+ (void)applyStarWithRealName:(NSString *)realName contactPhone:(NSString *)contactPhone email:(NSString *)emial intro:(NSString *)intro cityIds:(NSArray *)cityIds activeTagIds:(NSArray *)activeTagIds individualityTagIds:(NSArray *)individualityTagIds imgIds:(NSArray *)imgIds lon:(CGFloat)lon lat:(CGFloat)lat address:(NSString *)address success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:realName forKey:@"realName"];
    [params setObject:contactPhone forKey:@"contactPhone"];
    [params setObject:emial forKey:@"email"];
    [params setObject:intro forKey:@"intro"];
    [params setObject:cityIds forKey:@"cityIds"];
    [params setObject:activeTagIds forKey:@"actTagIds"];
    [params setObject:individualityTagIds forKey:@"userTagIds"];
    [params setObject:imgIds forKey:@"imgIds"];
    [params setObject:@(lon) forKey:@"lon"];
    [params setObject:@(lat) forKey:@"lat"];
    [params setObject:address forKey:@"address"];
    
    [self POST:@"act/vip/apply" params:params success:success failure:failure];
}

@end
