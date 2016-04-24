//
//  ActiveDetailViewController.m
//  Gather
//
//  Created by apple on 15/1/27.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveDetailViewController.h"
#import "ActiveDetailHeaderView.h"
#import "Network+Active.h"
#import "AddressTableViewCell.h"
#import "YellowTableViewCell.h"
#import "StarTableViewCell.h"
#import "PersonalHomePageViewController.h"
#import "CommentHeaderTableViewCell.h"
#import "ActiveCommentTableViewCell.h"
#import "ShareTableViewCell.h"
#import "BottomToolBarView.h"
#import "PriceTableViewCell.h"
#import "ActiveCommentViewController.h"
#import "MapViewController.h"
#import "BMKNavigation.h"
#import "ActiveApplyViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "IDMPhotoBrowser.h"
#import "RecallDetailViewController.h"
#import "ShowMaskViewController.h"

#pragma mark - 3.0
#import "Network+Group.h"
#import "Network+Graphic.h"
#import "GroupViewController.h"
#import "ActiveMapViewController.h"
#import "ActiveApplyViewController30.h"

@interface ActiveDetailViewController ()

@property (nonatomic, assign) BOOL configLoadComplete;
@property (nonatomic, assign) BOOL detailLoadComplete;
@property (nonatomic, assign) BOOL strategyLoadComplete;
@property (nonatomic, assign) BOOL recallLoadComplete;
@property (nonatomic, assign) BOOL starLoadComplete;
@property (nonatomic, assign) BOOL commentLoadComplete;
@property (nonatomic, strong) ActiveDetailHeaderView *tableViewHeaderView;

@property (nonatomic, strong) ActiveDetailEntity *activeDetailInfo;
@property (nonatomic, strong) NewsEntity *strategyInfo;
@property (nonatomic, strong) NewsEntity *recallInfo;
@property (nonatomic, strong) StarListEntity *starInfo;
@property (nonatomic, strong) ActiveCommentListEntity *commentInfo;
@property (nonatomic, assign) BOOL isShowStrategy,isShowRecall,isShowStar,isShowRoute,isShowCommentHeader,isShowComment;

@property (nonatomic, strong) BlockBarButtonItem *collectButtonView;

@property (nonatomic, strong) UIView *applyView;
@property (nonatomic, strong) UIView *applyBackgroundView;
@property (nonatomic, strong) ActiveApplyViewController *applyController;

@property (nonatomic, strong) BottomToolBarView *bottomView;

#pragma mark - 3.0
@property (nonatomic, strong) AddressParkingSpaceListEntity *addressEntity;

@end

@implementation ActiveDetailViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAPPLY_SUCCESS_NOTIFICATION_NAME object:nil];
}

- (ActiveApplyViewController *)applyController {
    if (!_applyController) {
        _applyController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActiveApply"];
        _applyController.view.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]));
    }
    return _applyController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _shouldTranslucentNavigationBar = YES;
    _navigationBarBackButtonStyle = NavigationBarBackButtonStyleWhite;
    _navigationBarBackgroundStyle = NavigationBarBackgroundStyleTranslucence;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupBottomView) name:kAPPLY_SUCCESS_NOTIFICATION_NAME object:nil];
    
    __weak typeof(self) wself = self;
    [self.navigationItem addLeftItem:[[BlockBarButtonItem alloc] initWithImage:image_with_name(@"btn_back_white") highlight:nil clickHandler:^(BlockBarButtonItem *item){
        [wself dismissViewControllerAnimated:YES completion:nil];
    }]];
    self.collectButtonView = [[BlockBarButtonItem alloc] initWithImage:image_with_name(@"btn_collect_d") highlight:image_with_name(@"btn_collect_h") clickHandler:^(BlockBarButtonItem *item) {
        [wself collect];
    }];
    [self.navigationItem addRightItem:self.collectButtonView];

    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableViewHeaderView = [[ActiveDetailHeaderView alloc] init];
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 44, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableViewHeaderView.bannerView enventHandler:^(UIImageView *imageView, NSUInteger index) {
        
        NSMutableArray *urls = [NSMutableArray array];
        [wself.activeDetailInfo.act_imgs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ActiveImageEntity *img = obj;
            [urls addObject:img.img_url];
        }];
        IDMPhotoBrowser *browser = [IDMPhotoBrowser controllerWithPhotoURLs:urls];;
        [browser setInitialPageIndex:index];
        [wself presentViewController:browser animated:YES completion:nil];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddressTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"AddressCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YellowTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"YellowCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StarTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"StarCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommentHeaderTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"CommentHeader"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ActiveCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"ActiveCommentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShareTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"ShareCell"];
}

