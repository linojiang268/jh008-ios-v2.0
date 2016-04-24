//
//  BlockBarButtonItem.m
//  Gather
//
//  Created by Ray on 14-12-26.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "BlockBarButtonItem.h"

@interface BlockBarButtonItem ()

@property (nonatomic, copy) void(^clickHandler)(BlockBarButtonItem *item);

@property (nonatomic,strong) UIImage *selectedImage;

@end

@implementation BlockBarButtonItem

- (instancetype)initWithTitle:(NSString *)title clickHandler:(void(^)(BlockBarButtonItem *item))clickHandler {
    self = [super initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(clickHandler:)];
    if (self) {
        self.clickHandler = clickHandler;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlight:(UIImage *)highlight clickHandler:(void(^)(BlockBarButtonItem *item))clickHandler{
    
    CGSize size = CGSizeZero;
    
    if (image.size.height > highlight.size.height) {
        size.height = image.size.height;
    }else {
        size.height = highlight.size.height;
    }
    if (image.size.width > highlight.size.width) {
        size.width = image.size.width;
    }else {
        size.width = highlight.size.width;
    }
    
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    [item setBounds:CGRectMake(0, 0, size.width, size.height)];
    if (image) {
        [item setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (highlight) {
        [item setBackgroundImage:highlight forState:UIControlStateHighlighted];
        [item setBackgroundImage:highlight forState:UIControlStateSelected];
    }
    
    [item addTarget:self action:@selector(clickHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    self = [super initWithCustomView:item];
    if (self) {
        self.clickHandler = clickHandler;
        self.customButtonView = item;
    }
    return self;
}

- (void)clickHandler:(id)item {
    if (self.clickHandler) {
        self.clickHandler(self);
    }
}

@end
