//
//  GroupCommentTableViewCell.m
//  Gather
//
//  Created by apple on 15/3/17.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "GroupCommentTableViewCell.h"

@implementation GroupCommentTableViewCell

- (void)awakeFromNib {
    self.timeLabel.textColor = color_with_hex(kColor_6e7378);
    circle_view(self.headImageView);
    [self.headImageView setImage:placeholder_image];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
