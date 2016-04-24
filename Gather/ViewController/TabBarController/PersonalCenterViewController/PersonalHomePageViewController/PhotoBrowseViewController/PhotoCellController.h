//
//  PhotoBrowseViewController.h
//  Gather
//
//  Created by apple on 15/1/6.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCellController : UICollectionViewController

@property (nonatomic, strong) NSMutableArray *photos;

- (void)setLoadMoreHandler:(void (^)(void))handler;
- (void)setDidSelectedHandler:(void (^)(NSIndexPath *currentIndexPath))handler;

@end
