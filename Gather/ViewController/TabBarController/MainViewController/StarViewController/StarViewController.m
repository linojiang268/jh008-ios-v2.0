//
//  StarViewController.m
//  Gather
//
//  Created by apple on 15/1/20.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "StarViewController.h"
#import "StarCollectionViewCell.h"
#import "MJRefresh.h"
#import "Network+Star.h"
#import "PersonalHomePageViewController.h"
#import "StarSearchViewController.h"
#import "StarClassifyViewController.h"

@interface StarViewController ()

@property (nonatomic, strong) NSMutableArray *topStarArray;
@property (nonatomic, strong) NSMutableArray *starArray;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger totalNumber;

@property (nonatomic, assign) NSUInteger tagId;
@property (nonatomic, assign) Sex sex;
@property (nonatomic, assign) NSUInteger userTagId;
@property (nonatomic, strong) NSString *keyWords;

@property (nonatomic, strong) id classifyNoti;

@end

@implementation StarViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.classifyNoti];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage = 0;
    self.starArray = [[NSMutableArray alloc] init];
    self.topStarArray = [[NSMutableArray alloc] init];
    
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
    self.classifyNoti = [[NSNotificationCenter defaultCenter] addObserverForName:kSTAR_CLASSIFY_SEARCH_NOTIFICATION_NAME object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        NSDictionary *dict = note.object;
        wself.tagId = [dict[@"active_tag"] intValue];
        wself.sex = [dict[@"sex_tag"] intValue];
        wself.userTagId = [dict[@"individuality_tag"] intValue];
        [wself.collectionView headerBeginRefreshing];
    }];
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"分类" clickHandler:^(BlockBarButtonItem *item) {
        StarClassifyViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"StarClassify"];
        [wself.navigationController pushViewController:controller animated:YES];
    }]];
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"搜索" clickHandler:^(BlockBarButtonItem *item) {
        StarSearchViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"StarSearch"];
        [controller searchDoneHanlder:^(NSString *keywords) {
            wself.keyWords = keywords;
            [wself.collectionView headerBeginRefreshing];
        }];
        [wself.navigationController pushViewController:controller animated:YES];
    }]];
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
    
    if (self.currentPage != 0 && self.starArray.count >= self.totalNumber) {
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];
        return;
    }
    
    self.currentPage += 1;
    __weak typeof(self) wself = self;
    [Network getStarInfoListWithCityId:[Common getCurrentCityId] tagId:self.tagId sex:self.sex userTagId:self.userTagId keyWords:self.keyWords page:self.currentPage size:kSize success:^(StarListEntity *entity) {
        
        wself.totalNumber = entity.total_num;
        if (wself.currentPage == 1) {
            [wself.topStarArray removeAllObjects];
            [wself.starArray removeAllObjects];
            [wself.topStarArray addObjectsFromArray:entity.queue];
            [wself.starArray addObjectsFromArray:entity.queue];
        }
        NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:entity.users];
        [temp removeObjectsInArray:wself.topStarArray];
        
        [wself.starArray addObjectsFromArray:entity.users];
        [wself.collectionView headerEndRefreshing];
        [wself.collectionView footerEndRefreshing];
        [wself.collectionView reloadDataIfEmptyShowCueWordsView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [wself.collectionView headerEndRefreshing];
        [wself.collectionView footerEndRefreshing];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.starArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    SimpleUserInfoEntity *entity = self.starArray[indexPath.item];

    [cell.nicknameLabel setText:entity.nick_name];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:thumbnail_url(entity.head_img_url, CGRectGetWidth(cell.imageView.bounds), CGRectGetHeight(cell.imageView.bounds))] placeholderImage:placeholder_image];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SimpleUserInfoEntity *entity = self.starArray[indexPath.item];
    
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
