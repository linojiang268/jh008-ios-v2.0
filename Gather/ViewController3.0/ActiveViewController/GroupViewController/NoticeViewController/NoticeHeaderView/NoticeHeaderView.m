//
//  NoticeHeaderView.m
//  Gather
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "NoticeHeaderView.h"

@implementation NoticeHeaderView

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    if (self) {
        self.backgroundColor = color_with_hex(kColor_f8f8f8);
        self.searchButton.backgroundColor = color_white;
        round_button(self.textFieldView, round_button_default_color);
        round_button(self.searchButton, round_button_default_color);
    }
    return self;
}

@end
