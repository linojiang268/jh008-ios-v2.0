//
//  DynamicViewController.m
//  Gather
//
//  Created by Matt Jones on 14-12-26.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "DynamicViewController.h"
#import "DynamicTableViewCell.h"
#import "Network+Dynamic.h"
#import "CommentViewController.h"
#import "PersonalDynamicViewController.h"
#import "PublishDynamicViewController.h"
#import "IDMPhotoBrowser.h"
#import "DynamicCacheEntity.h"
#import "PublishDynamic.h"
#import "PersonalHomePageViewController.h"

@interface DynamicViewController ()

@property (nonatomic, strong) NSMutableArray *publishList;
@property (nonatomic, strong) NSMutableArray *dynamicList;

@property (nonatomic, strong) id publishNoti;
@property (nonatomic, strong) id publishSuccessNoti;
@property (nonatomic, strong) id publishFailedNoti;
@property (nonatomic, strong) id commentDeleteNoti;

@end

@implementation DynamicViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.publishNoti];
    [[NSNotificationCenter defaultCenter] removeObserver:self.publishSuccessNoti];
    [[NSNotificationCenter defaultCenter] removeObserver:self.publishFailedNoti];
    [[NSNotificationCenter defaultCenter] removeObserver:self.commentDeleteNoti];
}

- (void)tapGesture {
    
    verify_is_login;
    
    PersonalDynamicViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"personalDynamic"];
    controller.userId = [Common getCurrentUserId];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)longGesture:(UILongPressGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        verify_is_login;
        
        PublishDynamicViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"publishDynamic"];
        [self.navigationController pushViewController:controller animated:YES];
    }
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getLocalData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.publishList = [[NSMutableArray alloc] init];
    self.dynamicList = [[NSMutableArray alloc] init];
    
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self.tableView setEstimatedRowHeight:300];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DynamicTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"DynamicCell"];
    
    __weak typeof(self) wself = self;
    self.publishNoti = [[NSNotificationCenter defaultCenter] addObserverForName:kPUBLISH_NOTIFICATION_NAME object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        NSDictionary *dict = note.object;
        
        DynamicCacheEntity *entity = [DynamicCacheEntity MR_createEntity];
        entity.content = dict[@"content"];
        entity.imgNames = [dict[@"imgNames"] componentsJoinedByString:@"|"];
        entity.create_time = dict[@"create_time"];
        entity.status = 1;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

        [wself.publishList insertObject:entity atIndex:0];
        [wself.tableView reloadDataIfEmptyShowCueWordsView];
        
        [[[PublishDynamic alloc] initWithDynamicEntity:entity] publish];
    }];
    self.publishSuccessNoti = [[NSNotificationCenter defaultCenter] addObserverForName:kPUBLISH_SUCCESS_NOTIFICATION_NAME object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        DynamicCacheEntity *entity = note.object;
        [wself.publishList removeObject:entity];
        [entity MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
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

    
    UIImage *image = image_with_name(@"btn_dynamic_camera_d");
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)]];
    [imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)]];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.rightBarButtonItem = rightitem;
    
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
    if (NETWORK_REACHABLE) {
        [self.tableView headerBeginRefreshing];
    }else {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }
}

- (void)requestInfo {
    
    if (self.tableView.footerRefreshing && self.currentPage != 0 && self.dynamicList.count >= self.totalNumber) {
        [self.tableView footerEndRefreshing];
        return;
    }
    
    self.currentPage += 1;
    
    __weak typeof(self) wself = self;
    [Network getAllDynamicWithUserId:[Common getCurrentUserId] cityId:[Common getCurrentCityId] page:self.currentPage size:kSize success:^(DynamicListEntity *entity) {
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
    return self.dynamicList.count + self.publishList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak typeof(self) wself = self;
        
    BOOL isPublish = self.publishList.count > 0 && indexPath.row < self.publishList.count;
    
    DynamicEntity *entity = nil;
    DynamicCacheEntity *cacheEntity = nil;
    if (isPublish)  {
        cacheEntity = self.publishList[indexPath.row];
        [cell setPublishValue:cacheEntity];
    }else {
        entity = self.dynamicList[indexPath.row - self.publishList.count];
        [cell setValue:entity user:nil];
    }
    
    [cell republish:^{
        
        DynamicCacheEntity *e = self.publishList[indexPath.row];
        e.status = 1;
        [[[PublishDynamic alloc] initWithDynamicEntity:e] publish];
        [wself.tableView reloadDataIfEmptyShowCueWordsView];
    }];
    
    [cell deleteHandler:^{
        
        if (isPublish) {
            
            int row = [wself.publishList indexOfObject:cacheEntity];
            [cacheEntity MR_deleteEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            [wself.publishList removeObject:cacheEntity];
            [wself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
            [[NSNotificationCenter defaultCenter] postNotificationName:kPUBLISH_CANCEL_NOTIFICATION_NAME object:cacheEntity.create_time];
            
        }else {
            
            [Network deleteDynamicWithDynamicId:entity.id success:^(id response) {
                
                int row = [wself.dynamicList indexOfObject:entity];
                [wself.dynamicList removeObject:entity];
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
            controller.dynamicInfo = entity;
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
            [entity.imgs.imgs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
    [cell setHeadImageTapHandler:^{
        if (entity.author_id == [Common getCurrentUserId]) {
            PersonalDynamicViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"personalDynamic"];
            controller.userId = [Common getCurrentUserId];
            [wself.navigationController pushViewController:controller animated:YES];
        }else {
            PersonalHomePageViewController *controller = [[UIStoryboard personalCenterStoryboard] instantiateViewControllerWithIdentifier:@"PersonalHomePage"];
            controller.userId = entity.user.id;
            controller.isFocus = entity.user.is_focus;
            controller.nickName = entity.user.nick_name;
            controller.headImageUrl = entity.user.head_img_url;
            controller.userInfo = (PersonalHomePageEntity *)entity.user;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            [wself presentViewController:nav animated:YES completion:nil];
        }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    verify_is_login;
    
    if (self.publishList.count > 0 && indexPath.row < self.publishList.count) {
        return;
    }
    DynamicEntity *entity = self.dynamicList[indexPath.row];
    CommentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Comment"];
    controller.dynamicInfo = entity;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
