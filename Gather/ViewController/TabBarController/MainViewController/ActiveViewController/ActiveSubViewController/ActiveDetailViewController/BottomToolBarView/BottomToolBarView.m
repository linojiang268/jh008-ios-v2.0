//
//  BottomToolBarView.m
//  Gather
//
//  Created by apple on 15/1/28.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BottomToolBarView.h"

@interface BottomToolBarView ()

@end

@implementation BottomToolBarView

- (instancetype)initWithStyle:(ActiveBottomViewStyle)style {
    
#ifdef __Gather_2_0_2__
    switch (style) {
        case ActiveBottomViewStyleShowAll:
            self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
            break;
        case ActiveBottomViewStyleHideApply:
            self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] objectAtIndex:1];
            break;
        case ActiveBottomViewStyleOnlyShowComment:
            self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
            break;
    }
#else
    switch (style) {
        case ActiveBottomViewStyleShowAll:
            self = [[[NSBundle mainBundle] loadNibNamed:[NSStringFromClass([self class]) stringByAppendingString:@"20"] owner:nil options:nil] lastObject];
            break;
        default:
            self = [[[NSBundle mainBundle] loadNibNamed:[NSStringFromClass([self class]) stringByAppendingString:@"20"] owner:nil options:nil] firstObject];
            break;
    }
    
#endif
    if (self) {
        self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 44);
    }
    return self;
}

@end
