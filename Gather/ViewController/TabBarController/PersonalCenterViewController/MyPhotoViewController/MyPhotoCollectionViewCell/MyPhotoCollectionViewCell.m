//
//  MyPhotoCollectionViewCell.m
//  Gather
//
//  Created by apple on 15/1/20.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "MyPhotoCollectionViewCell.h"

@implementation MyPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
}

@end
