//
//  PersonalHomePageHeaderView.h
//  Gather
//
//  Created by apple on 15/1/4.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParallaxHeaderView.h"

@interface PersonalHomePageHeaderView : UIView

@property (nonatomic, strong) ParallaxHeaderView *parallaxHeaderView;

- (void)setHeadImageWithStringURL:(NSString *)stringURL;
- (void)setNickname:(NSString *)nickname;
- (void)setSexWithIntSex:(int)intSex;
- (void)setIsStar:(int)isStar;
- (void)setFocusNumber:(int)focusNumber;
- (void)setFansNumber:(int)fansNumber;

- (void)setFocusOrFansClickHandler:(void(^)(FriendType friendType))focusOrFansHandler
             interviewClickHandler:(void(^)(void))interviewClickHandler
               dynamicClickHandler:(void(^)(void))dynamicClickHandler
                activeClickHandler:(void(^)(void))activeClickHandler;
@end
