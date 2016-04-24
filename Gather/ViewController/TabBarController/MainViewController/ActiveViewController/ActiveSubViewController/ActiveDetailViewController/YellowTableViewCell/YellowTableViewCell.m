//
//  YellowTableViewCell.m
//  Gather
//
//  Created by apple on 15/1/28.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "YellowTableViewCell.h"

@implementation YellowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.titleLabel setTextColor:color_with_hex(kColor_6e7378)];
    [self.subTitle setTextColor:color_with_hex(kColor_8e949b)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
