//
//  HobbyViewController.m
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "HobbyViewController.h"
#import "HobbyCollectionViewCell.h"
#import "Network+UserHobby.h"

@interface HobbyViewController ()

@property (nonatomic, strong) UserHobbyEntity *hobbyEntity;
@property (nonatomic, strong) NSMutableArray *selectedHobbys;

@end

@implementation HobbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getHobbys];
}

- (void)getHobbys {
    
    __weak typeof(self) wself = self;
    [Network getUserHobbyWithPage:1 size:kSize uccess:^(BaseEntity *entity) {
        wself.hobbyEntity = (UserHobbyEntity *)entity;
        [wself.collectionView reloadData];
    } failure:^(NSString *errorMsg, StatusCode code) {
        alert(nil, @"爱好信息拉取失败");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hobbyEntity.tags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HobbyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UserHobby *hobby = self.hobbyEntity.tags[indexPath.row];
    
    [cell setTitle:hobby.name];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.selectedHobbys) {
        self.selectedHobbys = [NSMutableArray array];
    }
    //[self.selectedHobbys addObject:self.hobbys[indexPath.item]];
}

#pragma mark <UICollectionViewDelegate>

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
