//
//  StrategyViewController.m
//  Gather
//
//  Created by apple on 15/1/30.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "RecallSubViewController.h"
#import "RecallSubViewTableViewCell.h"
#import "Network+News.h"
#import "RecallDetailViewController.h"

@interface RecallSubViewController ()

@property (nonatomic, strong) NSMutableArray *newsArray;

@end

@implementation RecallSubViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ((self.tagId > 0 || (self.isAll && self.newsType)) && self.newsArray.count == 0) {
        [self.tableView headerBeginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.newsArray = [[NSMutableArray alloc] init];

    self.tableView.estimatedRowHeight = 300;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RecallSubViewTableViewCell class]) bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    
    __weak typeof(self) wself = self;
    [self.tableView addHeaderWithCallback:^{
        [wself requestInfo];
    }];
}
- (void)requestInfo {
    
    if (self.currentPage != 0 && self.newsArray.count >= self.totalNumber) {
        [self.tableView headerEndRefreshing];
        return;
    }
    
    self.currentPage += 1;
    
    __weak typeof(self) wself = self;
    
    [Network getNewsListWithCityId:[Common getCurrentCityId] tagId:self.tagId typeId:self.newsType keyWords:nil page:self.currentPage size:kSize success:^(NewsListEntity *entity) {
        wself.totalNumber = entity.total_num;
        
        if (wself.currentPage == 1) {
            [wself.newsArray setArray:[[entity.news reverseObjectEnumerator] allObjects]];
            [wself.tableView headerEndRefreshing];
            [wself.tableView reloadDataIfEmptyShowCueWordsView];
            if (entity.total_num > 0) {
                [wself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:wself.newsArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
        }else {
            NSArray *oldArray = [NSArray arrayWithArray:wself.newsArray];
            [wself.newsArray removeAllObjects];
            [wself.newsArray setArray:[[entity.news reverseObjectEnumerator] allObjects]];
            [wself.newsArray addObjectsFromArray:oldArray];
            [wself.tableView headerEndRefreshing];
            [wself.tableView reloadDataIfEmptyShowCueWordsView];
        }
    } failure:^(NSString *errorMsg, StatusCode code) {
        [wself.tableView headerEndRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecallSubViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == (self.newsArray.count - 1)) {
        [cell.roundViewMarginBottom setConstant:15];
    }else {
        [cell.roundViewMarginBottom setConstant:0];
    }
    
    NewsEntity *entity = self.newsArray[indexPath.row];
    [cell.titleLabel setText:entity.title];
    [cell.timeLabel setText:[entity.publish_time dateString]];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:thumbnail_url(entity.h_img_url, CGRectGetWidth(cell.imgView.bounds), CGRectGetHeight(cell.imgView.bounds))] placeholderImage:placeholder_image];
    if (!string_is_empty(entity.intro)) {
        cell.footTitleLabelMarginBottom.constant = 10;
        [cell.footTitleLabel setText:entity.intro];
    }else {
        cell.footTitleLabel.text = @"";
        cell.footTitleLabelMarginBottom.constant = 0;
    }
    
    if (self.newsType == NewsTypeTicket) {
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",entity.price];
    }else {
        cell.priceLabel.text = @"";
        cell.priceLabel.hidden = YES;
    }
    
    [cell layoutIfNeeded];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsEntity *entity = self.newsArray[indexPath.row];
    RecallDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RecallDetail"];
    if (self.newsType == NewsTypeStrategy) {
        controller.title = @"攻略详情";
    }
    if (self.newsType == NewsTypeTicket) {
        controller.title = @"订购详情";
    }
    controller.newsInfo = entity;
    [self.parentVC.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
