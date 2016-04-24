//
//  MainViewController30.m
//  Gather
//
//  Created by apple on 15/4/23.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "MainViewController30.h"
#import "BannerView.h"
#import "Network+Banner.h"
#import "CityListEntity.h"
#import "RecallDetailViewController.h"
#import "CityListViewController.h"
#import "MyActiveViewController.h"
#import "FullUserInfoEntity.h"
#import "ClubListViewController.h"
#import <IQKeyboardManager.h>

#import "Network+UploadFile.h"

@interface  MainViewController30()

@property (weak, nonatomic) IBOutlet BannerView *bannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeight;

@property (nonatomic, strong) NewsListEntity *bannerInfo;

@property (nonatomic, strong) BlockBarButtonItem *cityItem;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, assign) BOOL isFirstShow;

@property (nonatomic, strong) id changeCityNoti;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doingButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clubButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doingSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotSpace;

@end

@implementation MainViewController30

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isFirstShow = YES;
    _statusBarStyle = UIStatusBarStyleDefault;
    
//    self.bannerHeight.constant = SCREEN_WIDTH * (430.0/640.0);
    self.bannerHeight.constant = SCREEN_HEIGHT * (400.0/1136.0);

    self.doingButtonWidth.constant = SCREEN_WIDTH * (130.0/640.0);
    self.clubButtonWidth.constant = SCREEN_WIDTH * (190.0/640.0);
    self.hotButtonWidth.constant = SCREEN_WIDTH * (130.0/640.0);
    
    self.doingSpace.constant = SCREEN_WIDTH * (28.0/320.0);
    self.hotSpace.constant = SCREEN_WIDTH * (28.0/320.0);
    
    __weak typeof(self) wself = self;
    self.cityItem = [[BlockBarButtonItem alloc] initWithTitle:@"成都" clickHandler:^(BlockBarButtonItem *item){
        [wself showCityView:nil];
    }];
    [self refreshCityAndBannerView];
    
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithImage:image_with_name(@"img_newest_notice_search") highlight:nil clickHandler:^(BlockBarButtonItem *item){
        
        [[IQKeyboardManager sharedManager] setEnable:NO];
        BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"搜索社团" message:@"请输入社团关键字" handler:^(UIAlertView *alertView, NSUInteger index) {
            
            UITextField *textField = [alertView textFieldAtIndex:0];
            [textField resignFirstResponder];
            if (index) {
                [wself club:textField.text];
                [[IQKeyboardManager sharedManager] setEnable:YES];
            }
            
        } cancelButtonTitle:@"取消" otherButtonTitles:@"搜索"];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
        
    }]];
    [self.navigationItem addLeftItem:self.cityItem];
}

- (void)refreshCityAndBannerView {
    
    if ([Common getCurrentCityId] > 0) {
        
        __weak typeof(self) wself = self;
        self.cityItem.title = [Common getCurrentCityName];
        self.cityItem.enabled = YES;
        [Network getBannerListWithCityId:[Common getCurrentCityId] page:1 size:kSize success:^(NewsListEntity *entity) {
            wself.bannerInfo = entity;
            [wself setupBannerView];
        } failure:^(NSString *errorMsg, StatusCode code) {
            
        }];
    }else {
        self.cityItem.title = @"";
        self.cityItem.enabled = NO;
    }
}

