//
//  MyCheckInTableViewCell.m
//  Gather
//
//  Created by apple on 15/2/2.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "MyCheckInTableViewCell.h"

@interface MyCheckInTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *seeButton;

@end

@implementation MyCheckInTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self.timeLabel setTextColor:color_with_hex(kColor_6e7378)];
    [self.isEndLabel setTextColor:color_with_hex(kColor_6e7378)];
    [self.seeButton.layer setMasksToBounds:YES];
    [self.seeButton.layer setBorderColor:[color_with_hex(kColor_ff9933) CGColor]];
    [self.seeButton.layer setCornerRadius:5.0];
    [self.seeButton.layer setBorderWidth:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
