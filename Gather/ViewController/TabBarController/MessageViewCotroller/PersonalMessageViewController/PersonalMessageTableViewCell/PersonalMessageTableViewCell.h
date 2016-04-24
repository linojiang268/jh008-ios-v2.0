//
//  PersonalMessageTableViewCell.h
//  Gather
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalMessageTableViewCell : UITableViewCell

- (void)setHeadImageURL:(NSString *)imageURL;
- (void)setNickname:(NSString *)nickname;
- (void)setSex:(NSUInteger)sex;
- (void)setLastContent:(NSString *)content;
- (void)setlastTime:(NSString *)time;

- (void)hideRedPoint:(BOOL)hide;

- (void)setHeadImageTapHandler:(void (^)(void))headImageTapHandler;

@end
