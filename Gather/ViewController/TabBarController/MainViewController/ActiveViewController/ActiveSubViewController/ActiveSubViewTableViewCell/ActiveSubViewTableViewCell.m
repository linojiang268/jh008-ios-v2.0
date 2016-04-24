//
//  ActiveSubViewTableViewCell.m
//  Gather
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveSubViewTableViewCell.h"

@implementation ActiveSubViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundImageView.layer.masksToBounds = YES;
}

@end
