//
//  ClubViewController.m
//  Gather
//
//  Created by apple on 15/4/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ClubViewController.h"
#import "ClubHeaderView.h"
#import "RecentActiveCell.h"
#import "ClubNoticeCell.h"
#import "PastActiveCell.h"
#import "ClubIntroCell.h"
#import "GroupMemberTableViewCell.h"
#import "Network+Club.h"
#import "PersonalHomePageViewController.h"
#import "ActiveDetailViewController.h"
#import "RecallDetailViewController.h"
#import <UIButton+WebCache.h>
#import "ClubMemberListViewController.h"

@interface ClubViewController ()

@property (nonatomic, strong) ClubHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *recentArray;
@property (nonatomic, strong) NSMutableArray *managerArray;
@property (nonatomic, strong) NSMutableArray *pastArray;

@property (nonatomic, assign) BOOL recentPage;
@property (nonatomic, assign) BOOL pastPage;

@property (nonatomic, assign) BOOL recentTotalNumber;
@property (nonatomic, assign) BOOL pastTotalNumber;

@property (nonatomic, strong) ClubDetailEntity *clubDetailInfo;

@end

@implementation ClubViewController

- (void)segmentControlValueChanged:(HMSegmentedControl *)segment {
    
    switch (segment.selectedSegmentIndex) {
        case 1:
            self.tableView.footerHidden = YES;
            [self.tableView reloadData];
            break;
        case 0:
            self.tableView.footerHidden = NO;
            if (self.recentPage > 0) {
                [self.tableView reloadData];
            }else {
                [self requestRecentActive];
            }
            break;
        case 2:
            self.tableView.footerHidden = NO;
            if (self.pastPage > 0) {
                [self.tableView reloadData];
            }else {
                [self requestPastActive];
            }
            break;
        default:
            break;
    }
}

- (void)focusEvent {
    
    SHOW_LOAD_HUD;
    __weak typeof(self) wself = self;
    if (self.clubDetailInfo.is_loved != 1) {
        [Network focusClubWithClubId:self.clubId success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            wself.clubDetailInfo.is_loved = 1;
            wself.headerView.focusButton.selected = 1;
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"关注失败"];
        }];
    }
    if (self.clubDetailInfo.is_loved == 1) {
        [Network cancelFocusClubWithClubId:self.clubId success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            wself.clubDetailInfo.is_loved = 0;
            wself.headerView.focusButton.selected = 0;
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"取消失败"];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestRecentActive];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recentArray = [[NSMutableArray alloc] init];
    self.managerArray = [[NSMutableArray alloc] init];
    self.pastArray = [[NSMutableArray alloc] init];
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.headerView = [[ClubHeaderView alloc] init];
    self.tableView.tableHeaderView = self.headerView;
    
    [self.headerView.segment addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.headerView.focusButton addTarget:self action:@selector(focusEvent) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self) wself = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ClubIntroCell class]) bundle:nil] forCellReuseIdentifier:@"ClubIntroCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GroupMemberTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"ManagerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RecentActiveCell class]) bundle:nil] forCellReuseIdentifier:@"RecentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ClubNoticeCell class]) bundle:nil] forCellReuseIdentifier:@"ClubNoticeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PastActiveCell class]) bundle:nil] forCellReuseIdentifier:@"PastActiveCell"];
    [self.tableView addFooterWithCallback:^{
        switch (wself.headerView.segment.selectedSegmentIndex) {
            case 0:
                [wself requestRecentActive];
                break;
            case 2:
                [wself requestPastActive];
                break;
            default:
                break;
        }
    }];
    [self.headerView.fansLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clubMember)]];
    self.tableView.footerHidden = YES;
    
    SHOW_LOAD_HUD;
    [Network getClubDetailWithClubId:self.clubId success:^(ClubDetailEntity *entity) {
        DISMISS_HUD;
        wself.clubDetailInfo = entity;
        [wself refreshView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"社团信息获取失败"];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
    [Network getClubManagerListWithClubId:self.clubId page:1 size:4 success:^(FriendListEntity *entity) {
        [wself.managerArray setArray:entity.users];
        if (wself.headerView.segment.selectedSegmentIndex == 1) {
            [wself.tableView reloadData];
        }
    } failure:^(NSString *errorMsg, StatusCode code) {
        
    }];
}

- (void)clubMember {
    ClubMemberListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ClubMember"];
    controller.clubId = self.clubId;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)refreshView {
    
    self.headerView.focusButton.selected = (self.clubDetailInfo.is_loved == 1);
    self.headerView.nameLabel.text = self.clubDetailInfo.subject;
    self.headerView.fansLabel.text = [NSString stringWithFormat:@"%d",self.clubDetailInfo.lov_user_num];
    self.headerView.activeNumberLabel.text = [NSString stringWithFormat:@"%d",self.clubDetailInfo.act_num];
    [self.headerView.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.clubDetailInfo.icon_url] placeholderImage:placeholder_image];
    
    [self.tableView reloadData];
}

