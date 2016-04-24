//
//  ActiveDetailHeaderView.m
//  Gather
//
//  Created by apple on 15/1/27.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveDetailHeaderView.h"

@interface ActiveDetailHeaderView()

@end

@implementation ActiveDetailHeaderView

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    if (self) {
        self.bannerView.showPageControl = NO;
        self.bannerView.imageViewContentMode = UIViewContentModeScaleAspectFill;// | UIViewContentModeLeft | UIViewContentModeRight;
        self.titleLabel.text = @"";
        
        self.parallaxHeaderView = [ParallaxHeaderView parallaxHeaderViewWithCGSize:CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight(self.frame))];
        self.parallaxHeaderView.alpha = 0.0;
        [self insertSubview:self.parallaxHeaderView belowSubview:self.shadowView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [self init];
    if (self) {
        self.frame = frame;
    }
    return self;
}

@end
