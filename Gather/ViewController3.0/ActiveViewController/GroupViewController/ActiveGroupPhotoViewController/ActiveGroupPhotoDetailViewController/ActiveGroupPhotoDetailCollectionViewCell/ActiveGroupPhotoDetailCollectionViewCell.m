//
//  ActiveGroupPhotoDetailCollectionViewCell.m
//  Gather
//
//  Created by apple on 15/4/2.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveGroupPhotoDetailCollectionViewCell.h"

@implementation ActiveGroupPhotoDetailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