- (void)requestRecentActive {
    if (self.recentPage > 0 && self.recentArray.count >= self.recentTotalNumber) {
        [self.tableView footerEndRefreshing];
        return;
    }
    self.recentPage += 1;
    
    if (self.recentPage == 1) {
        SHOW_LOAD_HUD;
    }
    
    __weak typeof(self) wself = self;
    [Network getClubRecentActiveListWithClubId:self.clubId page:self.recentPage size:kSize success:^(ActiveListEntity *entity) {
        if (wself.recentPage == 1) {
            DISMISS_HUD;
            [wself.recentArray setArray:entity.acts];
        }else {
            [wself.recentArray addObjectsFromArray:entity.acts];
            [wself.tableView footerEndRefreshing];
        }
        [wself.tableView reloadData];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [wself.tableView footerEndRefreshing];
    }];
}

- (void)requestPastActive {
    if (self.pastPage > 0 && self.pastArray.count >= self.pastTotalNumber) {
        [self.tableView footerEndRefreshing];
        return;
    }
    self.pastPage += 1;
    
    if (self.pastPage == 1) {
        SHOW_LOAD_HUD;
    }
    
    __weak typeof(self) wself = self;
    [Network getClubPastActiveListWithClubId:self.clubId page:self.pastPage size:kSize success:^(NewsListEntity *entity) {
        if (wself.pastPage == 1) {
            DISMISS_HUD;
            if (entity.news.count <= 0) {
                [SVProgressHUD showErrorWithStatus:@"暂无数据"];
            }else {
                [wself.pastArray setArray:entity.news];
            }
        }else {
            [wself.pastArray addObjectsFromArray:entity.news];
            [wself.tableView footerEndRefreshing];
        }
        [wself.tableView reloadData];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [wself.tableView footerEndRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (self.headerView.segment.selectedSegmentIndex) {
        case 1:
        {
            NSUInteger row = 0;
            if (self.managerArray.count > 0) {
                row += 1;
            }
            if (!string_is_empty(self.clubDetailInfo.intro)) {
                row += 1;
            }
            return row;
        }
            break;
        case 0:
            if (self.recentArray.count > 0) {
                return self.recentArray.count;
            }else {
                return 1;
            }
            break;
        case 2:
            return self.pastArray.count;
            break;
        default:
            break;
    }
    return 0;
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
    
    switch (self.headerView.segment.selectedSegmentIndex) {
        case 1:
        {
            if (indexPath.row == 0 && !string_is_empty(self.clubDetailInfo.intro)) {
                ClubIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubIntroCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (string_is_empty(self.clubDetailInfo.intro)) {
                    cell.introLabel.text = @"";
                }else {
                   cell.introLabel.attributedText = [[NSAttributedString alloc] initWithString:self.clubDetailInfo.intro attributes:@{NSParagraphStyleAttributeName : ({
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        paragraphStyle.lineSpacing = 3;
                        paragraphStyle;
                    })}]; 
                }
                
                return cell;
            }else {
                GroupMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ManagerCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"管理员";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell hideMoreButton];
                [cell.emptyView setHidden:YES];
                cell.memberArray = self.managerArray;
                [cell.collectionView reloadData];
                
                __weak typeof(self) wself = self;
                [cell tapMemberHandler:^(NSUInteger index) {
                    
                    SimpleUserInfoEntity *entity = [wself.managerArray objectAtIndex:index];
                    
                    PersonalHomePageViewController *controller = [[UIStoryboard personalCenterStoryboard] instantiateViewControllerWithIdentifier:@"PersonalHomePage"];
                    controller.userId = entity.id;
                    controller.isFocus = entity.is_focus;
                    controller.nickName = entity.nick_name;
                    controller.headImageUrl = entity.head_img_url;
                    controller.userInfo = (PersonalHomePageEntity *)entity;
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                    [wself presentViewController:nav animated:YES completion:nil];
                }];
                return cell;
            }
        }
            break;
        case 0:
        {
            if (self.recentArray.count > 0) {
                ActiveEntity *entity = [self.recentArray objectAtIndex:indexPath.row];
                
                RecentActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.nameLabel.text = entity.title;
                [cell.timeButton setTitle:[entity.b_time yearMonthDayPointString] forState:UIControlStateNormal];
                [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:thumbnail_url_with_view(entity.head_img_url, cell.backgroundImageView)] placeholderImage:placeholder_image];
                [cell setIsEnd:(entity.t_status == 4)];
                
                return cell;
            }else {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoDataCellIdentifier"];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.textLabel.textColor = color_with_hex(kColor_8e949b);
                cell.textLabel.text = @"暂无数据";
                return cell;
            }
            return nil;
        }
            break;
        case 2:
        {
            NewsEntity *entity = [self.pastArray objectAtIndex:indexPath.row];
            
            PastActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PastActiveCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.nameLabel.text = entity.title;
            cell.timeLabel.text = [entity.publish_time yearMonthDayPointString];
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:thumbnail_url_with_view(entity.h_img_url, cell.imgView)] placeholderImage:placeholder_image];
            
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.headerView.segment.selectedSegmentIndex == 0) {
        ActiveEntity *entity = self.recentArray[indexPath.row];
        ActiveDetailViewController *controller = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"ActiveDetail"];
        controller.activeId = entity.id;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
    }
    if (self.headerView.segment.selectedSegmentIndex == 2) {
        NewsEntity *entity = self.pastArray[indexPath.row];
        RecallDetailViewController *controller = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"RecallDetail"];
        controller.title = @"记忆详情";
        controller.newsInfo = entity;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
