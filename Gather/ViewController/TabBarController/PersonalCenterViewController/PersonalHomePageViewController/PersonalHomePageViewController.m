//
//  PersonalHomePageViewController.m
//  Gather
//
//  Created by apple on 15/1/4.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "PersonalHomePageViewController.h"
#import "PersonalHomePageHeaderView.h"
#import "PersonalHomePagePhotoTableViewCell.h"
#import "PersonalHomePageSubTitleTableViewCell.h"
#import "Network+PersonalHomePage.h"
#import "FriendListViewController.h"
#import "PhotoCellController.h"
#import "ChatViewController.h"
#import "PersonalDynamicViewController.h"
#import "InterviewController.h"
#import "Network+UserInfo.h"
#import "MyActiveViewController.h"
#import "PhotoDataModel.h"
#import "IDMPhotoBrowser.h"

@interface PersonalHomePageViewController ()<IDMPhotoBrowserDelegate>

@property (nonatomic, strong) PersonalHomePageHeaderView *tableViewHeaderView;
@property (nonatomic, strong) PhotoCellController *photoCellController;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) BOOL hasInterview;
@property (nonatomic, strong) NewsEntity *interviewInfo;

@property (nonatomic, strong) PhotoDataModel *photoModel;
@property (nonatomic, strong) IDMPhotoBrowser *photoBrowser;

@end

