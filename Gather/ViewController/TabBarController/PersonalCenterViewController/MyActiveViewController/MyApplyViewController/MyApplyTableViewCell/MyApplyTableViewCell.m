//
//  MyApplyTableViewCell.m
//  Gather
//
//  Created by apple on 15/2/2.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "MyApplyTableViewCell.h"

@interface MyApplyTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *checkInButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyInfoHeight;
@property (weak, nonatomic) IBOutlet UIView *applyInfoView;

@property (nonatomic, copy) void(^checkInHandler)(void);

@end

@implementation MyApplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.timeLabel setTextColor:color_with_hex(kColor_6e7378)];
    [self.isEndLabel setTextColor:color_with_hex(kColor_6e7378)];
    [self.checkInButton.layer setMasksToBounds:YES];
    [self.checkInButton.layer setBorderColor:[color_with_hex(kColor_ff9933) CGColor]];
    [self.checkInButton.layer setCornerRadius:5.0];
    [self.checkInButton.layer setBorderWidth:1.0];
    [self.checkInButton setHidden:YES];
}

- (void)showApplyInfo:(BOOL)flag {
    if (flag) {
        self.applyInfoHeight.constant = 52;
        self.applyInfoView.hidden = NO;
    }else {
        self.applyInfoHeight.constant = 0;
        self.applyInfoView.hidden = YES;
    }
}

- (IBAction)checkIn:(id)sender {
    if (self.checkInHandler) {
        self.checkInHandler();
    }
}

- (void)showCheckInButton:(BOOL)show {
    self.checkInButton.hidden = !show;
}

- (void)checkInHandler:(void(^)(void))handler {
    self.checkInHandler = handler;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
