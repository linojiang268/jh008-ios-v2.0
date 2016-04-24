//
//  GroupViewController.m
//  Gather
//
//  Created by apple on 15/3/16.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "GroupViewController.h"
#import "GroupHeaderView.h"
#import "GroupCommentTableViewCell.h"
#import "GroupMemberTableViewCell.h"
#import "DXMessageToolBar.h"
#import "FlowViewController.h"
#import "GroupEmptyView.h"
#import "GroupFirstHeaderView.h"
#import "Network+Group.h"
#import "ActiveListEntity.h"
#import "Network+ActiveFlow.h"
#import "GraphicViewController.h"
#import "NoticeViewController.h"
#import "NSDate+Extend.h"
#import "PersonalHomePageViewController.h"
#import "ChatViewController.h"
#import "MemberViewController.h"
#import "ActiveGroupPhotoViewController.h"
#import "GroupCheckInStatusViewController.h"
#import "RoadmapViewController.h"

@interface GroupViewController ()<UITableViewDataSource,UITableViewDelegate,DXMessageToolBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GroupHeaderView *actionHeaderView;
@property (strong, nonatomic) DXMessageToolBar *chatToolBar;

@property (nonatomic, strong) NSMutableArray *memberArray;
@property (nonatomic, strong) NSMutableArray *administratorArray;
@property (nonatomic, strong) NSMutableArray *messageBoardArray;
@property (nonatomic, strong) ActiveConfigEntity *activeConfig;

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) int totalNumber;

@end

@implementation GroupViewController

- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], self.view.frame.size.width, [DXMessageToolBar defaultHeight])];
        _chatToolBar.maxTextInputViewHeight = 120;
        _chatToolBar.inputTextView.placeHolder = @"输入新留言";
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
    }
    
    return _chatToolBar;
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight {
    
}

