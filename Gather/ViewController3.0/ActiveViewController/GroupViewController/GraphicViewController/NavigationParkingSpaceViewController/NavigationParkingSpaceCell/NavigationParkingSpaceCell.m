//
//  NavigationParkingSpaceCell.m
//  Gather
//
//  Created by apple on 15/3/25.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "NavigationParkingSpaceCell.h"

@implementation NavigationParkingSpaceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = color_with_hex(kColor_6e7378);
    self.subTitleLabel.textColor = color_with_hex(kColor_8e949b);
}

@end
