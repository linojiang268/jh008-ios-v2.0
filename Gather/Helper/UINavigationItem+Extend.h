//
//  UINavigationItem+Extend.h
//  Gather
//
//  Created by Ray on 14-12-26.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockBarButtonItem.h"

@interface UINavigationItem (Extend)

- (void)addLeftItem:(BlockBarButtonItem *)item;
- (void)addRightItem:(BlockBarButtonItem *)item;


@end
