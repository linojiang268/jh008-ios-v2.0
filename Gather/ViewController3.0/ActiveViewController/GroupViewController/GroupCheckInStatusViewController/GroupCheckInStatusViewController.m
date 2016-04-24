//
//  GroupCheckInStatusViewController.m
//  Gather
//
//  Created by apple on 15/4/3.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "GroupCheckInStatusViewController.h"
#import "CheckInInfoListEntity.h"
#import "FullUserInfoEntity.h"
#import "ActiveConfigEntity.h"
#import "BarcodeViewController.h"
#import "Network+Group.h"

@interface GroupCheckInStatusViewController ()

@property (weak, nonatomic) IBOutlet UILabel *activeNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *activeCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *checkInAddressNameLabel;
@property (weak, nonatomic) IBOutlet UIView *confirmView;
@property (weak, nonatomic) IBOutlet UIView *succeedView;

@property (nonatomic, strong) BarcodeViewController *barcodeControlelr;

@property (nonatomic, strong) CheckInInfoListEntity *checkInInfo;
@property (nonatomic, strong) CheckInInfoEntity *currentCheckInInfo;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation GroupCheckInStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activeNameLabel.text = @"";
    self.checkInAddressNameLabel.text = @"";
    self.confirmView.hidden = YES;
    self.succeedView.hidden = YES;
    
    self.isFirst = YES;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderWidth = 2.0;
    self.imageView.layer.borderColor = [color_white CGColor];
    self.imageView.layer.cornerRadius = CGRectGetWidth(self.imageView.bounds)/2;
    self.activeCoverImageView.layer.masksToBounds = YES;
}

- (void)addRightItem {
    [self removeRightItem];
    __weak typeof(self) wself = self;
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"扫码" clickHandler:^(BlockBarButtonItem *item) {
        [wself checkIn];
    }]];
}

- (void)removeRightItem {
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isFirst) {
        [self.activeNameLabel setText:self.activeInfo.title];
        [self.nameLabel setText:[Common getSelfUserInfo].nick_name];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[Common getSelfUserInfo].head_img_url]];
        [self.activeCoverImageView sd_setImageWithURL:[NSURL URLWithString:self.activeInfo.head_img_url] placeholderImage:placeholder_image];
        [self requestCheckInInfo];
    }
}

- (void)requestCheckInInfo {
    SHOW_LOAD_HUD;
    __weak typeof(self) wself = self;
    [Network getCheckInListWithActiveId:self.activeInfo.id page:1 size:kActiveGroupSize success:^(CheckInInfoListEntity *entity) {
        wself.checkInInfo = entity;
        DISMISS_HUD;
        if (wself.checkInInfo.checkins.count <= 0) {
            wself.confirmButton.hidden = YES;
            if (wself.isFirst) {
                [wself checkIn];
                wself.isFirst = NO;
            }else {
                [wself.navigationController popViewControllerAnimated:YES];
            }
        }else {
            wself.isFirst = NO;
            CheckInInfoEntity *lastInfo = [wself.checkInInfo.checkins lastObject];
            if (lastInfo) {
                [wself configViewWithCheckInInfo:lastInfo];
                wself.currentCheckInInfo = lastInfo;
            }
        }
        
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"获取签到信息失败"];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)confirm:(id)sender {
    SHOW_LOAD_HUD;
    __weak typeof(self) wself = self;
    [Network confirmCheckInWithId:self.currentCheckInInfo.id success:^(id response) {
        [SVProgressHUD showSuccessWithStatus:@"确认成功"];
        wself.currentCheckInInfo.status = 1;
        [wself configViewWithCheckInInfo:wself.currentCheckInInfo];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"确认失败,请重试"];
    }];
}

- (void)configViewWithCheckInInfo:(CheckInInfoEntity *)info {
    
    self.checkInAddressNameLabel.text = info.subject;
    if (info.need_sure == 0 || (info.need_sure == 1 && info.status == 1)) {
        self.confirmView.hidden = YES;
        self.succeedView.hidden = NO;
        [self addRightItem];
    }else if (info.need_sure == 1 && info.status == 0) {
        self.confirmView.hidden = NO;
        self.succeedView.hidden = YES;
        [self removeRightItem];
    }
}

- (void)checkIn {
    verify_is_login;
    
    self.barcodeControlelr = [BarcodeViewController controllerWithCompleteHandler:^(NSString *result) {
        NSError *error;
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"签到失败"];
            return;
        }
        
        if (dict && dict.count == 2 && [dict[@"value"] intValue] > 0) {
            NSUInteger checkInId = [dict[@"value"] intValue];
            CLLocationCoordinate2D coor = [Common getCurrentLocationCoordinate2D];
            SHOW_LOAD_HUD;
            __weak typeof(self) wself = self;
            [Network checkInWithId:checkInId lon:coor.longitude lat:coor.latitude address:[Common getCurrentFullAddress] success:^(CheckInInfoEntity *entity) {
                DISMISS_HUD;
                [wself setCurrentCheckInInfo:entity];
                [wself configViewWithCheckInInfo:entity];
                
            } failure:^(NSString *errorMsg, StatusCode code) {
                [SVProgressHUD showErrorWithStatus:@"签到失败"];
            }];
        }else {
            [SVProgressHUD showErrorWithStatus:@"签到失败"];
        }
    }];
    self.barcodeControlelr.title = @"扫描二维码";
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.barcodeControlelr];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
