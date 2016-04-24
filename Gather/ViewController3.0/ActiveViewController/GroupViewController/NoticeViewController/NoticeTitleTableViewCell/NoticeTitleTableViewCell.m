//
//  NoticeTitleTableViewCell.m
//  Gather
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "NoticeTitleTableViewCell.h"

@interface NoticeTitleTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@end

@implementation NoticeTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor = color_with_hex(kColor_ff9933);
}

- (void)setReadStatus:(BOOL)flag {
    
    if (flag) {
        self.statusImageView.image = image_with_name(@"img_newest_notice_read");
    }else {
        self.statusImageView.image = image_with_name(@"img_newest_notice_unread");
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setSeparatorViewHidden:self.isExpand];
}

@end
