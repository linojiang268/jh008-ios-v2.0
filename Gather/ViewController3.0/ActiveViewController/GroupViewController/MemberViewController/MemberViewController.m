//
//  MemberViewController.m
//  Gather
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "MemberViewController.h"
#import "StarCollectionViewCell.h"
#import "MJRefresh.h"
#import "Network+Group.h"
#import "PersonalHomePageViewController.h"
#import "StarSearchViewController.h"
#import "StarClassifyViewController.h"

@interface MemberViewController ()

@property (nonatomic, strong) NSMutableArray *memberArray;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger totalNumber;

@property (nonatomic, strong) ActiveGroupInfoEntity *groupInfoEntity;

@end

@implementation MemberViewController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isMyGroup) {
        SHOW_LOAD_HUD;
        __weak typeof(self) wself = self;
        [Network getGroupInfoWithGroupId:[ActiveMoreConfigEntity sharedMoreConfig].group_id success:^(ActiveGroupInfoEntity *entity) {
            DISMISS_HUD;
            wself.groupInfoEntity = entity;
            wself.title = wself.groupInfoEntity.subject;
            if (wself.memberArray.count > 0) {
                [wself.collectionView reloadDataIfEmptyShowCueWordsView];
            }
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"小组信息获取失败"];
            [wself.navigationController popViewControllerAnimated:YES];
        }];
    }
    if (self.navigationItem.rightBarButtonItems.count == 0) {
        if ([ActiveConfigEntity sharedConfig].show_group == ActiveConfigStatusHasSet && [ActiveMoreConfigEntity sharedMoreConfig].group_id > 0 && !self.isMyGroup) {
            __weak typeof(self) wself = self;
            [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"我的小组" clickHandler:^(BlockBarButtonItem *item) {
                MemberViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"Member"];
                controller.isMyGroup = YES;
                [wself.navigationController pushViewController:controller animated:YES];
            }]];
        }
    }
}

- (void)requestInfo {
    if (self.currentPage != 0 && self.memberArray.count >= self.totalNumber) {
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];
        return;
    }
    
    self.currentPage += 1;
    __weak typeof(self) wself = self;
    
    if (self.isMyGroup) {
        [Network getMyGroupMemberListWithGroupId:[ActiveMoreConfigEntity sharedMoreConfig].group_id cityId:[Common getCurrentCityId] page:self.currentPage size:kSize success:^(FriendListEntity *entity) {
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
            [SVProgressHUD showInfoWithStatus:@"获取小组信息失败"];
        }];
    }else {
        [Network getMemberListWithActiveId:self.activeId cityId:[Common getCurrentCityId] page:self.currentPage size:kSize success:^(FriendListEntity *entity) {
            wself.totalNumber = entity.total_num;
            if (wself.currentPage == 1) {
                [wself.memberArray removeAllObjects];
                [wself.memberArray addObjectsFromArray:entity.users];
            }else {
                [wself.memberArray addObjectsFromArray:entity.users];
            }
            [wself.collectionView headerEndRefreshing];
            [wself.collectionView footerEndRefreshing];
            if (wself.isMyGroup) {
                if (wself.groupInfoEntity) {
                    [wself.collectionView reloadDataIfEmptyShowCueWordsView];
                }
            }else {
                [wself.collectionView reloadDataIfEmptyShowCueWordsView];
            }
        } failure:^(NSString *errorMsg, StatusCode code) {
            [wself.collectionView headerEndRefreshing];
            [wself.collectionView footerEndRefreshing];
            [SVProgressHUD showInfoWithStatus:@"获取成员信息失败"];
        }];
    }
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
