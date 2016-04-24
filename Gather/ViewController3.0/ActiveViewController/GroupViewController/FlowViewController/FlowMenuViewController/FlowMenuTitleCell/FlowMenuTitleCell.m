//
//  FlowMenuTitleCell.m
//  Gather
//
//  Created by apple on 15/3/24.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "FlowMenuTitleCell.h"

@implementation FlowMenuTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = color_with_hex(kColor_ff9933);
    self.subTitleLabel.textColor = color_with_hex(kColor_8e949b);
    self.backgroundColor = color_with_hex(kColor_f8f8f8);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setSeparatorViewHidden:YES];
}

@end
