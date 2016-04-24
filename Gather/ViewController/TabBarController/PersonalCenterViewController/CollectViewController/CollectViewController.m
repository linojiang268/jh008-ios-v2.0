//
//  CollectViewController.m
//  Gather
//
//  Created by apple on 15/1/31.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "CollectViewController.h"
#import "Network+News.h"
#import "SearchTableViewCell.h"
#import "RecallDetailViewController.h"

@interface CollectViewController ()

@property (nonatomic, strong) NSMutableArray *infoArray;

@end

@implementation CollectViewController

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
    
    [Network getCollectNewsListWithUserId:[Common getCurrentUserId] typeId:NewsTypeCollect page:self.currentPage size:kSize success:^(NewsListEntity *entity) {
        wself.totalNumber = entity.total_num;
        
        if (wself.currentPage == 1) {
            [wself.infoArray setArray:entity.news];
            [wself.tableView headerEndRefreshing];
        }else {
            [wself.infoArray addObjectsFromArray:entity.news];
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
    
    NewsEntity *entity = self.infoArray[indexPath.row];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:entity.h_img_url] placeholderImage:placeholder_image];
    [cell.titleLabel setText:entity.title];
    [cell.subTitleLabel setText:entity.intro];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsEntity *entity = self.infoArray[indexPath.row];
    RecallDetailViewController *controller = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"RecallDetail"];
    controller.newsInfo = entity;
    
    switch (entity.type_id) {
        case 1:
            controller.title = @"攻略详情";
            break;
        case 2:
            controller.title = @"记忆详情";
            break;
        case 3:
            controller.title = @"订购详情";
            break;
        default:
            controller.title = @"资讯详情";
            break;
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}


@end