@implementation PersonalHomePageViewController

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)index {
    if ((index + 1) >= ((self.photoModel.photos.count / 3) * 2) && self.photoModel.totalNumber < self.photoModel.photos.count) {
        [self.photoModel loadMorePhoto];
    }
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index {
    [self.photoCellController.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (NSArray *)urls {
    NSMutableArray *urls = [NSMutableArray array];
    [self.photoModel.photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PhotoEntity *entity = obj;
        [urls addObject:entity.img_url];
    }];
    return urls;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shouldTranslucentNavigationBar = YES;
    _navigationBarBackButtonStyle = NavigationBarBackButtonStyleWhite;
    _navigationBarBackgroundStyle = NavigationBarBackgroundStyleTranslucence;

    __weak typeof(self) wself = self;
    self.photoModel = [[PhotoDataModel alloc] init];
    self.photoModel.userId = self.userId;
    [self.photoModel receiveDataHandler:^(NSArray *photos) {
        [wself.photoCellController setPhotos:(NSMutableArray *)photos];
        if (wself.photoBrowser) {
            [wself.photoBrowser setPhotoURLs:[wself urls]];
            [wself.photoBrowser reloadData];
        }
    }];
    [self.photoModel requestDataErrorHandler:^{
        [SVProgressHUD showErrorWithStatus:@"相册数据加载失败"];
    }];
    [self.photoModel getPhotoWall];
    
    self.photoCellController = [[UIStoryboard photoCellControllerStoryboard] instantiateViewControllerWithIdentifier:@"PhotoCellController"];
    [self.photoCellController setLoadMoreHandler:^{
        [wself.photoModel loadMorePhoto];
    }];
    [self.photoCellController setDidSelectedHandler:^(NSIndexPath *currentIndexPath) {
        IDMPhotoBrowser *browser = [IDMPhotoBrowser controllerWithPhotoURLs:[wself urls]];
        browser.delegate = wself;
        browser.totalNumber = wself.photoModel.totalNumber;
        [browser setInitialPageIndex:currentIndexPath.item];
        wself.photoBrowser = browser;
        [wself presentViewController:browser animated:YES completion:nil];
    }];
    
    UIBarButtonItem *leftSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *rightsSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *action = [[BlockBarButtonItem alloc]initWithTitle:@"私信" clickHandler:^(BlockBarButtonItem *item) {
        
        verify_is_login;
        
        ChatViewController *controller = [[UIStoryboard messageStoryboard] instantiateViewControllerWithIdentifier:@"Chat"];
        controller.contactId = wself.userId;
        controller.isShield = wself.userInfo.is_shield;
        controller.nickName = wself.nickName;
        controller.headImageUrl = wself.headImageUrl;
        controller.baidu_user_id = wself.userInfo.baidu_user_id;
        controller.baidu_channel_id = wself.userInfo.baidu_channel_id;
        controller.last_login_platform = wself.userInfo.last_login_platform;
        [wself.navigationController pushViewController:controller animated:YES];
    }];
    self.toolbarItems = @[leftSpace,action,rightsSpace];
    
    [self.navigationItem addLeftItem:[[BlockBarButtonItem alloc] initWithImage:image_with_name(@"btn_back_white") highlight:nil clickHandler:^(BlockBarButtonItem *item){
        [wself dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    self.tableView.estimatedRowHeight = 72;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableViewHeaderView = [[PersonalHomePageHeaderView alloc] init];
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableViewHeaderView setFocusOrFansClickHandler:^(FriendType friendType) {
        
        if (wself.userId != [Common getCurrentUserId]) {
            FriendListViewController *controller = [[UIStoryboard personalCenterStoryboard] instantiateViewControllerWithIdentifier:@"FriendList"];
            controller.userId = wself.userId;
            controller.friendType = FriendTypeMyFocus;
            [wself.navigationController pushViewController:controller animated:YES];
        }
        
    } interviewClickHandler:^{
        if (wself.userId != [Common getCurrentUserId]) {
            InterviewController *controller = [[UIStoryboard personalCenterStoryboard] instantiateViewControllerWithIdentifier:@"interview"];
            controller.interviewInfo = wself.interviewInfo;
            [wself.navigationController pushViewController:controller animated:YES];
        }
    } dynamicClickHandler:^{
        if (wself.userId != [Common getCurrentUserId]) {
            PersonalDynamicViewController *controller = [[UIStoryboard dynamicStoryboard] instantiateViewControllerWithIdentifier:@"personalDynamic"];
            controller.userId = wself.userId;
            [wself.navigationController pushViewController:controller animated:YES];
        }
    } activeClickHandler:^{
        if (wself.userId != [Common getCurrentUserId]) {
            MyActiveViewController *controller = [[UIStoryboard personalCenterStoryboard] instantiateViewControllerWithIdentifier:@"MyActive"];
            controller.userId = wself.userId;
            [wself.navigationController pushViewController:controller animated:YES];
        }
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PersonalHomePagePhotoTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"PhotoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PersonalHomePageSubTitleTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"SubTitleCell"];
    
    [self getHomePageInfo];
}

- (void)getHomePageInfo {
    
    __weak typeof(self) wself = self;
    [Network getInterviewInfoWithUserId:self.userId success:^(NewsListEntity *entity) {
        
        if (entity.news.count > 0) {
            [wself setHasInterview:YES];
            [wself setInterviewInfo:[entity.news firstObject]];
            [wself.tableViewHeaderView setIsStar:(self.userInfo.is_vip && self.hasInterview)];
            
            /// 刷新cell 动态等按钮在header 不需要刷新
            [wself.tableView reloadDataIfEmptyShowCueWordsView];
        }
        
    } failure:^(NSString *errorMsg, StatusCode code) {
        
    }];
    
    if (self.userId > 0 && !self.userInfo) {
        SHOW_LOAD_HUD;
    }
    [Network getPersonalHomePageInfoWithUserId:self.userId cityId:[Common getCurrentCityId] success:^(PersonalHomePageEntity *entity) {
        wself.userInfo = entity;
        [wself refreshView];
        DISMISS_HUD;
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"获取失败"];
    }];
}

- (void)refreshView {
    if (self.userInfo) {
        [self.tableViewHeaderView setHeadImageWithStringURL:self.userInfo.head_img_url];
        /// 2.2 版本隐藏达人
        //[self.tableViewHeaderView setIsStar:(self.userInfo.is_vip && self.hasInterview)];
        [self.tableViewHeaderView setIsStar:0];
        [self.tableViewHeaderView setNickname:self.userInfo.nick_name];
        [self.tableViewHeaderView setSexWithIntSex:self.userInfo.sex];
        [self.tableViewHeaderView setFocusNumber:self.userInfo.focus_num];
        [self.tableViewHeaderView setFansNumber:self.userInfo.fans_num];
        
        [self.tableView reloadDataIfEmptyShowCueWordsView];
        
        if (self.userInfo && self.userInfo.id != [Common getSelfUserInfo].id) {
            UIImage *image = image_with_name(@"btn_personal_home_page_focus");
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(22, 22, 22, 22)];
            
            self.button = [UIButton buttonWithType:UIButtonTypeSystem];
            if (self.isFocus) {
                [self.button setBounds:CGRectMake(0, 0, 85, image.size.height)];
            }else {
                [self.button setBounds:CGRectMake(0, 0, 63, image.size.height)];
            }
            [self.button setTitle:@"关注" forState:UIControlStateNormal];
            [self.button setTitleColor:color_white forState:UIControlStateNormal];
            [self.button setTitleColor:color_white forState:UIControlStateSelected];
            [self.button setTintColor:color_clear];
            [self.button setTitle:@"取消关注" forState:UIControlStateSelected];
            [self.button setBackgroundImage:image forState:UIControlStateNormal];
            [self.button addTarget:self action:@selector(focusButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [self.button setSelected:self.isFocus];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.button];
            self.navigationItem.rightBarButtonItem = item;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshView];
    SET_STATUSBAR_STYLE(UIStatusBarStyleLightContent);
    
    if (self.userId == [Common getCurrentUserId]) {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }else{
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
}

- (void)focusButtonClick {
    
    verify_is_login;
    
    if ((self.userId != 0 && self.userId > 0)) {
        __weak typeof(self) wself = self;
        if (wself.isFocus == 0) {
            SHOW_LOAD_HUD;
            [Network addFocusWithUserId:self.userId success:^(id response) {
                wself.isFocus = 1;
                wself.button.selected = YES;
                [self.button setBounds:CGRectMake(0, 0, 85, wself.button.frame.size.height)];
                SHOW_SUCCESS_HUD;
            } failure:^(NSString *errorMsg, StatusCode code) {
                SHOW_ERROR_HUD;
            }];
        }else if (wself.isFocus == 1) {
            SHOW_LOAD_HUD;
            [Network cancelFocusWithUserId:self.userId success:^(id response) {
                wself.isFocus = 0;
                wself.button.selected = NO;
                [self.button setBounds:CGRectMake(0, 0, 63, wself.button.frame.size.height)];
                SHOW_SUCCESS_HUD;
            } failure:^(NSString *errorMsg, StatusCode code) {
                SHOW_ERROR_HUD;
            }];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
    SET_STATUSBAR_STYLE(UIStatusBarStyleDefault);
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (DYNAMIC_MODULE_IS_SHOW) {
        if (self.userInfo.is_vip == 1 && self.hasInterview) {
            return 5;
        }
        
        return 4;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.photoModel.photos.count > 0) {
            return 2;
        }
        return 1;
    }
    return 1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0 && self.photoModel.photos.count > 0) {
                PersonalHomePagePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self.photoCellController.view setFrame:cell.bounds];
                [cell.contentView addSubview:self.photoCellController.view];
                
                return cell;
            }else {
                PersonalHomePageSubTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubTitleCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setTitle:@"爱好"];
                [cell setSubTitle:string(self.userInfo.hobby)];
                
                return cell;
            }
            
        }
            break;
        case 1:
        {
            PersonalHomePageSubTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubTitleCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTitle:@"个性签名"];
            [cell setSubTitle:string(self.userInfo.intro)];
            
            return cell;
        }
            break;
        case 2:
        {
            if (!DYNAMIC_MODULE_IS_SHOW) {
                goto labelActive;
            }else {
                PersonalHomePageSubTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubTitleCell"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setTitle:@"专访"];
                [cell hideSubTitle];
                
                return cell;
            }
        }
            break;
        case 3:
        {
            PersonalHomePageSubTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubTitleCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell setTitle:@"动态"];
            [cell hideSubTitle];
            
            return cell;
        }
            break;
        labelActive: case 4:
        {
            PersonalHomePageSubTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubTitleCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell setTitle:@"活动"];
            [cell hideSubTitle];
            
            return cell;
        }
        
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 2:
        {
            if (DYNAMIC_MODULE_IS_SHOW) {
                if (self.userId != [Common getCurrentUserId]) {
                    InterviewController *controller = [[UIStoryboard personalCenterStoryboard] instantiateViewControllerWithIdentifier:@"interview"];
                    controller.interviewInfo = self.interviewInfo;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }else {
                goto labelMyActive;
            }
        }
            break;
        case 3:
        {
            if (self.userId != [Common getCurrentUserId]) {
                PersonalDynamicViewController *controller = [[UIStoryboard dynamicStoryboard] instantiateViewControllerWithIdentifier:@"personalDynamic"];
                controller.userId = self.userId;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
        labelMyActive: case 4:
        {
            if (self.userId != [Common getCurrentUserId]) {
                MyActiveViewController *controller = [[UIStoryboard personalCenterStoryboard] instantiateViewControllerWithIdentifier:@"MyActive"];
                controller.userId = self.userId;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableViewHeaderView.parallaxHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
}

@end
