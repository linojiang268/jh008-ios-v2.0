//
//  MyFoucsViewController.m
//  Gather
//
//  Created by apple on 15/2/2.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "MyFocusActiveViewController.h"
#import "Network+Active.h"
#import "SearchTableViewCell.h"
#import "RecallDetailViewController.h"
#import "ActiveDetailViewController.h"

@interface MyFocusActiveViewController ()

@property (nonatomic, strong) NSMutableArray *infoArray;

@end

@implementation MyFocusActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infoArray = [[NSMutableArray alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchTableViewCell class]) bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    
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
    
    [Network getMyFocusActiveWithUserId:self.userId page:self.currentPage size:kSize success:^(ActiveListEntity *entity) {
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
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ActiveEntity *entity = self.infoArray[indexPath.row];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:entity.head_img_url] placeholderImage:placeholder_image];
    [cell.titleLabel setText:entity.title];
    [cell.subTitleLabel setText:entity.intro];
    
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
