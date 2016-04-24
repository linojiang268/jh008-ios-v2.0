//
//  UINavigationItem+Extend.m
//  Gather
//
//  Created by Ray on 14-12-26.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "UINavigationItem+Extend.h"

@implementation UINavigationItem (Extend)

- (void)addLeftItem:(BlockBarButtonItem *)item {
    if (!self.leftBarButtonItems.count) {
        [self setLeftBarButtonItem:item animated:YES];
    }else {
        NSMutableArray *items = [NSMutableArray arrayWithArray:self.leftBarButtonItems];;
        [items addObject:item];
        [self setLeftBarButtonItems:items animated:YES];
    }
}

- (void)addRightItem:(BlockBarButtonItem *)item {
    if (!self.rightBarButtonItems.count) {
        [self setRightBarButtonItem:item animated:YES];
    }else {
        NSMutableArray *items = [NSMutableArray arrayWithArray:self.rightBarButtonItems];;
        [items insertObject:item atIndex:0];
        [self setRightBarButtonItems:items animated:YES];
    }
}

@end
