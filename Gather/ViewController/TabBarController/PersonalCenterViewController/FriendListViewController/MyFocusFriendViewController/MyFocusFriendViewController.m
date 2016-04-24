//
//  MyFocusFriendViewController.m
//  Gather
//
//  Created by apple on 15/2/3.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "MyFocusFriendViewController.h"
#import "FriendListTableViewCell.h"
#import "PersonalHomePageViewController.h"
#import "Network+FriendList.h"

@interface MyFocusFriendViewController ()

@property (nonatomic, strong) NSMutableArray *infoArray;

@end

@implementation MyFocusFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infoArray = [[NSMutableArray alloc] init];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] init];;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FriendListTableViewCell class]) bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    
    __weak typeof(self) wself = self;
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
    [self.tableView headerBeginRefreshing];}

- (void)requestInfo {
    
    if (self.tableView.footerRefreshing && self.currentPage != 0 && self.infoArray.count >= self.totalNumber) {
        [self.tableView footerEndRefreshing];
        return;
    }
    
    self.currentPage += 1;
    
    __weak typeof(self) wself = self;
    
    [Network getListWithType:FriendTypeMyFocus uid:self.userId cityId:[Common getCurrentCityId] page:self.currentPage size:kSize uccess:^(FriendListEntity *entity) {
        wself.totalNumber = entity.total_num;
        
        NSMutableArray *temp = [NSMutableArray arrayWithArray:entity.users];
        
        NSUInteger selfId = [Common getCurrentUserId];
        if ([Common isLogin] && selfId > 0) {
            [temp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SimpleUserInfoEntity *entity = obj;
                
                if (entity.id == selfId) {
                    [temp removeObjectAtIndex:idx];
                }
            }];
        }
        
        if (wself.currentPage == 1) {
            [wself.infoArray setArray:temp];
            [wself.tableView headerEndRefreshing];
        }else {
            [wself.infoArray addObjectsFromArray:temp];
            [wself.tableView footerEndRefreshing];
        }
        
        [wself.tableView reloadDataIfEmptyShowCueWordsView];
        
    } failure:^(NSString *errorMsg, StatusCode code) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendListTableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    SimpleUserInfoEntity *entity = self.infoArray[indexPath.row];;
    __weak typeof(self) wself = self;
    
    [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTap:)]];
    [cell setAddOrCancelFocusHandler:^(int currentFocusStatus) {
        [TalkingData trackEvent:@"关注"];
        
        verify_is_login;
        
        // 未关注
        if (currentFocusStatus == 0) {
            [Network addFocusWithUserId:entity.id success:^(id response) {
                
                entity.is_focus = YES;
                [wself.infoArray replaceObjectAtIndex:indexPath.row withObject:entity];
                [wself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
            } failure:^(NSString *errorMsg, StatusCode code) {
                alert(nil, @"关注失败");
            }];
        }else {
            [Network cancelFocusWithUserId:entity.id success:^(id response) {
                
                if (wself.userId == 0) {
                    [wself.infoArray removeObject:entity];
                    [wself.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }else {
                    entity.is_focus = NO;
                    [wself.infoArray replaceObjectAtIndex:indexPath.row withObject:entity];
                    [wself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            } failure:^(NSString *errorMsg, StatusCode code) {
                alert(nil, @"取消失败");
            }];
        }
    }];
    
    [cell setHeadImageStringURL:entity.head_img_url];
    [cell setNickname:entity.nick_name];
    [cell setSexWithIntSex:entity.sex];
    [cell setIsFocus:entity.is_focus];
    //[cell setIsStar:entity.is_vip];
    [cell setIsStar:NO];
    [cell setIntro:entity.intro];
    
    [cell setTag:indexPath.row];
    
    return cell;
}

- (void)cellTap:(UITapGestureRecognizer *)tap {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tap.view.tag inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SimpleUserInfoEntity *entity = self.infoArray[indexPath.row];
    
    if (entity.id != [Common getCurrentUserId]) {
        PersonalHomePageViewController *controller = [[UIStoryboard personalCenterStoryboard] instantiateViewControllerWithIdentifier:@"PersonalHomePage"];
        controller.userId = entity.id;
        controller.isFocus = entity.is_focus;
        controller.nickName = entity.nick_name;
        controller.headImageUrl = entity.head_img_url;
        controller.userInfo = (PersonalHomePageEntity *)entity;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self.parentVC presentViewController:nav animated:YES completion:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];

    }
}


@end