- (void)collect {
    
    verify_is_login;
    
    __weak typeof(self) wself = self;
    SHOW_LOAD_HUD;
    if (self.activeDetailInfo.is_loved != 1) {
        
        [Network collectActiveWithId:self.activeId success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            wself.activeDetailInfo.is_loved = 1;
            wself.collectButtonView.customButtonView.selected = !self.collectButtonView.customButtonView.selected;
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showSuccessWithStatus:@"收藏失败"];
        }];
    }else {
        
        [Network cancelCollectActiveWithId:self.activeId success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            wself.activeDetailInfo.is_loved = 0;
            wself.collectButtonView.customButtonView.selected = !self.collectButtonView.customButtonView.selected;
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showSuccessWithStatus:@"取消失败"];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self.navigationController.toolbar setBackgroundColor:color_white];
    SET_STATUSBAR_STYLE(UIStatusBarStyleLightContent);
    if (!self.activeDetailInfo) {
        [self requestActiveDetail];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
    SET_STATUSBAR_STYLE(UIStatusBarStyleDefault);
}

- (void)requestActiveDetail {
    
    SHOW_LOAD_HUD;
    __weak typeof(self) wself = self;
    
#ifdef __Gather_2_0_2__
    [Network getActiveConfigWithActiveId:self.activeId success:^(ActiveConfigEntity *entity) {
        [ActiveConfigSingleton singleton].config = entity;
        [Network getActiveMoreConfigWithActiveId:wself.activeId success:^(ActiveMoreConfigEntity *entity) {
            [ActiveConfigSingleton singleton].moreConfig = entity;
//            [Network getAddressParkingSpaceListWithActiveId:self.activeId page:1 size:kActiveGroupSize success:^(AddressParkingSpaceListEntity *entity) {
//                wself.addressEntity = entity;
                [Network getActiveDetailWithId:wself.activeId success:^(ActiveDetailEntity *entity) {
                    DISMISS_HUD;
                    [wself setActiveDetailInfo:entity];
                    [wself setDetailLoadComplete:YES];
                    [wself refreshView];
                    [wself requestOtherInfo];
                } failure:^(NSString *errorMsg, StatusCode code) {
                    [SVProgressHUD showErrorWithStatus:@"加载失败"];
                    [wself dismissViewControllerAnimated:YES completion:nil];
                }];
//            } failure:^(NSString *errorMsg, StatusCode code) {
//                [SVProgressHUD showErrorWithStatus:@"加载失败"];
//                [wself dismissViewControllerAnimated:YES completion:nil];
//            }];
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            [wself dismissViewControllerAnimated:YES completion:nil];
        }];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [wself dismissViewControllerAnimated:YES completion:nil];
    }];
#else
    [Network getActiveDetailWithId:wself.activeId success:^(ActiveDetailEntity *entity) {
        DISMISS_HUD;
        [wself setActiveDetailInfo:entity];
        [wself setDetailLoadComplete:YES];
        [wself refreshView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [wself dismissViewControllerAnimated:YES completion:nil];
    }];
#endif
}

- (void)requestOtherInfo {
    __weak typeof(self) wself = self;
    [Network getNewsWithActiveId:self.activeId typeId:NewsTypeStrategy page:1 size:1 success:^(NewsListEntity *entity) {
        if (entity.news.count > 0) {
            [wself setStrategyInfo:entity.news[0]];
        }
        [wself setStrategyLoadComplete:YES];
        [wself refreshView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        
    }];
    [Network getNewsWithActiveId:self.activeId typeId:NewsTypeRecall page:1 size:1 success:^(NewsListEntity *entity) {
        if (entity.news.count > 0) {
            [wself setRecallInfo:entity.news[0]];
        }
        [wself setRecallLoadComplete:YES];
        [wself refreshView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        
    }];
    [Network getStarWithActiveId:self.activeId cityId:[Common getCurrentCityId] page:1 size:4 success:^(StarListEntity *entity) {
        if (entity.users.count > 0) {
            [wself setStarInfo:entity];
        }
        [wself setStarLoadComplete:YES];
        [wself refreshView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        
    }];
    [Network getCommentWithActiveId:self.activeId page:1 size:1 success:^(ActiveCommentListEntity *entity) {
        if (entity.comments.count > 0) {
            [wself setCommentInfo:entity];
        }
        [wself setCommentLoadComplete:YES];
        [wself refreshView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        
    }];
}

- (void)refreshView {
    
    if (self.detailLoadComplete) {
        NSMutableArray *imgURL = [[NSMutableArray alloc] init];
        for (ActiveImageEntity *img in self.activeDetailInfo.act_imgs) {
            [imgURL addObject:img.img_url];
        }
        if (self.activeDetailInfo.is_loved != 1) {
            self.collectButtonView.customButtonView.selected = NO;
        }else {
            self.collectButtonView.customButtonView.selected = YES;
        }
        
        self.tableViewHeaderView.bannerView.imageItems = imgURL;
        self.tableViewHeaderView.titleLabel.text = self.activeDetailInfo.intro;
        self.isShowStrategy = NO;
        self.isShowRecall = NO;
        self.isShowStar = NO;
        self.isShowRoute = NO;
        self.isShowCommentHeader = NO;
        self.isShowComment = NO;
        [self setupBottomView];
        [self.tableView reloadData];
    }
}

- (void)setupBottomView {
    __weak typeof(self) wself = self;
#ifdef __Gather_2_0_2__
    if ([ActiveConfigEntity sharedConfig].show_enroll <= ActiveConfigStatusNoSet) {
        self.bottomView = [[BottomToolBarView alloc] initWithStyle:ActiveBottomViewStyleOnlyShowComment];
    }else if ([ActiveMoreConfigEntity sharedMoreConfig].enroll_status > ActiveConfigStatusNoSet) {
        self.bottomView = [[BottomToolBarView alloc] initWithStyle:ActiveBottomViewStyleHideApply];
        [self.bottomView.historyButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
            verify_is_login;
            GroupViewController *controller = [[UIStoryboard activeGroupStoryboard] instantiateViewControllerWithIdentifier:@"group"];
            controller.activeId = wself.activeId;
            controller.activeDetail = wself.activeDetailInfo;
            [wself.navigationController pushViewController:controller animated:YES];
        }];
    }
#else
    if (self.activeDetailInfo.can_enroll == 0) {
        self.bottomView = [[BottomToolBarView alloc] initWithStyle:ActiveBottomViewStyleOnlyShowComment];
    }
#endif
    else {
        self.bottomView = [[BottomToolBarView alloc] initWithStyle:ActiveBottomViewStyleShowAll];
        [self.bottomView.historyButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
            verify_is_login;
            GroupViewController *controller = [[UIStoryboard activeGroupStoryboard] instantiateViewControllerWithIdentifier:@"group"];
            controller.activeId = wself.activeId;
            controller.activeDetail = wself.activeDetailInfo;
            [wself.navigationController pushViewController:controller animated:YES];
        }];
        [self.bottomView.applyButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
            [TalkingData trackEvent:@"活动报名"];
            verify_is_login;
            
#ifdef __Gather_2_0_2__
            /*if ([ActiveConfigEntity sharedConfig].show_manager != ActiveConfigStatusNone) {
                if ([ActiveMoreConfigEntity sharedMoreConfig].is_manager == 1) {
                    alert(nil, @"管理员不能报名");
                    return;
                }
            }*/
            
            ActiveMoreConfigEntity *config = [ActiveMoreConfigEntity sharedMoreConfig];
            
            if (config.enroll_limit == ActiveConfigStatusHasSet && config.enroll_num >= config.enroll_limit_num) {
                [SVProgressHUD showInfoWithStatus:@"报名人数已满"];
                return;
            }else if (config.enroll_limit == ActiveConfigStatusHasSet && config.limit_sex_num == ActiveConfigStatusHasSet) {
                if ([Common getSelfUserInfo].sex == SexMan && config.enroll_male_num >= config.limit_male_num) {
                    [SVProgressHUD showInfoWithStatus:@"男性人员已满"];
                    return;
                }
                if ([Common getSelfUserInfo].sex == SexWoman && config.enroll_female_num >= config.limit_female_num) {
                    [SVProgressHUD showInfoWithStatus:@"女性人员已满"];
                    return;
                }
            }
            ActiveApplyViewController30 *controller = [[UIStoryboard activeGroupStoryboard] instantiateViewControllerWithIdentifier:@"Apply30"];
            controller.activeId = wself.activeId;
            controller.activeInfo = wself.activeDetailInfo;
            [wself.navigationController pushViewController:controller animated:YES];
#else
            [wself.navigationController setToolbarHidden:YES animated:YES];
            ShowMaskViewController *controller = [ShowMaskViewController sharedController];
            [controller dismissComplete:^{
                [wself.navigationController setToolbarHidden:NO animated:YES];
            }];
            [controller showInWindow:wself.view.window otherView:wself.applyController.view];
            [wself.applyController.closeButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
                [controller dismiss];
            }];
            [wself.applyController.applyButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
                
                if (string_is_empty(wself.applyController.nameTextField.text)) {
                    alert(nil, @"请输入姓名");
                    return;
                }
                if (string_is_empty(wself.applyController.phoneTextField.text) || ![wself.applyController.phoneTextField.text validateMobile]) {
                    alert(nil, @"请输入正确的电话号码");
                    return;
                }
                if (string_is_empty(wself.applyController.numberTextField.text)) {
                    alert(nil, @"请输入人数");
                    return;
                }
                if (string_is_empty(wself.applyController.numberTextField.text)) {
                    alert(nil, @"人数不能少于1个人");
                    return;
                }
                
                CLLocationCoordinate2D coor = [Common getCurrentLocationCoordinate2D];
                
                SHOW_LOAD_HUD;
                [Network applyWithActiveId:wself.activeId
                                      name:wself.applyController.nameTextField.text
                                     phone:wself.applyController.phoneTextField.text
                              peopleNumber:[wself.applyController.numberTextField.text intValue]
                                       lon:coor.longitude
                                       lat:coor.latitude
                                   address:[Common getCurrentFullAddress] success:^(id response) {
                                       [SVProgressHUD showSuccessWithStatus:@"报名成功"];
                                       [wself.applyController.closeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                                   } failure:^(NSString *errorMsg, StatusCode code) {
                                       [SVProgressHUD showSuccessWithStatus:@"报名失败"];
                                   }];
            }];
#endif
        }];

    }
    [self.bottomView.commentButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
        
        verify_is_login;
        
        ActiveCommentViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"ActiveComment"];
        controller.activeId = wself.activeDetailInfo.id;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [wself presentViewController:nav animated:YES completion:nil];
    }];
    
    UIBarButtonItem *leftSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *action =[[UIBarButtonItem alloc]initWithCustomView:self.bottomView];
    UIBarButtonItem *rightsSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    self.toolbarItems = @[leftSpace,action,rightsSpace];
    self.navigationController.toolbarHidden = NO;
}

