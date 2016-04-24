//
//  DynamicPhotoCollectionViewCell.m
//  Gather
//
//  Created by apple on 15/1/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "DynamicPhotoCollectionViewCell.h"

@interface DynamicPhotoCollectionViewCell ()

@end

@implementation DynamicPhotoCollectionViewCell

- (void)awakeFromNib {
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setImageURL:(NSString *)url {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder_image];
}

@end
