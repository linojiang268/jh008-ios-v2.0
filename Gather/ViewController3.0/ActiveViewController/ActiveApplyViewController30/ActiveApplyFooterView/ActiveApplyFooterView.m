//
//  ActiveApplyFooterView.m
//  Gather
//
//  Created by apple on 15/3/31.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveApplyFooterView.h"

@interface ActiveApplyFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ActiveApplyFooterView

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    if (self) {
        [self.commitButton setTitleColor:color_with_hex(kColor_ff9933) forState:UIControlStateNormal];
        round_button(self.commitButton, round_button_default_color);
    }
    return self;
}

- (void)hideCostView {
    self.titleLabel.hidden = YES;
    self.costLabel.hidden = YES;
}

@end
