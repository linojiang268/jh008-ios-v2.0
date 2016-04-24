//
//  SelectImageViewController.h
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GetImageType) {
    GetImageTypeOriginal = 1,
    GetImageTypeEdited   = 2,
};

@interface SelectImageViewController : NSObject

- (instancetype)initWithViewController:(id)viewController getType:(GetImageType)type done:(void(^)(UIImage *image))done;

- (void)open;

@end
