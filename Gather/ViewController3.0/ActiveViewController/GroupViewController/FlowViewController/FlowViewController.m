//
//  FlowViewController.m
//  Gather
//
//  Created by apple on 15/3/18.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "FlowViewController.h"
#import "FlowFirstCell.h"
#import "MomentTableViewCell.h"
#import "PersonalHomePageSubTitleTableViewCell.h"
#import "ActiveConfigEntity.h"
#import "FlowMenuViewController.h"
#import "Network+ActiveFlow.h"
#import "AttentionViewController.h"

@interface FlowViewController ()

@property (nonatomic, strong) ActiveFlowListEntity *flowInfo;
@property (nonatomic, assign) BOOL isExpand;

@end

@implementation FlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.flowInfo = [ActiveFlowListEntity sharedActiveFlow];
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MomentTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"MomentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PersonalHomePageSubTitleTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"TitleCell"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __weak typeof(self) wself = self;
    if ([ActiveConfigEntity sharedConfig].show_process == ActiveConfigStatusHasSet && ![ActiveFlowListEntity sharedActiveFlow]) {
        SHOW_LOAD_HUD;
        [Network getActiveFlowListWithActiveId:self.activeId cityId:[Common getCurrentCityId] page:1 size:kActiveGroupSize success:^(ActiveFlowListEntity *entity) {
            DISMISS_HUD;
            wself.flowInfo = entity;
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"流程信息获取失败"];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.isExpand) {
            return self.flowInfo.act_process.count+2;
        }
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            PersonalHomePageSubTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell hideSubTitle];
            [cell setTitle:@"活动流程"];
            return cell;
        }else {
            
            if (indexPath.row == 1) {
                
                FlowFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlowFirstCell" forIndexPath:indexPath];
                
                return cell;
            }else {
                MomentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MomentCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell hideBottomLineView:NO];
                if (indexPath.row == (self.flowInfo.act_process.count+1)) {
                    [cell hideBottomLineView:YES];
                }
                
                ActiveFlowEntity *entity = [self.flowInfo.act_process objectAtIndex:(indexPath.row - 2)];
                
                cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@",entity.b_time,entity.e_time];
                cell.projectLabel.text = entity.subject;
                [cell setStatus:entity.status];
                
                
                return cell;
            }
        }
    }else {
        PersonalHomePageSubTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell hideSubTitle];
        switch (indexPath.section) {
            case 1:
                [cell setTitle:@"菜单"];
                break;
            case 2:
                [cell setTitle:@"注意事项"];
                break;
            case 3:
                [cell setTitle:@"主办方介绍"];
                break;
            default:
                break;
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            if ([ActiveConfigEntity sharedConfig].show_process == ActiveConfigStatusHasSet && ![ActiveFlowListEntity sharedActiveFlow]) {
                [SVProgressHUD showErrorWithStatus:@"流程信息获取失败"];
            }else {
                if (indexPath.row == 0) {
                    
                    if ([ActiveConfigEntity sharedConfig].show_process == ActiveConfigStatusHasSet && self.flowInfo.act_process.count > 0) {
                        self.isExpand = !self.isExpand;
                        
                        NSMutableArray *rows = [NSMutableArray array];
                        for (int i = 1; i <= self.flowInfo.act_process.count+1; i++) {
                            [rows addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                        }
                        [self.tableView beginUpdates];
                        if (self.isExpand) {
                            [self.tableView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationFade];
                        }else {
                            [self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationFade];
                        }
                        [self.tableView endUpdates];
                    }else {
                        [SVProgressHUD showInfoWithStatus:kHintNoOpenString];
                    }
                }
            }
        }
            break;
        case 1:
        {
            if ([ActiveConfigEntity sharedConfig].show_menu != ActiveConfigStatusHasSet) {
                [SVProgressHUD showInfoWithStatus:kHintNoOpenString];
            }else {
                FlowMenuViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FlowMenu"];
                controller.activeId = self.activeId;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
        case 2:
        {
            if ([ActiveConfigEntity sharedConfig].show_attention != ActiveConfigStatusHasSet) {
                [SVProgressHUD showInfoWithStatus:kHintNoOpenString];
            }else {
                AttentionViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Attention"];
                controller.activeId = self.activeId;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
        case 3:
        {
            if ([ActiveConfigEntity sharedConfig].show_busi != ActiveConfigStatusHasSet) {
                [SVProgressHUD showInfoWithStatus:kHintNoOpenString];
            }else {
                UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SponsorIntroduce"];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
    }
}

@end
