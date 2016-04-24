//
//  ClubListCellView.m
//  Gather
//
//  Created by apple on 15/4/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ClubListCell.h"

@implementation ClubListCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    self.contentView.backgroundColor =  color_with_hex(kColor_f8f8f8);
    self.fansLabel.textColor = color_with_hex(kColor_6e7378);
    self.activeNumberLabel.textColor = color_with_hex(kColor_6e7378);
    
    circle_view(self.logoImageView);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
