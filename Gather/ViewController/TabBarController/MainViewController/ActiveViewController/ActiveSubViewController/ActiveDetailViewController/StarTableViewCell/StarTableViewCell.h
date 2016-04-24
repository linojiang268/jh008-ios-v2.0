//
//  StarTableViewCell.h
//  Gather
//
//  Created by apple on 15/1/28.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarListEntity.h"

@interface StarTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) StarListEntity *starInfo;

- (void)tapStarHandler:(void(^)(NSUInteger index))handler;

@end
