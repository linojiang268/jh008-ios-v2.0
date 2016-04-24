//
//  StarClassifyViewController.m
//  Gather
//
//  Created by apple on 15/1/21.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "StarClassifyViewController.h"
#import "TagItemCell.h"
#import "Network+CityList.h"
#import "Network+Tag.h"

@interface StarClassifyViewController ()

@property (nonatomic,strong) NSArray *sexArray;
@property (nonatomic,strong) NSMutableArray *categoryTagList;
@property (nonatomic,strong) NSMutableArray *individualityTagArray;

@property (nonatomic,strong) NSMutableDictionary *classifyInfoDict;
@property (nonatomic,strong) NSMutableDictionary *selectedIndexPathDict;

@end

@implementation StarClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sexArray = @[@"男", @"女"];
    self.categoryTagList = [[NSMutableArray alloc] init];
    self.individualityTagArray = [[NSMutableArray alloc] init];
    self.classifyInfoDict = [[NSMutableDictionary alloc] init];
    self.selectedIndexPathDict = [[NSMutableDictionary alloc] init];
    
    __weak typeof(self) wself = self;
    [self.navigationItem addLeftItem:[[BlockBarButtonItem alloc] initWithImage:image_with_name(@"btn_back_yellow") highlight:nil clickHandler:^(BlockBarButtonItem *item){
        [wself.navigationController popViewControllerAnimated:YES];
    }]];
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"确认" clickHandler:^(BlockBarButtonItem *item) {
        
        if ([[wself.classifyInfoDict allKeys] count] > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kSTAR_CLASSIFY_SEARCH_NOTIFICATION_NAME object:wself.classifyInfoDict];
        }
        [wself.navigationController popViewControllerAnimated:YES];
    }]];
    
    [self getCategoryTagListInfo];
    [self getIndividualityTagListInfo];
}

- (void)getCategoryTagListInfo {
    
    if ([Common getCategoryList].tags.count > 0) {
        [self.categoryTagList addObjectsFromArray:[Common getCategoryList].tags];
        [self.collectionView reloadData];
    }else {
        [SVProgressHUD showInfoWithStatus:@"正在获取标签"];
       
        __weak typeof(self) wself = self;
        [Network getTagListWithType:TagTypeCategory page:1 size:kSize success:^(TagListEntity *entity) {
            TagListEntity *tagList = entity;
            [wself.categoryTagList addObjectsFromArray:tagList.tags];
            [wself.collectionView reloadData];
            
            if (wself.individualityTagArray.count > 0) {
                DISMISS_HUD;
            }
        } failure:^(NSString *errorMsg, StatusCode code) {
            
            [SVProgressHUD showErrorWithStatus:@"标签获取失败"];
            [wself.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)getIndividualityTagListInfo {
    if ([Common getIndividualityTagList].tags.count > 0) {
        [self.individualityTagArray addObjectsFromArray:[Common getIndividualityTagList].tags];
        [self.collectionView reloadData];
    }else {
        [SVProgressHUD showInfoWithStatus:@"正在获取标签"];
        __weak typeof(self) wself = self;
        [Network getTagListWithType:TagTypeIndividuality page:1 size:kSize success:^(TagListEntity *entity) {
            TagListEntity *tagList = entity;
            [wself.individualityTagArray addObjectsFromArray:tagList.tags];
            [wself.collectionView reloadData];
            
            if (wself.categoryTagList.count > 0) {
                DISMISS_HUD;
            }
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"标签获取失败"];
            [wself.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    NSUInteger section = 1;
    if (self.categoryTagList.count > 0) {
        section += 1;
    }
    if (self.individualityTagArray.count > 0) {
        section += 1;
    }
    
    return section;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            if (self.categoryTagList.count > 0) {
                return self.categoryTagList.count;
            }else {
                return self.sexArray.count;
            }
            break;
        case 1:
            if (self.categoryTagList.count > 0) {
                return self.sexArray.count;
            }else {
                return self.individualityTagArray.count;
            }
            break;
        case 2:
            return self.individualityTagArray.count;
            break;
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TagItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    __weak typeof(self) wself = self;
    if (indexPath.section == 0 && self.categoryTagList.count > 0) {
        TagEntity *item = self.categoryTagList[indexPath.item];
        [cell setTitle:item.name];
        [cell setTag:item.id];
        [cell setSelectedHander:^BOOL(NSUInteger tag) {
            
            NSIndexPath *deselectCellIndexPath = wself.selectedIndexPathDict[@"active_tag"];
            if (deselectCellIndexPath) {
                TagItemCell *deselectCell = (TagItemCell *)[wself.collectionView cellForItemAtIndexPath:deselectCellIndexPath];
                [deselectCell setItemSelected:NO];
            }
            [wself.classifyInfoDict setObject:@(item.id) forKey:@"active_tag"];
            [wself.selectedIndexPathDict setObject:indexPath forKey:@"active_tag"];
            
            return YES;
        } deselectedHandler:^BOOL(NSUInteger tag) {
            return NO;
        }];
        
        return cell;
    }
    
    if ((indexPath.section == 0 && self.categoryTagList.count == 0) || (indexPath.section == 1 && self.categoryTagList.count > 0)) {
        [cell setTitle:self.sexArray[indexPath.item]];
        [cell setSelectedHander:^BOOL(NSUInteger tag) {
            
            NSIndexPath *deselectCellIndexPath = wself.selectedIndexPathDict[@"sex_tag"];
            if (deselectCellIndexPath) {
                TagItemCell *deselectCell = (TagItemCell *)[wself.collectionView cellForItemAtIndexPath:deselectCellIndexPath];
                [deselectCell setItemSelected:NO];
            }
            [wself.classifyInfoDict setObject:@((indexPath.item + 1)) forKey:@"sex_tag"];
            [wself.selectedIndexPathDict setObject:indexPath forKey:@"sex_tag"];
            
            return YES;
        } deselectedHandler:^BOOL(NSUInteger tag) {
            return NO;
        }];
        
        return cell;
    }
    
    if ((indexPath.section == 1 && self.categoryTagList.count == 0) || (indexPath.section == 2 && self.categoryTagList.count > 0)) {
        TagEntity *item = self.individualityTagArray[indexPath.item];
        [cell setTitle:item.name];
        [cell setTag:item.id];
        [cell setSelectedHander:^BOOL(NSUInteger cityId) {
            
            NSIndexPath *deselectCellIndexPath = wself.selectedIndexPathDict[@"individuality_tag"];
            if (deselectCellIndexPath) {
                TagItemCell *deselectCell = (TagItemCell *)[wself.collectionView cellForItemAtIndexPath:deselectCellIndexPath];
                [deselectCell setItemSelected:NO];
            }
            [wself.classifyInfoDict setObject:@(item.id) forKey:@"individuality_tag"];
            [wself.selectedIndexPathDict setObject:indexPath forKey:@"individuality_tag"];
            
            return YES;
        } deselectedHandler:^BOOL(NSUInteger cityId) {
            
            return NO;
        }];
        
        return cell;
    }

    
    return nil;
}

@end
