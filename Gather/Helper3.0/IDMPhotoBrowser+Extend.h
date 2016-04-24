//
//  IDMPhotoBrowser+Extend.h
//  Gather
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "IDMPhotoBrowser.h"

@interface IDMPhotoBrowser (Extend)

// Init
+ (id)controllerWithPhotos:(NSArray *)photosArray;

// Init (animated)
+ (id)controllerWithPhotos:(NSArray *)photosArray animatedFromView:(UIView*)view;

// Init with NSURL objects
+ (id)controllerWithPhotoURLs:(NSArray *)photoURLsArray;

// Init with NSURL objects (animated)
+ (id)controllerWithPhotoURLs:(NSArray *)photoURLsArray animatedFromView:(UIView*)view;

@end
