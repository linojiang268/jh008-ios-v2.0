//
//  MomentTableViewCell.m
//  Gather
//
//  Created by apple on 15/3/18.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "MomentTableViewCell.h"

@interface MomentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *pointImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation MomentTableViewCell

- (void)awakeFromNib {
    self.timeLabel.textColor = color_with_hex(kColor_6e7378);
    self.projectLabel.textColor = color_with_hex(kColor_6e7378);
    self.backgroundColor = color_with_hex(kColor_f8f8f8);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setSeparatorViewHidden:YES];
}

- (void)setStatus:(MomentStatus)status {
    UIColor *statusColor = nil;
    switch (status) {
        case MomentStatusIsNoSet:
        case MomentStatusIsAboutToBegin:
            self.pointImageView.image = image_with_name(@"img_active_flow_about_to_begin");
            self.pointImageViewWidthConstraint.constant = 5;
            statusColor = color_with_hex(kColor_6e7378);
            break;
        case MomentStatusIsOngoing:
            self.pointImageViewWidthConstraint.constant = 10;
            self.pointImageView.image = image_with_name(@"img_active_flow_ongoing");
            statusColor = color_with_hex(kColor_ff9933);
            break;
        case MomentStatusIsEnd:
            self.pointImageViewWidthConstraint.constant = 5;
            self.pointImageView.image = image_with_name(@"img_active_flow_end");
            statusColor = color_with_hex(kColor_8e949b);
            break;
    }
    self.timeLabel.textColor = statusColor;
    self.projectLabel.textColor = statusColor;
}

- (void)hideBottomLineView:(BOOL)flag {
    self.bottomLineView.hidden = flag;
}

@end
