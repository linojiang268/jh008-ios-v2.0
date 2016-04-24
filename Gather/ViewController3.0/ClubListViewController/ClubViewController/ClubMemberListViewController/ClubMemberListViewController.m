//
//  ClubMemberListViewController.m
//  Gather
//
//  Created by apple on 15/4/24.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ClubMemberListViewController.h"
#import "StarCollectionViewCell.h"
#import "MJRefresh.h"
#import "Network+Club.h"
#import "PersonalHomePageViewController.h"

@interface ClubMemberListViewController ()

@property (nonatomic, strong) NSMutableArray *memberArray;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger totalNumber;

@end

@implementation ClubMemberListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage = 0;
    self.memberArray = [[NSMutableArray alloc] init];
    
    CGFloat itemWidth = ((CGRectGetWidth(self.view.bounds) - 4) / 3);
    CGFloat itemHeight = (itemWidth * 2) - (itemWidth / 2);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView setCollectionViewLayout:layout];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([StarCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    __weak typeof(self) wself = self;
    [self.collectionView addHeaderWithCallback:^{
        wself.currentPage = 0;
        [wself requestInfo];
    }];
    [self.collectionView addFooterWithCallback:^{
        [wself requestInfo];
    }];
    [self.collectionView headerBeginRefreshing];
}

- (void)requestInfo {
    
    if (self.currentPage != 0 && self.memberArray.count >= self.totalNumber) {
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];
        return;
    }
    
    self.currentPage += 1;
    __weak typeof(self) wself = self;
    [Network getClubMemberListWithClubId:self.clubId page:self.currentPage size:kSize success:^(FriendListEntity *entity) {
        wself.totalNumber = entity.total_num;
        if (wself.currentPage == 1) {
            [wself.memberArray removeAllObjects];
            [wself.memberArray addObjectsFromArray:entity.users];
        }else {
            [wself.memberArray addObjectsFromArray:entity.users];
        }
        
        [wself.collectionView headerEndRefreshing];
        [wself.collectionView footerEndRefreshing];
        [wself.collectionView reloadDataIfEmptyShowCueWordsView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [wself.collectionView headerEndRefreshing];
        [wself.collectionView footerEndRefreshing];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.memberArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    SimpleUserInfoEntity *entity = self.memberArray[indexPath.item];
    
    [cell.nicknameLabel setText:entity.nick_name];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:thumbnail_url(entity.head_img_url, CGRectGetWidth(cell.imageView.bounds), CGRectGetHeight(cell.imageView.bounds))] placeholderImage:placeholder_image];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SimpleUserInfoEntity *entity = self.memberArray[indexPath.item];
    
    PersonalHomePageViewController *controller = [[UIStoryboard personalCenterStoryboard] instantiateViewControllerWithIdentifier:@"PersonalHomePage"];
    controller.userId = entity.id;
    controller.isFocus = entity.is_focus;
    controller.nickName = entity.nick_name;
    controller.headImageUrl = entity.head_img_url;
    controller.userInfo = (PersonalHomePageEntity *)entity;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}




@end
