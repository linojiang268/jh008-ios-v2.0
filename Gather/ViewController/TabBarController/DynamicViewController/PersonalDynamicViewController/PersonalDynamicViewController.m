//
//  PersonalDynamicViewController.m
//  Gather
//
//  Created by apple on 15/1/15.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "PersonalDynamicViewController.h"
#import "PersonalDynamicTableViewCell.h"
#import "CommentViewController.h"
#import "IDMPhotoBrowser.h"
#import "Network+Dynamic.h"
#import "PublishDynamicViewController.h"
#import "DynamicCacheEntity.h"
#import "PublishDynamic.h"

@interface PersonalDynamicViewController ()

@property (nonatomic, strong) NSMutableArray *dynamicList;
@property (nonatomic, strong) NSMutableArray *publishList;

@property (nonatomic, assign) NSUInteger placeholderNumber;

@property (nonatomic, strong) id publishNoti;
@property (nonatomic, strong) id publishSuccessNoti;
@property (nonatomic, strong) id publishFailedNoti;
@property (nonatomic, strong) id commentDeleteNoti;

@end

@implementation PersonalDynamicViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.publishNoti];
    [[NSNotificationCenter defaultCenter] removeObserver:self.publishSuccessNoti];
    [[NSNotificationCenter defaultCenter] removeObserver:self.publishFailedNoti];
    [[NSNotificationCenter defaultCenter] removeObserver:self.commentDeleteNoti];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.userId == [Common getCurrentUserId]) {
        [self getLocalData];
        self.placeholderNumber = 1;
    }else {
        self.placeholderNumber = 0;
    }
    [self.tableView headerBeginRefreshing];
}

- (void)getLocalData {
    NSArray *cacheData = [DynamicCacheEntity MR_findAllSortedBy:@"create_time" ascending:NO];
    if (cacheData && cacheData.count > 0) {
        if (self.publishList) {
            [self.publishList setArray:cacheData];
        }else {
            self.publishList = [[NSMutableArray alloc] initWithArray:cacheData];
        }
        [self.tableView reloadDataIfEmptyShowCueWordsView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.placeholderNumber = 0;
    self.publishList = [[NSMutableArray alloc] init];
    self.dynamicList = [[NSMutableArray alloc] init];
    
    [self.tableView setEstimatedRowHeight:100];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PersonalDynamicTableViewCell class]) bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.tableView.backgroundColor = color_white;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self) wself = self;
    self.publishNoti = [[NSNotificationCenter defaultCenter] addObserverForName:kPUBLISH_NOTIFICATION_NAME object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [wself getLocalData];
    }];
    self.publishSuccessNoti = [[NSNotificationCenter defaultCenter] addObserverForName:kPUBLISH_SUCCESS_NOTIFICATION_NAME object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        DynamicCacheEntity *entity = note.object;
        [wself.publishList removeObject:entity];
        [wself.tableView headerBeginRefreshing];
    }];
    self.publishFailedNoti = [[NSNotificationCenter defaultCenter] addObserverForName:kPUBLISH_FAILED_NOTIFICATION_NAME object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        DynamicCacheEntity *notiEntity = note.object;
        [wself.publishList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            DynamicCacheEntity *entity = obj;
            if ([entity.create_time isEqualToString:notiEntity.create_time]) {
                entity.status = 2;
                [wself.tableView reloadDataIfEmptyShowCueWordsView];
                return;
            }
        }];
    }];
    self.commentDeleteNoti = [[NSNotificationCenter defaultCenter] addObserverForName:kCOMMENT_DELETE_NOTIFICATION_NAME object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [wself.dynamicList removeObject:note.object];
        [wself.tableView reloadDataIfEmptyShowCueWordsView];
    }];
    
    [self.tableView addHeaderWithCallback:^{
        if (wself.tableView.footerRefreshing) {
            return;
        }
        wself.currentPage = 0;
        [wself requestInfo];
    }];
    [self.tableView addFooterWithCallback:^{
        if (wself.tableView.headerRefreshing) {
            return;
        }
        [wself requestInfo];
    }];
}

