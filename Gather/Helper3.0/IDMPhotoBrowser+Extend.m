//
//  IDMPhotoBrowser+Extend.m
//  Gather
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "IDMPhotoBrowser+Extend.h"

@implementation IDMPhotoBrowser (Extend)

// Init
+ (id)controllerWithPhotos:(NSArray *)photosArray {
    IDMPhotoBrowser *controller = [[IDMPhotoBrowser alloc] initWithPhotos:photosArray];
    [controller setup];
    
    return controller;
}

// Init (animated)
+ (id)controllerWithPhotos:(NSArray *)photosArray animatedFromView:(UIView*)view {
    IDMPhotoBrowser *controller = [[IDMPhotoBrowser alloc] initWithPhotos:photosArray animatedFromView:view];
    [controller setup];
    
    return controller;
}

// Init with NSURL objects
+ (id)controllerWithPhotoURLs:(NSArray *)photoURLsArray {
    IDMPhotoBrowser *controller = [[IDMPhotoBrowser alloc] initWithPhotoURLs:photoURLsArray];
    [controller setup];
    
    return controller;
}

// Init with NSURL objects (animated)
+ (id)controllerWithPhotoURLs:(NSArray *)photoURLsArray animatedFromView:(UIView*)view {
    IDMPhotoBrowser *controller = [[IDMPhotoBrowser alloc] initWithPhotoURLs:photoURLsArray animatedFromView:view];
    [controller setup];
    
    return controller;
}

- (void)setup {
    self.displayActionButton = NO;
    self.usePopAnimation = YES;
    self.displayCounterLabel = YES;
    self.displayArrowButton = NO;
}

@end
