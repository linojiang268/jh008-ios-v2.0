//
//  TagItemCell.h
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagItemCell : UICollectionViewCell

- (void)setTitle:(NSString *)title;
- (void)setItemSelected:(BOOL)selected;
- (void)setSelectedHander:(BOOL(^)(NSUInteger tag))selectedHandler deselectedHandler:(BOOL(^)(NSUInteger tag))deselectedHandler;

@end
