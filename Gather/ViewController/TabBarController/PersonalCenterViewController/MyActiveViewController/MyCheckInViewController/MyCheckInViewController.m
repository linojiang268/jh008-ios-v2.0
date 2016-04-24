//
//  MyCheckInViewController.m
//  Gather
//
//  Created by apple on 15/2/2.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "MyCheckInViewController.h"
#import "ActiveDetailViewController.h"
#import "MyCheckInTableViewCell.h"
#import "Network+Active.h"

@interface MyCheckInViewController ()

@property (nonatomic, strong) NSMutableArray *infoArray;

@end

@implementation MyCheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.infoArray = [[NSMutableArray alloc] init];
    
    self.tableView.estimatedRowHeight = 58;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
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
    [self.tableView headerBeginRefreshing];
}
- (void)requestInfo {
    
    if (self.tableView.footerRefreshing && self.currentPage != 0 && self.infoArray.count >= self.totalNumber) {
        [self.tableView footerEndRefreshing];
        return;
    }
    
    self.currentPage += 1;
    
    __weak typeof(self) wself = self;
    [Network getMyCheckInActiveWithUserId:self.userId page:self.currentPage size:kSize success:^(MyCheckInActiveListEntity *entity) {
        wself.totalNumber = entity.total_num;
        
        if (wself.currentPage == 1) {
            [wself.infoArray setArray:entity.checkins];
            [wself.tableView headerEndRefreshing];
        }else {
            [wself.infoArray addObjectsFromArray:entity.checkins];
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
    
    MyCheckInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    MyApplyActiveEntity *entity = self.infoArray[indexPath.row];
    
    [cell.titleLabel setText:entity.act.title];
    [cell.timeLabel setText:[entity.create_time dateString]];
    [cell.isEndLabel setText:entity.act.statusString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyApplyActiveEntity *entity = self.infoArray[indexPath.row];
    ActiveDetailViewController *controller = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"ActiveDetail"];
    controller.activeId = entity.act_id;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.parentVC presentViewController:nav animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
