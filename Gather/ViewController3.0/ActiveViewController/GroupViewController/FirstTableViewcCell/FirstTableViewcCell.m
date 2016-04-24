//
//  FirstTableViewcCell.m
//  Gather
//
//  Created by apple on 15/3/17.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "FirstTableViewcCell.h"

@interface FirstTableViewcCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FirstTableViewcCell

- (void)awakeFromNib {
    // Initialization code
    
    self.titleLabel.textColor = color_with_hex(kColor_6e7378);
    
    self.seeMoreButton.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setSeparatorViewHidden:YES];
}

@end
