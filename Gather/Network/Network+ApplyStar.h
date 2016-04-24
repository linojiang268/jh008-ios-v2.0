//
//  Network+ApplyStar.h
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"

@interface Network (ApplyStar)

+ (void)applyStarWithRealName:(NSString *)realName contactPhone:(NSString *)contactPhone email:(NSString *)emial intro:(NSString *)intro cityIds:(NSArray *)cityIds activeTagIds:(NSArray *)activeTagIds individualityTagIds:(NSArray *)individualityTagIds imgIds:(NSArray *)imgIds lon:(CGFloat)lon lat:(CGFloat)lat address:(NSString *)address success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
