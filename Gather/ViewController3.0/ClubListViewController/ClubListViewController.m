//
//  ClubListViewController.m
//  Gather
//
//  Created by apple on 15/4/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ClubListViewController.h"
#import "ClubViewController.h"
#import "ClubListCell.h"
#import "Network+Club.h"

@interface ClubListViewController ()

@property (nonatomic, strong) NSMutableArray *clubArray;

@end

@implementation ClubListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clubArray = [[NSMutableArray alloc] init];
    
    self.tableView.estimatedRowHeight = 90;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    __weak typeof(self) wself = self;
    [self.tableView addHeaderWithCallback:^{
        [wself setCurrentPage:0];
        [wself requestClubListInfo];
    }];
    [self.tableView addFooterWithCallback:^{
        [wself requestClubListInfo];
    }];
    [self.tableView headerBeginRefreshing];
}

- (void)requestClubListInfo {
    
    if (self.currentPage > 0 && self.clubArray.count >= self.totalNumber) {
        [self.tableView footerEndRefreshing];
        return;
    }
    self.currentPage += 1;
    
    __weak typeof(self) wself = self;
    [Network getClubListWithCityId:[Common getCurrentCityId] keyWords:self.searchkeyWords page:self.currentPage size:kSize success:^(ClubListEntity *entity) {
        if (wself.currentPage == 1) {
            [wself.clubArray setArray:entity.orgs];
            [wself.tableView headerEndRefreshing];
        }else {
            [wself.clubArray addObjectsFromArray:entity.orgs];
            [wself.tableView footerEndRefreshing];
        }
        [wself.tableView reloadDataIfEmptyShowCueWordsView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.clubArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClubListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ClubEntity *entity = [self.clubArray objectAtIndex:indexPath.row];
    
    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:entity.icon_url] placeholderImage:placeholder_image];
    cell.nameLabel.text = entity.subject;
    cell.fansLabel.text = [NSString stringWithFormat:@"%d",entity.lov_user_num];
    cell.activeNumberLabel.text = [NSString stringWithFormat:@"%d",entity.act_num];
    cell.isLoveImage.highlighted = (entity.is_loved == 1);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ClubEntity *entity = [self.clubArray objectAtIndex:indexPath.row];
    ClubViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Club"];
    controller.clubId = entity.id;
    [self.navigationController pushViewController:controller animated:YES];
}


@end
