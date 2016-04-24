//
//  PastActiveCell.m
//  Gather
//
//  Created by apple on 15/4/14.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "PastActiveCell.h"

@implementation PastActiveCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    self.nameLabel.textColor = color_with_hex(kColor_6e7378);
    self.timeLabel.textColor = color_with_hex(kColor_8e949b);
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setSeparatorViewHidden:YES];
}

@end
