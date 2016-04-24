//
//  PersonalCenterViewController.m
//  Gather
//
//  Created by Ray on 14-12-26.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "FriendListViewController.h"
#import "MyPhotoViewController.h"
#import "PersonalHomePageViewController.h"
#import "RecallSubViewController.h"
#import "MyActiveViewController.h"
#import "Network+UserInfo.h"

@interface PersonalCenterViewController ()

@property (nonatomic, strong) FullUserInfoEntity *userInfo;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *focusLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nicknameLabel.textColor = color_with_hex(kColor_6e7378);
    self.focusLabel.textColor = color_with_hex(kColor_8e949b);
    self.fansLabel.textColor = color_with_hex(kColor_8e949b);
    
    __weak typeof(self) wself = self;
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithImage:image_with_name(@"btn_my_preview_d") highlight:image_with_name(@"btn_my_preview_h") clickHandler:^(BlockBarButtonItem *item) {
        PersonalHomePageViewController *controller = [[UIStoryboard personalCenterStoryboard] instantiateViewControllerWithIdentifier:@"PersonalHomePage"];
        controller.userId = [Common getCurrentUserId];
        controller.userInfo = (PersonalHomePageEntity *)self.userInfo;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [wself presentViewController:nav animated:YES completion:nil];
    }]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.userInfo = [Common getSelfUserInfo];
    [self setup];
    
    circle_view(self.imageView);
    if ([Common getCurrentUserId] > 0 && !self.userInfo) {
        __weak typeof(self) wself = self;
        if ([Common getCurrentCityId]) {
            SHOW_LOAD_HUD;
            [Network getUserInfoWithUserId:[Common getCurrentUserId] cityID:[Common getCurrentCityId]
                                   success:^(FullUserInfoEntity *entity) {
                                       wself.userInfo = entity;
                                       [wself setup];
                                       DISMISS_HUD;
                                   }
                                   failure:^(NSString *errorMsg, StatusCode code) {
                                       [SVProgressHUD showErrorWithStatus:@"获取用户信息失败"];
                                   }];
        }
    }
}

- (void)setup {
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.head_img_url] placeholderImage:placeholder_image];
    [self.nicknameLabel setText:self.userInfo.nick_name];
    [self.focusLabel setText:[@(self.userInfo.focus_num) stringValue]];
    [self.fansLabel setText:[@(self.userInfo.fans_num) stringValue]];
    
    [self.tableView reloadDataIfEmptyShowCueWordsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.userInfo) {
        return 4;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.userInfo) {
        switch (indexPath.section) {
            case 0:
            {
                return 104;
            }
                break;
            case 1:
            {
                return 44;
            }
            case 2:
            {
                /* V2.2  去掉申请达人
                if (self.userInfo) {
                    if (self.userInfo.is_vip) {
                        return 0;
                    }else {
                        return 44;
                    }
                }*/
                return 0;
            }
                break;
            default:
            {
                return 44;
            }
                break;
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        /* V2.2  去掉申请达人
        if (self.userInfo) {
            if (self.userInfo.is_vip) {
                [cell setHidden:YES];
            }
        }*/
        [cell setHidden:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //[[segue destinationViewController] setHidesBottomBarWhenPushed:YES];
    
    if ([[segue identifier] isEqualToString:@"attention"]) {
        FriendListViewController *list = [segue destinationViewController];
        list.friendType = FriendTypeMyFocus;
    }else if ([[segue identifier] isEqualToString:@"fans"]) {
        FriendListViewController *list = [segue destinationViewController];
        list.friendType = FriendTypeMyFans;
    }
    
    if ([[segue identifier] isEqualToString:@"MyPhoto"]) {
        MyPhotoViewController *controller = [segue destinationViewController];
        controller.showManagerButton = YES;
        controller.allowEditing = NO;
    }
    if ([[segue identifier] isEqualToString:@"Active"]) {
        MyActiveViewController *controller = [segue destinationViewController];
        controller.userId = [Common getCurrentUserId];
    }
}

@end
