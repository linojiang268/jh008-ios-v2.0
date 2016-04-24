//
//  StrategyTableViewCell.m
//  Gather
//
//  Created by apple on 15/1/30.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "RecallSubViewTableViewCell.h"

@interface RecallSubViewTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *roundView;

@end

@implementation RecallSubViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = color_with_hex(kColor_6e7378);
    self.timeLabel.textColor = color_with_hex(kColor_6e7378);
    self.footTitleLabel.textColor = color_with_hex(kColor_8e949b);
    self.priceLabel.textColor = color_with_hex(kColor_ff9933);
    
    self.imgView.layer.masksToBounds = YES;
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;

    self.roundView.backgroundColor = color_clear;
    self.roundView.layer.masksToBounds = YES;
    self.roundView.layer.borderColor = [color_with_hex(kColor_c9c9c9) CGColor];
    self.roundView.layer.borderWidth = 1.0;
    self.roundView.layer.cornerRadius = 3.0;
    self.backgroundColor = color_with_hex(kColor_f8f8f8);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
