//
//  CustomButton.m
//  Gather
//
//  Created by apple on 15/2/9.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (CGRect)contentRectForBounds:(CGRect)bounds {
    return self.bounds;
}

/*- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect rect = CGRectMake(0, 0, 40, 40);

    CGFloat selfHeight = CGRectGetHeight(self.bounds);
    CGFloat imageHalfHeight = 20;
    CGFloat centerY = selfHeight / 2;

    
    rect.origin.y = selfHeight - (centerY - imageHalfHeight) + ((centerY - imageHalfHeight) / 2) - 26;
    rect.origin.x = (CGRectGetWidth(self.bounds) / 2) - 17;
    
    return rect;
    
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect rect = CGRectMake(0, 0, 40, 40);
    
    rect.origin.y = (CGRectGetHeight(self.bounds) / 2) - 30;
    rect.origin.x = (CGRectGetWidth(self.bounds) / 2) - 20;
    
    return rect;
}*/

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    UIImage *image = [self imageForState:UIControlStateNormal];
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGFloat selfHeight = CGRectGetHeight(self.bounds);
    CGFloat imageHalfHeight = image.size.height / 2;
    CGFloat centerY = selfHeight / 2;
    
    
    rect.origin.y = selfHeight - (centerY - imageHalfHeight) + ((centerY - imageHalfHeight) / 2) - 26;
    
    #pragma mark - 3.0
    //rect.origin.x = (CGRectGetWidth(self.bounds) / 2) - 17;
    
    rect.size.width = CGRectGetWidth(self.bounds);
    
    return rect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    #pragma mark - 3.0
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImage *image = [self imageForState:UIControlStateNormal];
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGFloat imageSelfHeight = image.size.height / 2;
    
    rect.origin.y = (CGRectGetHeight(self.bounds) / 2) - (imageSelfHeight + 10);
    rect.origin.x = (CGRectGetWidth(self.bounds) / 2) - (image.size.width / 2);
    
    return rect;
}

@end
