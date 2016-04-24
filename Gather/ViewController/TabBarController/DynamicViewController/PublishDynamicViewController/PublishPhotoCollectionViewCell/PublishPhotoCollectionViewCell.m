//
//  PublishPhotoCollectionViewCell.m
//  Gather
//
//  Created by apple on 15/1/16.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "PublishPhotoCollectionViewCell.h"

@interface PublishPhotoCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PublishPhotoCollectionViewCell

- (void)setImage:(UIImage *)image; {
    [self.imageView sd_setImageWithURL:nil placeholderImage:image];
}

@end
