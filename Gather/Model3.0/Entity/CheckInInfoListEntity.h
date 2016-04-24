//
//  ActiveGroupCheckInInfoEntity.h
//  Gather
//
//  Created by apple on 15/4/3.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol CheckInInfoEntity <NSObject>

@end

@interface CheckInInfoEntity : BaseEntity
/// subject	String	名称
@property (nonatomic, strong) NSString *subject;
///rgb_hex	String	6位十六进制颜色rgb值
@property (nonatomic, strong) NSString *rgb_hex;
///need_sure	int	需要确认：0否，1是
@property (nonatomic, assign) int need_sure;
///order_limit	int	顺序限制：0否，1是
@property (nonatomic, assign) int order_limit;
///has_prize	int	是否有随机奖品：0否，1是
@property (nonatomic, assign) int has_prize;
///status	int	状态：0正常，1已确认
@property (nonatomic, assign) int status;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

@interface CheckInInfoListEntity : BaseEntity

@property (nonatomic, strong) NSArray<CheckInInfoEntity> *checkins;
@property (nonatomic, assign) int total_num;


@end
