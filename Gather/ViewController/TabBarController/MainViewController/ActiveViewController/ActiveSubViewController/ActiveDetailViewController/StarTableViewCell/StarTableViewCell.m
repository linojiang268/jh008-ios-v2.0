//
//  StarTableViewCell.m
//  Gather
//
//  Created by apple on 15/1/28.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "StarTableViewCell.h"
#import "ActiveStarCollectionViewCell.h"

@interface StarTableViewCell ()

@property (nonatomic, copy) void(^tapStarHandler)(NSUInteger index);

@end

@implementation StarTableViewCell

- (void)awakeFromNib {
    
    self.titleLabel.textColor = color_with_hex(kColor_6e7378);
    
    CGFloat itemWidth = (CGRectGetWidth(self.bounds) / 4);
    CGFloat itemHeight = 101;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setCollectionViewLayout:layout];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ActiveStarCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
}

- (void)tapStarHandler:(void(^)(NSUInteger index))handler {
    self.tapStarHandler = handler;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.starInfo.users.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ActiveStarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    SimpleUserInfoEntity *entity = self.starInfo.users[indexPath.item];
    
    [cell.nicknameLabel setText:entity.nick_name];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:entity.head_img_url] placeholderImage:placeholder_image];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tapStarHandler) {
        self.tapStarHandler(indexPath.item);
    }
}


@end
