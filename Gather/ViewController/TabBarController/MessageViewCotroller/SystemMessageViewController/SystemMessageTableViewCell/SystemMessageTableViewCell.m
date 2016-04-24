//
//  SystemMessageTableViewCell.m
//  Gather
//
//  Created by apple on 15/2/3.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "SystemMessageTableViewCell.h"

@interface SystemMessageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *redPointView;

@end

@implementation SystemMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    circle_view(self.redPointView);
    self.contentLabel.textColor = color_with_hex(kColor_6e7378);
    self.timeLabel.textColor = color_with_hex(kColor_6e7378);
}

- (void)hideRedPoint:(BOOL)hide {
    self.redPointView.hidden = hide;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
