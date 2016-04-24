//
//  FlowMenuViewController.m
//  Gather
//
//  Created by apple on 15/3/24.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "FlowMenuViewController.h"
#import "FlowMenuCell.h"
#import "FlowMenuTitleCell.h"
#import "Network+ActiveFlow.h"

@interface FlowMenuViewController ()

@property (nonatomic,strong) BanquetMenuListEntity *lunchInfo;
@property (nonatomic,strong) BanquetMenuListEntity *dinnerInfo;

@end

@implementation FlowMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self requestMenuInfo];
}

- (void)requestMenuInfo {
    SHOW_LOAD_HUD;
    __weak typeof(self) wself = self;
    [Network getBanquetMenuListWithActiveId:self.activeId type:MenuTypeLunch page:1 size:kActiveGroupSize success:^(BanquetMenuListEntity *entity) {
        wself.lunchInfo = entity;
        [Network getBanquetMenuListWithActiveId:self.activeId type:MenuTypeDinner page:1 size:kActiveGroupSize success:^(BanquetMenuListEntity *entity) {
            DISMISS_HUD;
            wself.dinnerInfo = entity;
            [wself.tableView reloadDataIfEmptyShowCueWordsView];
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"菜单信息获取失败"];
            [wself.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"菜单信息获取失败"];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSUInteger count = 0;
    if (self.lunchInfo.act_menus.count > 0) {
        count += 1;
    }
    if (self.dinnerInfo.act_menus.count > 0) {
        count += 1;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && self.lunchInfo.act_menus.count > 0) {
        return self.lunchInfo.act_menus.count+1;
    }
    return self.dinnerInfo.act_menus.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        FlowMenuTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 0 && self.lunchInfo.act_menus.count > 0) {
            cell.titleLabel.text = @"午宴菜单";
            cell.subTitleLabel.text = @"";
        }else {
            cell.titleLabel.text = @"晚宴菜单";
            cell.subTitleLabel.text = @"";
        }
        
        return cell;
    }
    
    BanquetMenuEntity *entity = nil;
    
    if (indexPath.section == 0 && self.lunchInfo.act_menus.count > 0) {
        entity = [self.lunchInfo.act_menus objectAtIndex:indexPath.row - 1];
    }else {
        entity = [self.dinnerInfo.act_menus objectAtIndex:indexPath.row - 1];
    }
    
    FlowMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (entity) {
        cell.titleLabel.text = entity.subject;
    }
    
    return cell;
}



@end
