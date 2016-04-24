//
//  SystemMessageViewController.m
//  Gather
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "SystemMessageTableViewCell.h"
#import "Network+SystemMessage.h"

@interface SystemMessageViewController ()

@property (nonatomic, strong) NSMutableArray *messageArray;

@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.messageArray = [[NSMutableArray alloc] init];
    self.tableView.estimatedRowHeight = 60;
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView headerBeginRefreshing];
}

- (void)requestInfo {
    
    if (self.tableView.footerRefreshing && self.currentPage != 0 && self.messageArray.count >= self.totalNumber) {
        [self.tableView footerEndRefreshing];
        return;
    }
    
    self.currentPage += 1;
    
    __weak typeof(self) wself = self;
    [Network getSystemMessageListWithPage:self.currentPage size:kSize success:^(SystemMessageListEntity *entity) {
        
        wself.totalNumber = entity.total_num;
        
        if (wself.currentPage == 1) {
            [wself.messageArray setArray:entity.system_msgs];
            [wself.tableView headerEndRefreshing];
        }else {
            [wself.messageArray addObjectsFromArray:entity.system_msgs];
            [wself.tableView footerEndRefreshing];
        }
        [wself.tableView reloadDataIfEmptyShowCueWordsView];
        
    } failure:^(NSString *errorMsg, StatusCode code) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    SystemMessageEntity *entity = self.messageArray[indexPath.row];
    
    [cell.contentLabel setText:entity.content];
    [cell.timeLabel setText:[entity.create_time dateString]];
    [cell hideRedPoint:entity.status];
    
    return cell;
}

@end
