//
//  SearchTableViewCell.m
//  Gather
//
//  Created by apple on 15/1/31.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = color_with_hex(kColor_6e7378);
    self.subTitleLabel.textColor = color_with_hex(kColor_8e949b);
    
    self.imgView.layer.masksToBounds = YES;
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