- (void)didSendText:(NSString *)text {
    [self.chatToolBar endEditing:YES];
    if (self.totalNumber == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            
            CGRect rect = self.tableView.tableFooterView.frame;
            rect.origin.x = -CGRectGetWidth([[UIScreen mainScreen] bounds]);
            
            self.tableView.tableFooterView.frame = rect;
        } completion:^(BOOL finished) {
            self.tableView.tableFooterView = nil;
        }];
    }
    if (!string_is_empty(text)) {
        SHOW_LOAD_HUD;
        __weak typeof(self) wself = self;
        [Network sendMsg:self.activeId content:text success:^(id response) {
            DISMISS_HUD;
            
            GroupMessageBoardEntity *entity = [[GroupMessageBoardEntity alloc] init];
            entity.author_id = [Common getCurrentUserId];
            entity.is_admin = [ActiveMoreConfigEntity sharedMoreConfig].is_manager;
            entity.content = text;
            entity.create_time = [NSDate dateString];
            
            SimpleUserInfoEntity *user = [[SimpleUserInfoEntity alloc] init];
            user.nick_name = [Common getSelfUserInfo].nick_name;
            user.head_img_url = [Common getSelfUserInfo].head_img_url;
            entity.user = user;
            
            [wself.chatToolBar clearText];
            [wself.messageBoardArray addObject:entity];
            [wself.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[wself.tableView numberOfRowsInSection:1] inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            [wself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:wself.messageBoardArray.count inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"留言失败"];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addCustomNavigationBar];
    self.tableView.backgroundColor = color_with_hex(kColor_f8f8f8);
    
    self.memberArray = [[NSMutableArray alloc] init];
    self.administratorArray = [[NSMutableArray alloc] init];
    self.messageBoardArray = [[NSMutableArray alloc] init];
    
    __weak typeof(self) wself = self;
    [self.customNavigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"签到" clickHandler:^(BlockBarButtonItem *item) {
        
        ActiveConfigEntity *config = [ActiveConfigEntity sharedConfig];
        ActiveMoreConfigEntity *moreConfig = [ActiveMoreConfigEntity sharedMoreConfig];
        if (config.show_enroll == ActiveConfigStatusHasSet && moreConfig.enroll_status == 3) {
            GroupCheckInStatusViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"GroupCheckIn"];
            controller.activeInfo = wself.activeDetail;
            [wself.navigationController pushViewController:controller animated:YES];
        }else if (config.show_enroll != ActiveConfigStatusHasSet) {
            [SVProgressHUD showInfoWithStatus:kHintNoOpenString];
        }else if ([ActiveMoreConfigEntity sharedMoreConfig].enroll_status <= 0) {
            [SVProgressHUD showInfoWithStatus:@"您还未报名活动"];
        }else if ([ActiveMoreConfigEntity sharedMoreConfig].enroll_status == 1) {
            [SVProgressHUD showInfoWithStatus:@"报名待审核"];
        }else if ([ActiveMoreConfigEntity sharedMoreConfig].enroll_status == 2) {
            [SVProgressHUD showInfoWithStatus:@"报名审核中"];
        }else if ([ActiveMoreConfigEntity sharedMoreConfig].enroll_status == 4) {
            [SVProgressHUD showInfoWithStatus:@"报名被拒绝"];
        }
    }]];
    
    self.actionHeaderView = [[GroupHeaderView alloc] init];
    /*[self.actionHeaderView.flowButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
        FlowViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"Flow"];
        controller.activeId = wself.activeId;
        [wself.navigationController pushViewController:controller animated:YES];
    }];
    [self.actionHeaderView.graphicButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
        GraphicViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"Graphic"];
        controller.activeId = wself.activeId;
        [wself.navigationController pushViewController:controller animated:YES];
    }];
    [self.actionHeaderView.noticeButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
        if ([ActiveConfigEntity sharedConfig].show_notice == ActiveConfigStatusHasSet) {
            NoticeViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"Notice"];
            controller.activeId = wself.activeId;
            [wself.navigationController pushViewController:controller animated:YES];
        }else {
            [SVProgressHUD showInfoWithStatus:kHintNoOpenString];
        }
    }];*/
    [self.actionHeaderView.roadmapButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
        if ([ActiveConfigEntity sharedConfig].show_route_map != ActiveConfigStatusHasSet) {
            [SVProgressHUD showInfoWithStatus:kHintNoOpenString];
        }else {
            RoadmapViewController *controller = [[RoadmapViewController alloc] init];
            controller.activeId = wself.activeId;
            controller.groupId = [ActiveMoreConfigEntity sharedMoreConfig].group_id;
            [wself.navigationController pushViewController:controller animated:YES];
        }
    }];
    [self.actionHeaderView.photoButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
        if ([ActiveConfigEntity sharedConfig].show_album == ActiveConfigStatusHasSet) {
            ActiveGroupPhotoViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"ActivePhoto"];
            controller.activeId = wself.activeId;
            [wself.navigationController pushViewController:controller animated:YES];
        }else {
            [SVProgressHUD showInfoWithStatus:kHintNoOpenString];
        }
    }];
    
    self.tableView.estimatedRowHeight = 51;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = [GroupFirstHeaderView viewWithTitle:self.activeDetail.title time:[self.activeDetail.b_time monthAndDayString]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GroupMemberTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"MemberCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GroupCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    [self requestMember];
    [self requestAdministrator];
    [self requestActiveFlow];
    
    if ([ActiveConfigEntity sharedConfig].show_message == ActiveConfigStatusHasSet) {
        [self.view addSubview:self.chatToolBar];
        [self requestComment];
        [self.tableView addFooterWithCallback:^{
            [wself requestComment];
        }];
    }
}

- (void)requestActiveFlow {
    [Network getActiveFlowListWithActiveId:self.activeId cityId:[Common getCurrentCityId] page:1 size:kActiveGroupSize success:^(ActiveFlowListEntity *entity) {
        
    } failure:^(NSString *errorMsg, StatusCode code) {
        
    }];
}

- (void)requestMember {
    __weak typeof(self) wself = self;
    [Network getMemberListWithActiveId:self.activeId cityId:[Common getCurrentCityId] page:1 size:4 success:^(FriendListEntity *entity) {
        if (entity.users.count > 0) {
            [wself.memberArray setArray:entity.users];
        }
        [wself.tableView reloadData];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"成员获取失败"];
    }];
}

- (void)requestAdministrator {
    
    if ([ActiveConfigEntity sharedConfig].show_manager == ActiveConfigStatusHasSet) {
        __weak typeof(self) wself = self;
        [Network getAdministratorListWithActiveId:self.activeId cityId:[Common getCurrentCityId] page:1 size:4 success:^(FriendListEntity *entity) {
            if (entity.users.count > 0) {
                [wself.administratorArray setArray:entity.users];
            }
            [wself.tableView reloadData];
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"管理员获取失败"];
        }];
    }
}

