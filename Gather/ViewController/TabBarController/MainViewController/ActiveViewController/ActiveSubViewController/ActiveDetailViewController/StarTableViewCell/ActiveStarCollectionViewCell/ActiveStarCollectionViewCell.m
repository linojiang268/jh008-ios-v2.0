//
//  ActiveStarCollectionViewCell.m
//  Gather
//
//  Created by apple on 15/1/28.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveStarCollectionViewCell.h"

@implementation ActiveStarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    circle_view(self.imageView);
    self.nicknameLabel.textColor = color_with_hex(kColor_6e7378);
}

@end
