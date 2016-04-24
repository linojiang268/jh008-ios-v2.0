//
//  PhotoTableViewCell.m
//  Gather
//
//  Created by apple on 15/1/4.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "PersonalHomePagePhotoTableViewCell.h"

@interface PersonalHomePagePhotoTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayoutConstraint;

@end

@implementation PersonalHomePagePhotoTableViewCell

- (void)unfold:(BOOL)unfold {
    self.heightLayoutConstraint.constant = unfold ? CGRectGetHeight([[UIScreen mainScreen] bounds]) : 120;
}

- (void)clearView {
    UIView *view = [self.contentView viewWithTag:88];
    [view removeFromSuperview];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
