//
//  FlowMenuCell.m
//  Gather
//
//  Created by apple on 15/3/24.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "FlowMenuCell.h"

@implementation FlowMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = color_with_hex(kColor_f8f8f8);
    self.titleLabel.textColor = color_with_hex(kColor_6e7378);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setSeparatorViewHidden:YES];
}

@end
