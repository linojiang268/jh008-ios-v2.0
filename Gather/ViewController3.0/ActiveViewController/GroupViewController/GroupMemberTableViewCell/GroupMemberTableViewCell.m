//
//  GroupMemberTableViewCell.m
//  Gather
//
//  Created by apple on 15/3/17.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "GroupMemberTableViewCell.h"
#import "ActiveStarCollectionViewCell.h"
#import "FullUserInfoEntity.h"

@interface GroupMemberTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreButtonMarginBottomConstraint;
@property (nonatomic, copy) void(^tapMemberHandler)(NSUInteger index);

@end

@implementation GroupMemberTableViewCell

- (void)awakeFromNib {
    
    round_button(self.seeMoreButton,round_button_default_color);
    self.backgroundColor = color_white;
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
    
    GroupEmptyView *view = [GroupEmptyView viewWithTitle:@"还没有人报名"];
    view.tag = 88;
    
    CGRect rect = view.frame;
    rect.origin.y = 41;
    rect.size.height = CGRectGetHeight(self.bounds) - 41;
    view.frame = rect;
    self.emptyView = view;
    
    [self addSubview:self.emptyView];
}

- (void)tapMemberHandler:(void(^)(NSUInteger index))handler {
    self.tapMemberHandler = handler;
}

- (void)hideMoreButton {
    self.moreButtonHeightConstraint.constant = 0;
    self.moreButtonMarginBottomConstraint.constant = -10;
    [self layoutIfNeeded];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.memberArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ActiveStarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    SimpleUserInfoEntity *entity = self.memberArray[indexPath.item];
    
    [cell.nicknameLabel setText:entity.nick_name];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:entity.head_img_url] placeholderImage:placeholder_image];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tapMemberHandler) {
        self.tapMemberHandler(indexPath.item);
    }
}


@end
