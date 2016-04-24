//
//  AttentionTableViewCell.m
//  Gather
//
//  Created by apple on 15/3/25.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "AttentionTableViewCell.h"

@implementation AttentionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = color_with_hex(kColor_f8f8f8);
    self.titleLabel.textColor = color_with_hex(kColor_8e949b);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setSeparatorViewHidden:YES];
}

@end
