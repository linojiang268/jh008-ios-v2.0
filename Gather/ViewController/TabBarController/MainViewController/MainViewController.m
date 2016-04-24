//
//  MainViewController.m
//  Gather
//
//  Created by Ray on 14-12-26.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "MainViewController.h"
#import "BannerView.h"
#import "BMapKit.h"
#import "CityListViewController.h"
#import "ActiveViewController.h"
#import "BarcodeViewController.h"
#import "RecallViewController.h"
#import "AboutUsViewController.h"
#import "RecallDetailViewController.h"
#import "Network+Active.h"
#import "Network+Banner.h"
#import "Network+News.h"
#import "CityListEntity.h"

#import "ClubListViewController.h"
#import "RoadmapViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet BannerView *bannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeight;
@property (nonatomic, strong) NewsListEntity *bannerInfo;

@property (nonatomic, strong) BlockBarButtonItem *cityItem;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, assign) BOOL isFirstShow;

@property (nonatomic, strong) BarcodeViewController *barcodeControlelr;

@property (nonatomic, strong) id changeCityNoti;

@end

@implementation MainViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
   return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    _isFirstShow = YES;
    _statusBarStyle = UIStatusBarStyleDefault;
    
    CGFloat height = 0;
    if (iPhone4) {
        height = 135;
    }
    if (iPhone5) {
        height = 162;
    }
    if (iPhone6) {
        height = 190;
    }
    if (iPhone6plus) {
        height = 210;
    }
    self.bannerHeight.constant = height;
    
    __weak typeof(self) wself = self;
    self.cityItem = [[BlockBarButtonItem alloc] initWithTitle:@"成都" clickHandler:^(BlockBarButtonItem *item){
        [wself showCityView:nil];
    }];
    [self refreshCityAndBannerView];

    [self.navigationItem addLeftItem:[[BlockBarButtonItem alloc] initWithTitle:@"关于我们" clickHandler:^(BlockBarButtonItem *item){
        
        AboutUsViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
        [wself.navigationController pushViewController:controller animated:YES];
    }]];
    [self.navigationItem addRightItem:self.cityItem];
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


- (IBAction)activity:(id)sender {

}

- (IBAction)tipoff:(id)sender {
}

- (IBAction)hot:(id)sender {
    
}

- (IBAction)signIn:(id)sender {
    
    ClubListViewController *controller = [[UIStoryboard clubStoryboard] instantiateViewControllerWithIdentifier:@"ClubList"];
    [self.navigationController pushViewController:controller animated:YES];
    
    
    return;
    
    verify_is_login;
    
    self.barcodeControlelr = [BarcodeViewController controllerWithCompleteHandler:^(NSString *result) {
        NSError *error;
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            alert(nil, @"签到失败");
            return;
        }
        
        if (dict && dict.count == 2 && [dict[@"value"] intValue] > 0) {
            NSUInteger activeId = [dict[@"value"] intValue];
            CLLocationCoordinate2D coor = [Common getCurrentLocationCoordinate2D];
            SHOW_LOAD_HUD;
            [Network activeCheckInWithActiveId:activeId lon:coor.longitude lat:coor.latitude address:[Common getCurrentFullAddress] success:^(id response) {
                [SVProgressHUD showSuccessWithStatus:@"签到成功"];
            } failure:^(NSString *errorMsg, StatusCode code) {
                [SVProgressHUD showErrorWithStatus:@"签到失败"];
            }];
        }else {
            alert(nil, @"签到失败");
        }
    }];
    self.barcodeControlelr.title = @"扫描二维码";
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.barcodeControlelr];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)memory:(id)sender {
    RoadmapViewController *controller = [[RoadmapViewController alloc] init];
    controller.activeId = 99;//wself.activeId;
    controller.groupId = 1;//[ActiveMoreConfigEntity sharedMoreConfig].group_id;
    [self.navigationController pushViewController:controller animated:YES];
    
    /*RecallViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Recall"];
    controller.title = @"记忆";
    controller.newsType = NewsTypeRecall;
    [self.navigationController pushViewController:controller animated:YES];*/
}

- (IBAction)order:(id)sender {
    RecallViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Recall"];
    controller.title = @"订购";
    controller.newsType = NewsTypeTicket;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)figure:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
