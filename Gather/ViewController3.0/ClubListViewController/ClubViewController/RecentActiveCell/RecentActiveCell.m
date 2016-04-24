//
//  RecentActiveCell.m
//  Gather
//
//  Created by apple on 15/4/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "RecentActiveCell.h"

@interface RecentActiveCell ()

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end

@implementation RecentActiveCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsEnd:(BOOL)isEnd {
    
    if (isEnd) {
        self.nameLabel.textColor = color_with_hex(0x555555);
        self.lineView.backgroundColor = color_with_hex(0x555555);
        [self.timeButton setTitleColor:color_with_hex(0x555555) forState:UIControlStateNormal];
        self.timeButton.layer.borderWidth = 1.0;
        self.timeButton.layer.masksToBounds = YES;
        self.timeButton.layer.borderColor = [color_with_hex(0x555555) CGColor];
//        [self.timeButton setBackgroundImage:image_with_name(@"img_club_time_border_end") forState:UIControlStateNormal];
        [self.shadowView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
    }else {
        self.nameLabel.textColor = color_white;
        self.lineView.backgroundColor = color_white;
        [self.timeButton setTitleColor:color_white forState:UIControlStateNormal];
        self.timeButton.layer.borderWidth = 1.0;
        self.timeButton.layer.masksToBounds = YES;
        self.timeButton.layer.borderColor = [color_white CGColor];
//        [self.timeButton setBackgroundImage:image_with_name(@"img_club_time_border_not_end") forState:UIControlStateNormal];
        [self.shadowView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setSeparatorViewHidden:YES];
}


@end
