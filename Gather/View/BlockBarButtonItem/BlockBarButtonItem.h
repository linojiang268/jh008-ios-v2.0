//
//  BlockBarButtonItem.h
//  Gather
//
//  Created by Ray on 14-12-26.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockBarButtonItem : UIBarButtonItem

@property (nonatomic, strong) UIButton *customButtonView;

- (instancetype)initWithTitle:(NSString *)title clickHandler:(void(^)(BlockBarButtonItem *item))clickHandler;
- (instancetype)initWithImage:(UIImage *)image highlight:(UIImage *)highlight clickHandler:(void(^)(BlockBarButtonItem *item))clickHandler;

@end
