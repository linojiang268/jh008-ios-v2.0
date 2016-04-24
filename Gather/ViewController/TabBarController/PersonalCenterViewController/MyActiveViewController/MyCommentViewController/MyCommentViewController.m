//
//  MyCommentViewController.m
//  Gather
//
//  Created by apple on 15/2/2.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "MyCommentViewController.h"
#import "MyCommentTableViewCell.h"
#import "ActiveDetailViewController.h"
#import "Network+Active.h"

@interface MyCommentViewController ()

@property (nonatomic, strong) NSMutableArray *infoArray;

@end

@implementation MyCommentViewController

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
    [Network getMyCommentActiveWithUserId:self.userId page:self.currentPage size:kSize success:^(ActiveListEntity *entity) {
        wself.totalNumber = entity.total_num;
        
        if (wself.currentPage == 1) {
            [wself.infoArray setArray:entity.acts];
            [wself.tableView headerEndRefreshing];
        }else {
            [wself.infoArray addObjectsFromArray:entity.acts];
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
    
    MyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    ActiveEntity *entity = self.infoArray[indexPath.row];
    
    [cell.titleLabel setText:entity.title];
    [cell.isEndLabel setText:entity.statusString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ActiveEntity *entity = self.infoArray[indexPath.row];
    ActiveDetailViewController *controller = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"ActiveDetail"];
    controller.activeId = entity.id;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.parentVC presentViewController:nav animated:YES completion:nil];
}


@end