- (void)setupBannerView {
    
    if (self.bannerInfo && self.bannerInfo.news.count > 0) {
        __weak typeof(self) wself = self;
        NSMutableArray *imgURL = [[NSMutableArray alloc] init];
        [self.bannerInfo.news enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NewsEntity *entity = obj;
            [imgURL addObject:thumbnail_url(entity.h_img_url, CGRectGetWidth(wself.bannerView.bounds), CGRectGetHeight(wself.bannerView.bounds))];
        }];
        
        self.bannerView.imageItems = imgURL;
        self.bannerView.imageViewContentMode = UIViewContentModeScaleAspectFill | UIViewContentModeLeft | UIViewContentModeRight;
        self.bannerView.placeholderImage = placeholder_image;
        
        /*UIImage *image = image_with_name(@"img_main_shadow_arc");
        UIImageView *shadowView = [[UIImageView alloc] initWithImage:image];
        shadowView.frame = CGRectMake(0, self.bannerHeight.constant - image.size.height, SCREEN_WIDTH, image.size.height);*/
    
        //[self.bannerView insertSubview:shadowView atIndex:1];
        [self.bannerView enventHandler:^(UIImageView *imageView, NSUInteger index) {
            
            NewsEntity *entity = wself.bannerInfo.news[index];
            
            NSString *title = @"";
            switch (entity.type_id) {
                case 1:
                    title = @"攻略详情";
                    break;
                case 2:
                    title = @"记忆详情";
                    break;
                case 3:
                    title = @"订购详情";
                    break;
                default:
                    title = @"资讯详情";
                    break;
            }
            RecallDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RecallDetail"];
            controller.title = title;
            controller.newsInfo = entity;
            [self.navigationController pushViewController:controller animated:YES];
        }];
    }else {
        self.bannerView.imageItems = @[];
    }
}

- (void)showCityView:(NSString *)cityName {
    
    __weak typeof(self) wself = self;
    self.changeCityNoti = [[NSNotificationCenter defaultCenter] addObserverForName:kCHANGE_CITY_NOTIFICATION_NAME object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [wself refreshCityAndBannerView];
        [[NSNotificationCenter defaultCenter] removeObserver:wself.changeCityNoti];
    }];
    
    CityListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"City"];
    if (!string_is_empty(cityName)) {
        controller.locationName = cityName;
    }
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_isFirstShow) {
        if (!NETWORK_REACHABLE) {
            [self setIsFirstShow:YES];
            [SVProgressHUD showErrorWithStatus:@"网络异常，请连接网络后重试"];
        }else {
            [self setIsFirstShow:NO];
            
            if ([Common getCurrentCityId] <= 0) {
                __weak typeof(self) wself = self;
                
                BOOL needReverseGeoCode = YES;
                if ([[Common getCacheCityList].cities count] > 0) {
                    needReverseGeoCode = NO;
                }
                
                [Common getCurrentLocationWithNeedReverseGeoCode:needReverseGeoCode updateHandler:^(CLLocationCoordinate2D coor, LocationState state) {
                    
                    NSUInteger cityId = [Common getCurrentCityId];
                    if (state == LocationStateActive) {
                        if (cityId <= 0) {
                            [SVProgressHUD showWithStatus:@"正在定位"];
                        }
                    }
                    if (state == LocationStateEnd) {
                        [SVProgressHUD dismiss];
                        if (cityId <= 0){
                            [[[BlockAlertView alloc] initWithTitle:nil message:@"定位到您当前的城市不支持，请手动选择城市" handler:^(UIAlertView *alertView, NSUInteger index) {
                                [wself showCityView:[Common getCurrentCityName]];
                            } cancelButtonTitle:nil otherButtonTitles:@"好"] show];
                        }else {
                            [wself refreshCityAndBannerView];
                        }
                    }
                    if (state == LocationStateFailed) {
                        if (cityId <= 0){
                            if (!NETWORK_REACHABLE) {
                                [self setIsFirstShow:YES];
                                [SVProgressHUD showErrorWithStatus:@"网络异常，请连接网络后重试"];
                            }else {
                                DISMISS_HUD;
                                [[[BlockAlertView alloc] initWithTitle:nil message:@"定位失败，请手动选择城市" handler:^(UIAlertView *alertView, NSUInteger index) {
                                    [wself showCityView:nil];
                                } cancelButtonTitle:nil otherButtonTitles:@"好"] show];
                            }
                        }
                    }
                }];
            }else {
                [self refreshCityAndBannerView];
            }
        }
    }
}

- (IBAction)myActive:(id)sender {
    verify_is_login;
    MyActiveViewController *controller = [[UIStoryboard personalCenterStoryboard] instantiateViewControllerWithIdentifier:@"MyActive"];
    controller.userId = [Common getSelfUserInfo].id;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)club:(id)sender {
    
    ClubListViewController *controller = [[UIStoryboard clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubList"];
    if ([sender isKindOfClass:[NSString class]]) {
        controller.searchkeyWords = sender;
    }
    [self.navigationController pushViewController:controller animated:YES];

}
- (IBAction)hot:(id)sender {
    
}


@end
