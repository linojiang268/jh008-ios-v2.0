//
//  PhotoBrowseViewController.m
//  Gather
//
//  Created by apple on 15/1/6.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "PhotoCellController.h"
#import "PhotoBrowseCollectionViewCell.h"
#import "PhotosEntity.h"

@interface PhotoCellController ()

@property (nonatomic, strong) void(^loadMoreHeandler)(void);
@property (nonatomic, strong) void(^didSelectedHandler)(NSIndexPath *currentIndexPath);
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;


@end

@implementation PhotoCellController

- (void)setPhotos:(NSMutableArray *)photos {
    _photos = photos;
    [self reloadData];
}

- (void)addPhotos:(NSArray *)photos {
    if (!self.photos) {
        self.photos = [[NSMutableArray alloc] init];
    }
    [self.photos addObjectsFromArray:photos];
    [self reloadData];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)setDidSelectedHandler:(void (^)(NSIndexPath *currentIndexPath))handler {
    _didSelectedHandler = handler;
}

- (void)setLoadMoreHandler:(void (^)(void))handler {
    _loadMoreHeandler = handler;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photos = [[NSMutableArray alloc] init];
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.layout.itemSize = CGSizeMake((CGRectGetWidth(self.view.bounds) - 5) / 3, 175);
    [self.collectionView setCollectionViewLayout:self.layout];
    
    self.navigationController.toolbarHidden = YES;
    
    __weak typeof(self) wself = self;
    [self.navigationItem addLeftItem:[[BlockBarButtonItem alloc] initWithImage:image_with_name(@"btn_back_yellow") highlight:nil clickHandler:^(BlockBarButtonItem *item){
        [wself dismissViewControllerAnimated:YES completion:nil];
    }]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoBrowseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    PhotoEntity *entity = self.photos[indexPath.item];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:thumbnail_url(entity.img_url, CGRectGetWidth(cell.imageView.bounds), CGRectGetHeight(cell.imageView.bounds))] placeholderImage:placeholder_image];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.contentSize.width;
    CGFloat x = scrollView.contentOffset.x + self.layout.itemSize.width;

    CGFloat loadMorePosition = width - (width / 3);

    if (x >= loadMorePosition) {
        if (self.loadMoreHeandler) {
            self.loadMoreHeandler();
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectedHandler) {
        self.didSelectedHandler(indexPath);
    }
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
