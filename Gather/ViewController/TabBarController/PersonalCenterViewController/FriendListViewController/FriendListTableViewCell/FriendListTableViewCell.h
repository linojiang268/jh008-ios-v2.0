//
//  FriendListTableViewCell.h
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FriendListTableViewCell : UITableViewCell

- (void)setHeadImageStringURL:(NSString *)stringURL;
- (void)setNickname:(NSString *)nickname;
- (void)setSexWithIntSex:(NSUInteger)intSex;
- (void)setIsStar:(NSUInteger)isStar;
- (void)setIntro:(NSString *)intro;
- (void)setIsFocus:(NSUInteger)isFocus;

- (void)setAddOrCancelFocusHandler:(void(^)(int currentFocusStatus))handler;

@end
