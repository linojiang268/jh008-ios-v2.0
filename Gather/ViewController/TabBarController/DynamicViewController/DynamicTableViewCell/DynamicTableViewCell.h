//
//  DynamicTableViewCell.h
//  Gather
//
//  Created by apple on 15/1/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicListEntity.h"
#import "DynamicCacheEntity.h"

@interface DynamicTableViewCell : UITableViewCell

- (void)setValue:(id)value user:(SimpleUserInfoEntity *)user;
- (void)setPublishValue:(id)value;
- (void)setCommentButtonTitle:(NSString *)title;

- (void)republish:(void(^)(void))handler;
- (void)deleteHandler:(void(^)(void))handler;
- (void)commentHandler:(void(^)(void))handler;
- (void)didTapImageViewHandler:(void(^)(id sender, UIImage *scaleImage, NSUInteger index))handler;
- (void)setHeadImageTapHandler:(void (^)(void))headImageTapHandler;

@end
