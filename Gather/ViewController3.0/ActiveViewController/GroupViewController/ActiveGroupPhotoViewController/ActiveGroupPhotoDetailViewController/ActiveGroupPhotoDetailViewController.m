//
//  ActiveGroupPhotoDetailViewController.m
//  Gather
//
//  Created by apple on 15/4/2.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveGroupPhotoDetailViewController.h"
#import "ActiveGroupPhotoDetailCollectionViewCell.h"
#import "Network+ActiveGroupPhoto.h"
#import "ActiveConfigEntity.h"
#import "ActiveGroupPhotoAddViewController.h"

@interface ActiveGroupPhotoDetailViewController ()

@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger totalNumber;

@end

@implementation ActiveGroupPhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoArray = [[NSMutableArray alloc] init];
    
    CGFloat itemWidth = ((CGRectGetWidth(self.view.bounds) - 5) / 4);
    CGFloat itemHeight = itemWidth;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView setCollectionViewLayout:layout];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ActiveGroupPhotoDetailCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    __weak typeof(self) wself = self;
    if ([ActiveMoreConfigEntity sharedMoreConfig].album_id > 0) {
        if (self.photoId == [ActiveMoreConfigEntity sharedMoreConfig].album_id) {
            
            [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithImage:image_with_name(@"btn_active_photo_add_self_photo") highlight:nil clickHandler:^(BlockBarButtonItem *item) {
                
                ActiveGroupPhotoAddViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"AddPhoto"];
                [wself.navigationController pushViewController:controller animated:YES];
            }]];
        }
    }
    [self.collectionView addHeaderWithCallback:^{
        wself.currentPage = 0;
        [wself requestInfo];
    }];
    [self.collectionView addFooterWithCallback:^{
        [wself requestInfo];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView headerBeginRefreshing];
}

- (void)requestInfo {
    if (self.currentPage != 0 && self.photoArray.count >= self.totalNumber) {
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];
        return;
    }
    
    self.currentPage += 1;
    __weak typeof(self) wself = self;
    [Network getActivePhotoDetailListWithPhotoId:self.photoId page:self.currentPage size:kSize success:^(ActiveGroupPhotoDetailListEntity *entity) {
        wself.totalNumber = entity.total_num;
        if (wself.currentPage == 1) {
            [wself.photoArray removeAllObjects];
            [wself.photoArray addObjectsFromArray:entity.photoes];
            [wself.collectionView headerEndRefreshing];
        }else {
            [wself.photoArray addObjectsFromArray:entity.photoes];
            [wself.collectionView footerEndRefreshing];
        }
        [wself.collectionView reloadDataIfEmptyShowCueWordsView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [wself.collectionView headerEndRefreshing];
        [wself.collectionView footerEndRefreshing];
        [SVProgressHUD showInfoWithStatus:@"获取相册信息失败"];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ActiveGroupPhotoDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    ActiveGroupPhotoDetailEntity *entity = self.photoArray[indexPath.item];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:thumbnail_url_with_view(entity.img_url, cell.imageView)] placeholderImage:placeholder_image];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ActiveGroupPhotoDetailCollectionViewCell *cell = (ActiveGroupPhotoDetailCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSMutableArray *urls = [NSMutableArray array];
    [self.photoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ActiveGroupPhotoDetailEntity *entity = obj;
        [urls addObject:entity.img_url];
    }];
    
    IDMPhotoBrowser *browser = [IDMPhotoBrowser controllerWithPhotoURLs:urls animatedFromView:cell.imageView];
    browser.scaleImage = cell.imageView.image;
    browser.displayArrowButton = NO;
    browser.displayActionButton = YES;
    [browser setInitialPageIndex:indexPath.item];
    [self presentViewController:browser animated:YES completion:nil];
}


@end
