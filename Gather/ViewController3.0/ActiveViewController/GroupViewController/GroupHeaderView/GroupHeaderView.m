//
//  GroupHeaderView.m
//  Gather
//
//  Created by apple on 15/3/17.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "GroupHeaderView.h"

@implementation GroupHeaderView

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    if (self) {
        
        self.backgroundColor = color_with_hex(kColor_f8f8f8);
        
        round_button(self.roadmapButton,color_white);
        round_button(self.photoButton,color_white);
        [self.roadmapButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.photoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        /*round_button(self.costButton,color_white);
        round_button(self.flowButton,color_white);
        round_button(self.graphicButton,color_white);
        round_button(self.noticeButton,color_white);
        round_button(self.photoButton,color_white);
        [self.flowButton setTitleColor:color_with_hex(kColor_6e7378) forState:UIControlStateNormal];
        [self.graphicButton setTitleColor:color_with_hex(kColor_6e7378) forState:UIControlStateNormal];
        [self.noticeButton setTitleColor:color_with_hex(kColor_6e7378) forState:UIControlStateNormal];
        [self.photoButton setTitleColor:color_with_hex(kColor_6e7378) forState:UIControlStateNormal];*/
    }
    return self;
}

@end
