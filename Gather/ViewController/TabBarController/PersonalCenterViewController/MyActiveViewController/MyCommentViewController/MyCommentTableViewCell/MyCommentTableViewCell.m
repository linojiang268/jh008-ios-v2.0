//
//  MyCommentTableViewCell.m
//  Gather
//
//  Created by apple on 15/2/2.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "MyCommentTableViewCell.h"

@implementation MyCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.isEndLabel setTextColor:color_with_hex(kColor_6e7378)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
