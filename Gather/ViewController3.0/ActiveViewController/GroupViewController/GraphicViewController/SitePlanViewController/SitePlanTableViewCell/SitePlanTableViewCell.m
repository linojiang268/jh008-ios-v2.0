//
//  SitePlanTableViewCell.m
//  Gather
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "SitePlanTableViewCell.h"

@implementation SitePlanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = color_with_hex(kColor_6e7378);
}

@end
