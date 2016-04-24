//
//  PersonalDynamicTableViewCell.h
//  Gather
//
//  Created by apple on 15/1/16.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicListEntity.h"
#import "DynamicCacheEntity.h"

@interface PersonalDynamicTableViewCell : UITableViewCell

- (void)setLocalCurrentValue:(DynamicCacheEntity *)value previousTime:(NSString *)previousTime;
- (void)setCurrentValue:(DynamicEntity *)value previousTime:(NSString *)previousTime;
- (void)setCommentButtonTitle:(NSString *)title;

- (void)deleteHandler:(void(^)(void))handler;
- (void)commentHandler:(void(^)(void))handler;
- (void)didTapImageViewHandler:(void(^)(id sender, UIImage *scaleImage, NSUInteger index))handler;

@end