- (void)shareWithShareType:(ShareType)shareType activeShareType:(GatherShareType)activeShareType  {
    [TalkingData trackEvent:[Common eventStringFromShareType:activeShareType]];
    if (!NETWORK_REACHABLE && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        return;
    }
    
    if (![[ShareSDK getClientWithType:shareType] isClientInstalled] && shareType != ShareTypeSinaWeibo) {
        [SVProgressHUD showErrorWithStatus:@"请先安装客户端"];
        return;
    }
    
    __weak typeof(self) wself = self;
    id<ISSContent> content = [ShareSDK content:self.activeDetailInfo.intro
                                defaultContent:nil
                                         image:nil
                                         title:self.activeDetailInfo.title
                                           url:self.activeDetailInfo.share_url
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeNews];
    SHOW_LOAD_HUD;
    [ShareSDK clientShareContent:content type:shareType statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
        if (end) {
            if (state == SSPublishContentStateSuccess)
            {
                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                [Network activeShareWithActiveId:wself.activeId shareType:activeShareType success:^(id response) {
                    
                } failure:^(NSString *errorMsg, StatusCode code) {
                    
                }];
            }else {
                if (state == SSPublishContentStateCancel) {
                    [SVProgressHUD showErrorWithStatus:@"取消分享"];
                }
                if (state == SSPublishContentStateFail) {
                    [SVProgressHUD showErrorWithStatus:@"分享失败"];
                }
            }
        }
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSUInteger section = 0;
    if (self.activeDetailInfo) {
        section += 4;
    }
    if (!string_is_empty(self.activeDetailInfo.addr_route)) {
        section += 1;
        self.isShowRoute = YES;
    }
    if (self.strategyInfo) {
        section += 1;
        self.isShowStrategy = YES;
    }
    if (self.recallInfo) {
        section += 1;
        self.isShowRecall = YES;
    }
    if (self.starInfo) {
        section += 1;
        self.isShowStar = YES;
    }
    if (self.commentInfo) {
        section += 1;
        self.isShowCommentHeader = YES;
        self.isShowComment = YES;
    }
    
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.commentInfo && section == ([tableView numberOfSections]-2)) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *(^optionCell)(NSIndexPath *indexPath) = ^UITableViewCell *(NSIndexPath *indexPath) {
        
        if (self.strategyInfo && indexPath.section == 3) {
            
            self.isShowStrategy = YES;
            
            YellowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YellowCell" forIndexPath:indexPath];
            
            cell.titleLabel.text = @"攻略";
            cell.subTitle.text = self.strategyInfo.title;
            
            return cell;
        }
        if (((self.recallInfo && self.isShowStrategy) && indexPath.section == 4) || ((self.recallInfo && !self.isShowStrategy) && indexPath.section == 3)) {
            
            self.isShowRecall = YES;
            
            YellowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YellowCell" forIndexPath:indexPath];
            
            cell.titleLabel.text = @"活动回顾";
            cell.subTitle.text = self.recallInfo.title;
            
            return cell;
        }
        if ((self.starInfo && self.isShowStrategy && self.isShowRecall && indexPath.section == 5) ||
            ((self.starInfo && (self.isShowRecall || self.isShowStrategy)) && indexPath.section == 4) ||
            ((self.starInfo && (!self.isShowRecall && !self.isShowStrategy)) && indexPath.section == 3)) {
            
            __weak typeof(self) wself = self;
            StarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StarCell" forIndexPath:indexPath];
            
            cell.titleLabel.text = @"达人推荐";
            cell.starInfo = self.starInfo;
            [cell tapStarHandler:^(NSUInteger index) {
                
                SimpleUserInfoEntity *entity = wself.starInfo.users[index];
            
                PersonalHomePageViewController *controller = [[UIStoryboard personalCenterStoryboard] instantiateViewControllerWithIdentifier:@"PersonalHomePage"];
                controller.userId = entity.id;
                controller.isFocus = entity.is_focus;
                controller.nickName = entity.nick_name;
                controller.headImageUrl = entity.head_img_url;
                controller.userInfo = (PersonalHomePageEntity *)entity;
            
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:nav animated:YES completion:nil];
            }];
            [cell.collectionView reloadData];

            return cell;
        }
        
        if (self.commentInfo && (indexPath.section == [tableView numberOfSections] - 2) && indexPath.row == 0) {
            
            CommentHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentHeader" forIndexPath:indexPath];
            cell.numberLabel.text = [NSString stringWithFormat:@"%d条",self.commentInfo.total_num];
            
            return cell;
        }
        if (self.commentInfo && indexPath.section == ([tableView numberOfSections] - 2) && indexPath.row == 1) {
            
            ActiveCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActiveCommentCell" forIndexPath:indexPath];
            [cell.timeLabel setHidden:YES];
            [cell.timeHeight setConstant:0];
            
            CommentEntity *entity = self.commentInfo.comments[0];
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:entity.user.head_img_url] placeholderImage:placeholder_image];
            [cell.nicknameLabel setText:entity.user.nick_name];
            [cell.contentLabel setText:entity.content];
            [cell.timeLabel setText:entity.create_time];
            
            return cell;
        }
        
        if (((!string_is_empty(self.activeDetailInfo.addr_route) && self.isShowComment) && indexPath.section == [tableView numberOfSections] - 3) ||
            ((!string_is_empty(self.activeDetailInfo.addr_route) && !self.isShowComment) && indexPath.section == [tableView numberOfSections] - 2)) {
            
            YellowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YellowCell" forIndexPath:indexPath];
            
            cell.titleLabel.text = @"交通信息";
            cell.subTitle.text = self.activeDetailInfo.addr_route;
            
            return cell;
        }
        
        if (self.activeDetailInfo  && indexPath.section == [self.tableView numberOfSections] - 1) {
            ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareCell" forIndexPath:indexPath];
            
            __weak typeof(self) wself = self;
            [cell.sinaWeiboButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
                [wself shareWithShareType:ShareTypeSinaWeibo activeShareType:GatherShareTypeSinaWeibo];
            }];
            [cell.weChatButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
                [wself shareWithShareType:ShareTypeWeixiSession activeShareType:GatherShareTypeWeChat];
            }];
            [cell.weChatFriednsButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
                [wself shareWithShareType:ShareTypeWeixiTimeline activeShareType:GatherShareTypeWeChatFriend];
            }];
            [cell.QQZoneButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
                [wself shareWithShareType:ShareTypeQQSpace activeShareType:GatherShareTypeQQZone];
            }];
        
            return cell;
        }
        return nil;
    };
    
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PriceCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PriceCell"];
                cell.detailTextLabel.textColor = color_with_hex(kColor_ff9933);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (self.activeDetailInfo.cost <= 0) {
                cell.detailTextLabel.text = @"免费";
            }else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",self.activeDetailInfo.cost];
            }
            
            return cell;
        }
            break;
        case 1:
        {
            AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
//            #ifdef __Gather_2_0_2__
//            
//                if (self.addressEntity && self.addressEntity.act_addrs.count > 0) {
//                    AddressParkingSpaceEntity *entity = [self.addressEntity.act_addrs objectAtIndex:0];
//                    
//                    cell.titleLabel.text = entity.addr_name;
//                    cell.subTitle.text = [NSString stringWithFormat:@"%@,%@,%@",entity.addr_city,entity.addr_area,entity.addr_road];
//                }
//            #else
                cell.titleLabel.text = self.activeDetailInfo.addr_name;
                cell.subTitle.text = [NSString stringWithFormat:@"%@,%@,%@",self.activeDetailInfo.addr_city,self.activeDetailInfo.addr_area,self.activeDetailInfo.addr_road];
//            #endif
            return cell;
        }
            break;
        case 2:
        {
            YellowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YellowCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.titleLabel.text = @"活动详情";
            cell.subTitle.attributedText = [[NSAttributedString alloc] initWithString:self.activeDetailInfo.detail attributes:@{NSParagraphStyleAttributeName : ({
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 2;
                paragraphStyle;
            })}];
            
            return cell;
        }
            break;
        default:
        {
            UITableViewCell *cell = optionCell(indexPath);
            if (indexPath.row == 1) {
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }else {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.strategyInfo && indexPath.section == 3) {
        RecallDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RecallDetail"];
        controller.title = @"攻略详情";
        controller.newsInfo = self.strategyInfo;
        [self.navigationController pushViewController:controller animated:YES];
    }
    if (self.recallInfo) {
        
        if ((self.strategyInfo && indexPath.section == 4) || (!self.strategyInfo && indexPath.section == 3)) {
            RecallDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RecallDetail"];
            controller.newsInfo = self.recallInfo;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    
    if (indexPath.section == 1) {
        
//        #ifdef __Gather_2_0_2__
//            ActiveMapViewController *controller = [[ActiveMapViewController alloc] init];
//            controller.addressEntity = self.addressEntity;
//            [self.navigationController pushViewController:controller animated:YES];
//        #else
            CLLocationCoordinate2D coor;
            coor.longitude = self.activeDetailInfo.lon;
            coor.latitude = self.activeDetailInfo.lat;
            MapViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Map"];
            controller.endName = self.activeDetailInfo.addr_name;
            controller.endCoor = coor;
            [self.navigationController pushViewController:controller animated:YES];
//        #endif
    }
    
    if (self.commentInfo  && indexPath.section == [self.tableView numberOfSections] - 2) {
        
        verify_is_login;

        ActiveCommentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ActiveComment"];
        controller.activeId = self.activeDetailInfo.id;

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.tableViewHeaderView.parallaxHeaderView setAlpha:1.0];
    [self.tableViewHeaderView.parallaxHeaderView setHeaderImage:self.tableViewHeaderView.bannerView.currentImage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.tableViewHeaderView.parallaxHeaderView setAlpha:0.0];
    [self.tableViewHeaderView.parallaxHeaderView setHeaderImage:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableViewHeaderView.parallaxHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
}

@end
