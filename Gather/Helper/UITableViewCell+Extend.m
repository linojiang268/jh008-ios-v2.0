//
//  UITableViewCell+Extend.m
//  Gather
//
//  Created by apple on 15/3/24.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "UITableViewCell+Extend.h"

@implementation UITableViewCell (Extend)

- (void)setSeparatorViewHidden:(BOOL)hidden {
    for (UIView *view in [self subviews]) {
        if ([view isMemberOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")]) {
            [view setHidden:hidden];
        }
    }
}

@end
