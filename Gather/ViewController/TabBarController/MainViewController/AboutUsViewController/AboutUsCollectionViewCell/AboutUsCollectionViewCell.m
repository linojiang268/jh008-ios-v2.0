//
//  AboutUsCollectionViewCell.m
//  Gather
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "AboutUsCollectionViewCell.h"

@implementation AboutUsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.titleLabel setTextColor:color_with_hex(kColor_6e7378)];
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [color_with_hex(kColor_c9c9c9) CGColor];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = color_with_hex(kColor_c9c9c9);
    }else {
        self.backgroundColor = color_clear;
    }
}

@end
