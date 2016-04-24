//
//  ClubIntroCell.m
//  Gather
//
//  Created by apple on 15/4/14.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ClubIntroCell.h"

@implementation ClubIntroCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    self.introLabel.textColor = color_with_hex(kColor_8e949b);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
