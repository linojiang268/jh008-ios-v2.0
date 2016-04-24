//
//  ActiveGroupPhotoTableViewCell.m
//  Gather
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveGroupPhotoTableViewCell.h"

@implementation ActiveGroupPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.textColor = color_with_hex(kColor_6e7378);
    self.numberLabel.textColor = color_with_hex(kColor_8e949b);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
