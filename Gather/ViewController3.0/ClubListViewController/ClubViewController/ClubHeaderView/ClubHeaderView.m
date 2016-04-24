//
//  ClubHeaderView.m
//  Gather
//
//  Created by apple on 15/4/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ClubHeaderView.h"

@implementation ClubHeaderView

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    if (self) {
        
        self.logoImageView.layer.masksToBounds = YES;
        self.logoImageView.layer.cornerRadius =  CGRectGetWidth(self.logoImageView.bounds) / 2;
        
        self.segment = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"近期活动", @"社团简介"]];
        self.segment.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 44, CGRectGetWidth([[UIScreen mainScreen] bounds]), 44);
        self.segment.font = [UIFont systemFontOfSize:16];
        self.segment.textColor = color_with_hex(0x666666);
        self.segment.selectedTextColor = color_with_hex(kColor_ff9933);
        self.segment.selectionIndicatorColor = color_with_hex(kColor_ff9933);
        self.segment.selectionIndicatorHeight = 2;
        self.segment.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        self.segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        [self addSubview:self.segment];

        self.fansLabel.textColor = color_with_hex(kColor_6e7378);
        self.activeNumberLabel.textColor = color_with_hex(kColor_6e7378);
    }
    return self;
}

@end
