//
//  CommentTableViewCell.m
//  Gather
//
//  Created by apple on 15/1/28.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveCommentTableViewCell.h"

@implementation ActiveCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    circle_view(self.headImageView);
    
    self.nicknameLabel.textColor = color_with_hex(kColor_6e7378);
    self.contentLabel.textColor = color_with_hex(kColor_8e949b);
    self.timeLabel.textColor = color_with_hex(kColor_6e7378);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