- (void)requestInfo {
    
    if (self.tableView.footerRefreshing && self.currentPage != 0 && self.dynamicList.count >= self.totalNumber) {
        [self.tableView footerEndRefreshing];
        return;
    }
    
    self.currentPage += 1;
    
    __weak typeof(self) wself = self;
    [Network getPersonalDynamicWithUserId:self.userId page:self.currentPage size:kSize success:^(DynamicListEntity *entity) {
        wself.totalNumber = entity.total_num;
        
        if (wself.currentPage == 1) {
            [wself.dynamicList setArray:entity.dynamics];
            [wself.tableView headerEndRefreshing];
        }else {
            [wself.dynamicList addObjectsFromArray:entity.dynamics];
            [wself.tableView footerEndRefreshing];
        }
        [wself.tableView reloadDataIfEmptyShowCueWordsView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dynamicList.count + self.placeholderNumber + self.publishList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 && self.userId == [Common getCurrentUserId]) {
        return [tableView dequeueReusableCellWithIdentifier:@"TodayCell" forIndexPath:indexPath];
    }
    
    PersonalDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BOOL isPublish = self.publishList.count > 0 && indexPath.row < self.publishList.count + self.placeholderNumber;
    
    DynamicEntity *currentEntity = nil;
    DynamicCacheEntity *cacheEntity = nil;
    if (isPublish) {
        cacheEntity = self.publishList[indexPath.row - self.placeholderNumber];
        
        if (indexPath.row == self.placeholderNumber) {
            [cell setLocalCurrentValue:cacheEntity previousTime:nil];
        }else if(indexPath.row >= (self.placeholderNumber + 1)) {
            DynamicCacheEntity *previousEntity = self.publishList[indexPath.row - (self.placeholderNumber + 1)];
            [cell setLocalCurrentValue:cacheEntity previousTime:previousEntity.create_time];
        }
    }else {
        
        currentEntity = self.dynamicList[indexPath.row - self.placeholderNumber - self.publishList.count];
        
        if (indexPath.row == self.placeholderNumber) {
            [cell setCurrentValue:currentEntity previousTime:nil];
        }else if(indexPath.row >= (self.placeholderNumber + 1)) {
            
            NSString *time = @"";
            if (indexPath.row == (self.publishList.count + self.placeholderNumber)) {
                DynamicCacheEntity *previousEntity = self.publishList[indexPath.row - self.placeholderNumber - self.publishList.count];
                time = previousEntity.create_time;
            }else {
                DynamicEntity *previousEntity = self.dynamicList[indexPath.row - (self.placeholderNumber + 1) - self.publishList.count];
                time = previousEntity.create_time;
            }
            
            [cell setCurrentValue:currentEntity previousTime:time];
        }
    }
    __weak typeof(self) wself = self;
    [cell deleteHandler:^{
        
        verify_is_login;
        
        if (isPublish) {
            
            int row = [wself.publishList indexOfObject:cacheEntity] + self.placeholderNumber;
            [cacheEntity MR_deleteEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            [wself.publishList removeObject:cacheEntity];
            [wself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
            [[NSNotificationCenter defaultCenter] postNotificationName:kPUBLISH_CANCEL_NOTIFICATION_NAME object:cacheEntity.create_time];
        }else  {
            [Network deleteDynamicWithDynamicId:currentEntity.id success:^(id response) {
                
                int row = [wself.dynamicList indexOfObject:currentEntity] + self.placeholderNumber;
                [wself.dynamicList removeObject:currentEntity];
                [wself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
            } failure:^(NSString *errorMsg, StatusCode code) {
                alert(nil, @"删除失败");
            }];
        }
    }];
    [cell commentHandler:^{
        
        verify_is_login;
        
        if (!isPublish) {
            CommentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Comment"];
            controller.dynamicInfo = currentEntity;
            [wself.navigationController pushViewController:controller animated:YES];
        }
    }];
    [cell didTapImageViewHandler:^(id sender, UIImage *scaleImage, NSUInteger index) {
        
        IDMPhotoBrowser *browser = nil;
        if (isPublish) {
            NSArray *imgNames = [cacheEntity.imgNames componentsSeparatedByString:@"|"];
            NSMutableArray *imgs = [NSMutableArray array];
            [imgNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [imgs addObject:PUBLISH_IMAGE_WITH_NAME(obj)];
            }];
            browser = [IDMPhotoBrowser controllerWithPhotos:[IDMPhoto photosWithImages:imgs] animatedFromView:sender];
        }else {
            NSMutableArray *urls = [NSMutableArray array];
            [currentEntity.imgs.imgs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Img *img = obj;
                [urls addObject:img.img_url];
            }];
            browser = [IDMPhotoBrowser controllerWithPhotoURLs:urls animatedFromView:sender];
        }
        if (browser) {
            browser.scaleImage = scaleImage;
            [browser setInitialPageIndex:index];
            [wself presentViewController:browser animated:YES completion:nil];
        }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dynamicList.count > 0 && indexPath.row > 0) {
        DynamicEntity *entity = self.dynamicList[indexPath.row - self.placeholderNumber];
        CommentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Comment"];
        controller.dynamicInfo = entity;
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        
        if (indexPath.row == 0 && self.userId == [Common getCurrentUserId]) {
            
            PublishDynamicViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"publishDynamic"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

@end
