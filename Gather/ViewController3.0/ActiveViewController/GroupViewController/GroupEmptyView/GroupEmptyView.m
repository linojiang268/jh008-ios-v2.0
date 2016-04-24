//
//  GroupEmptyView.m
//  Gather
//
//  Created by apple on 15/3/18.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "GroupEmptyView.h"

@implementation GroupEmptyView

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    if (self) {
        self.titleLabel.textColor = color_with_hex(kColor_8e949b);
        self.backgroundColor = color_with_hex(kColor_f8f8f8);
        
        CGRect rect = self.bounds;
        rect.size.width = SCREEN_WIDTH;
        self.frame = rect;
    }
    return self;
}

+ (instancetype)viewWithTitle:(NSString *)title {
    GroupEmptyView *view = [[GroupEmptyView alloc] init];
    view.titleLabel.text = title;
    return view;
}

@end
