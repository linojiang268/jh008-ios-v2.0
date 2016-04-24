//
//  GroupFirstHeaderView.m
//  Gather
//
//  Created by apple on 15/3/20.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "GroupFirstHeaderView.h"

@implementation GroupFirstHeaderView

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    if (self) {
        self.backgroundColor = color_with_hex(kColor_f8f8f8);
        self.titleLabel.textColor = color_with_hex(kColor_6e7378);
        self.timeLabel.textColor = color_with_hex(kColor_8e949b);
        self.titleLabel.text = @"";
        self.timeLabel.text = @"";
    }
    return self;
}

+ (instancetype)viewWithTitle:(NSString *)title time:(NSString *)time {
    
    GroupFirstHeaderView *view = [[GroupFirstHeaderView alloc] init];
    view.titleLabel.text = title;
    view.timeLabel.text = time;
    return view;
}

@end
