//
//  GroupMemberTableViewCell.h
//  Gather
//
//  Created by apple on 15/3/17.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupEmptyView.h"

@interface GroupMemberTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;
@property (nonatomic, strong) GroupEmptyView *emptyView;


@property (nonatomic, strong) NSArray *memberArray;

- (void)tapMemberHandler:(void(^)(NSUInteger index))handler;

- (void)hideMoreButton;

@end
