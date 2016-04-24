//
//  SVBlurView.m
//  SVBlurView
//
//  Created by Sam Vermette on 19.10.13.
//  Copyright (c) 2013 Sam Vermette. All rights reserved.
//

#import "SVBlurView.h"
#import "UIImage+ImageEffects.h"

NSString * const SVBlurViewImageKey = @"SVBlurViewImageKey";

@interface SVBlurView ()

@end


@implementation SVBlurView

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.blurRadius = 20;
        self.saturationDelta = 1.5;
        self.tintColor = nil;
        self.viewToBlur = nil;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeObject:[UIImage imageWithCGImage:(CGImageRef)self.layer.contents] forKey:SVBlurViewImageKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    self.layer.contents = (id)[[coder decodeObjectForKey:SVBlurViewImageKey] CGImage];
}

- (UIView *)viewToBlur {
    if(_viewToBlur)
        return _viewToBlur;
    return self.superview;
}

- (void)updateBlur {
    UIGraphicsBeginImageContextWithOptions(self.viewToBlur.bounds.size, NO, 0.0);
    [self.viewToBlur drawViewHierarchyInRect:self.viewToBlur.bounds afterScreenUpdates:NO];
    UIImage *complexViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    float scale = [UIScreen mainScreen].scale;
    CGRect translationRect = [self convertRect:self.bounds toView:self.viewToBlur];
    CGRect scaledSuperviewFrame = CGRectApplyAffineTransform(translationRect, CGAffineTransformMakeScale(scale, scale));
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect(complexViewImage.CGImage, scaledSuperviewFrame);
    UIImage *croppedImage = [UIImage imageWithCGImage:croppedImageRef scale:complexViewImage.scale orientation:complexViewImage.imageOrientation];
    UIImage *blurredImage = [self applyBlurToImage:croppedImage];
    CGImageRelease(croppedImageRef);
    
    self.layer.contents = (id)blurredImage.CGImage;
}

- (UIImage *)applyBlurToImage:(UIImage *)image {
    return [image applyBlurWithRadius:self.blurRadius
                            tintColor:self.tintColor
                saturationDeltaFactor:self.saturationDelta
                            maskImage:nil];
}

- (void)didMoveToSuperview {
    if(self.superview && self.viewToBlur.superview) {
        self.backgroundColor = [UIColor clearColor];
        [self updateBlur];
    }
    else if (!self.layer.contents) {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
