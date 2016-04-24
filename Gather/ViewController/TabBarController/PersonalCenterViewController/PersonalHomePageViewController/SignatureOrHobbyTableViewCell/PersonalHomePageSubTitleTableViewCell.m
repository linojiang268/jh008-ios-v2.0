//
//  SignatureOrHobbyTableViewCell.m
//  Gather
//
//  Created by apple on 15/1/4.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "PersonalHomePageSubTitleTableViewCell.h"

@interface PersonalHomePageSubTitleTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTitleMarginBottom;
@end

@implementation PersonalHomePageSubTitleTableViewCell

- (void)awakeFromNib {
    
    self.subTitleLabel.text = @"未填写";
    
    self.titleLabel.textColor = color_with_hex(kColor_6e7378);
    self.subTitleLabel.textColor = color_with_hex(kColor_8e949b);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}

- (void)setSubTitle:(NSString *)subTitle {
    [self.subTitleLabel setText:subTitle];
}

- (void)hideSubTitle {
    [self.subTitleLabel setText:nil];
    [self.subTitleMarginBottom setConstant:8];
}

@end