- (void)requestComment {
    
    if (self.currentPage > 0 && self.messageBoardArray.count >= self.totalNumber) {
        [self.tableView footerEndRefreshing];
        return;
    }
    self.currentPage += 1;
    __weak typeof(self) wself = self;
    [Network getMessageBoardListWithActiveId:self.activeId page:self.currentPage size:kSize success:^(GroupMessageBoardListEntity *entity) {
        
        wself.totalNumber = entity.total_num;
        [wself.messageBoardArray addObjectsFromArray:entity.messages];
        [wself.tableView reloadData];
        
        if (entity.total_num <= 0) {
            wself.tableView.tableFooterView = [GroupEmptyView viewWithTitle:@"还没有人抢沙发"];
        }
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"获取留言信息失败"];
        [self.tableView footerEndRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.administratorArray.count > 0) {
            return 2;
        }
        return 1;
    }
    if ([ActiveConfigEntity sharedConfig].show_message == ActiveConfigStatusHasSet) {
        if (self.messageBoardArray.count > 0) {
            return self.messageBoardArray.count+1;
        }else {
            return 1;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 100;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.actionHeaderView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            GroupMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"活动成员";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.memberArray.count > 0) {
                cell.emptyView.hidden = YES;
                
                if ([ActiveMoreConfigEntity sharedMoreConfig].enroll_status == 3) {
                    NSMutableArray *tempArray = [NSMutableArray array];
                    for (SimpleUserInfoEntity *user in self.memberArray) {
                        if (user.id == [Common getCurrentUserId]) {
                            [tempArray addObject:user];
                            [self.memberArray removeObject:user];
                            break;
                        }
                    }
                    [tempArray addObjectsFromArray:self.memberArray];
                    cell.memberArray = tempArray;
                    [self.memberArray setArray:tempArray];
                }else {
                    cell.memberArray = self.memberArray;
                }
                
                [cell.collectionView reloadData];
                [cell setNeedsLayout];
                __weak typeof(self) wself = self;
                [cell.seeMoreButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
                    
                    MemberViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"Member"];
                    controller.activeId = wself.activeId;
                    [wself.navigationController pushViewController:controller animated:YES];
                }];
                [cell tapMemberHandler:^(NSUInteger index) {
                    
                    SimpleUserInfoEntity *entity = [wself.memberArray objectAtIndex:index];
                    
                    PersonalHomePageViewController *controller = [[UIStoryboard personalCenterStoryboard] instantiateViewControllerWithIdentifier:@"PersonalHomePage"];
                    controller.userId = entity.id;
                    controller.isFocus = entity.is_focus;
                    controller.nickName = entity.nick_name;
                    controller.headImageUrl = entity.head_img_url;
                    controller.userInfo = (PersonalHomePageEntity *)entity;
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                    [wself presentViewController:nav animated:YES completion:NO];
                }];
            }else {
                cell.emptyView.hidden = NO;
            }
            
            return cell;
        }else {
            GroupMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"管理员";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell hideMoreButton];
            [cell.emptyView setHidden:YES];
            cell.memberArray = self.administratorArray;
            [cell.collectionView reloadData];
            
            __weak typeof(self) wself = self;
            [cell tapMemberHandler:^(NSUInteger index) {
                
                SimpleUserInfoEntity *entity = [wself.administratorArray objectAtIndex:index];
                
                ChatViewController *controller = [[UIStoryboard messageStoryboard] instantiateViewControllerWithIdentifier:@"Chat"];
                controller.contactId = entity.id;
                controller.isShield = entity.status;
                controller.nickName = entity.nick_name;
                controller.headImageUrl = entity.head_img_url;
                controller.baidu_user_id = entity.baidu_user_id;
                controller.baidu_channel_id = entity.baidu_channel_id;
                controller.last_login_platform = entity.last_login_platform;
                [wself.navigationController pushViewController:controller animated:YES];
            }];
            return cell;
        }
    }

    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            round_button([cell.contentView viewWithTag:88],round_button_default_color);
            [(UIButton *)[cell.contentView viewWithTag:88] addEvent:UIControlEventTouchUpInside handler:^(id sender) {
                log_value(@"see more");
            }];
            
            return cell;
        }else {
            GroupCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
            
            GroupMessageBoardEntity *entity = [self.messageBoardArray objectAtIndex:indexPath.row-1];
            
            UIColor *nameColor = color_with_hex(kColor_6e7378);
            UIColor *contentColor = color_with_hex(kColor_8e949b);
            if (entity.is_admin == 1) {
                nameColor = color_with_hex(kColor_ff9933);
                contentColor = color_with_hex(kColor_ff9933);
            }
            
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",entity.user.nick_name] attributes:@{NSForegroundColorAttributeName: nameColor}];
            [content appendAttributedString:[[NSAttributedString alloc] initWithString:entity.content attributes:@{NSForegroundColorAttributeName: contentColor}]];
            
            cell.contentLabel.attributedText = content;
            cell.timeLabel.text = [entity.create_time dateString];
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:entity.user.head_img_url]];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    return nil;
}
 


@end
