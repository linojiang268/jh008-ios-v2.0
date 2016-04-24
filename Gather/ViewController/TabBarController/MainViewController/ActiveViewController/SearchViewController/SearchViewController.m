//
//  SearchViewController.m
//  Gather
//
//  Created by apple on 15/1/31.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "MJRefresh.h"
#import "Network+Active.h"
#import "Network+News.h"
#import "ActiveDetailViewController.h"
#import "RecallDetailViewController.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *textBackgroundView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *infoArray;

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger totalNumber;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = color_with_hex(kColor_f8f8f8);
    self.tableView.backgroundColor = color_with_hex(kColor_f8f8f8);
    self.textBackgroundView.backgroundColor = color_white;
    self.textField.backgroundColor = color_white;
    self.textBackgroundView.layer.borderWidth = 0.5;
    self.textBackgroundView.layer.borderColor = [color_with_hex(kColor_c9c9c9) CGColor];
    
    self.infoArray = [[NSMutableArray alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchTableViewCell class]) bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    
    __weak typeof(self) wself = self;
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"确认" clickHandler:^(BlockBarButtonItem *item) {
        [wself.textField resignFirstResponder];
        [wself search];
    }]];
    
    [self.tableView addFooterWithCallback:^{
        [wself loadMore];
    }];
    [self.tableView setFooterHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)search {
    
    if (string_is_empty(self.textField.text)) {
        alert(nil, @"请输入关键字");
        return;
    }
    
    self.currentPage = 1;
    
    SHOW_LOAD_HUD;
    __weak typeof(self) wself = self;
    if (self.searchType == SearchTypeActive) {
        
        [Network getActiveListWithCityId:[Common getCurrentCityId] tagId:0 keyWords:self.textField.text startTime:nil endTime:nil page:self.currentPage size:kSize success:^(ActiveListEntity *entity) {
            if (entity.total_num <=0 || entity.acts.count <= 0) {
                [SVProgressHUD showInfoWithStatus:@"没有相关信息噢，换个关键字试试吧"];
            }else {
                DISMISS_HUD;
                [wself.infoArray setArray:entity.acts];
                [wself.tableView reloadData];
                [self.tableView setFooterHidden:NO];
            }
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"搜索失败"];
        }];
    }else if (self.searchType == SearchTypeNews) {
        [Network getNewsListWithCityId:[Common getCurrentCityId] tagId:0 typeId:self.newsType keyWords:self.textField.text page:self.currentPage size:kSize success:^(NewsListEntity *entity) {

            
            if (entity.total_num <=0 || entity.news.count <= 0) {
                [SVProgressHUD showInfoWithStatus:@"没有相关信息噢，换个关键字试试吧"];
            }else {
                DISMISS_HUD;
                [wself.infoArray setArray:entity.news];
                [wself.tableView reloadData];
                [self.tableView setFooterHidden:NO];
            }
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"搜索失败"];
        }];
    }
}

- (void)loadMore {
    if (self.tableView.footerRefreshing && self.currentPage != 0 && self.infoArray.count >= self.totalNumber) {
        [self.tableView footerEndRefreshing];
        return;
    }
    
    self.currentPage += 1;
    
    __weak typeof(self) wself = self;
    if (self.searchType == SearchTypeActive) {
        
        [Network getActiveListWithCityId:[Common getCurrentCityId] tagId:0 keyWords:self.textField.text startTime:nil endTime:nil page:self.currentPage size:kSize success:^(ActiveListEntity *entity) {
            [wself.infoArray addObjectsFromArray:entity.acts];
            [wself.tableView footerEndRefreshing];
            [wself.tableView reloadData];
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        }];
    }else if (self.searchType == SearchTypeNews) {
        [Network getNewsListWithCityId:[Common getCurrentCityId] tagId:0 typeId:self.newsType keyWords:self.textField.text page:self.currentPage size:kSize success:^(NewsListEntity *entity) {
            [wself.infoArray addObjectsFromArray:entity.news];
            [wself.tableView footerEndRefreshing];
            [wself.tableView reloadData];
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if (self.searchType == SearchTypeActive) {
        
        ActiveEntity *entity = self.infoArray[indexPath.row];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:entity.head_img_url] placeholderImage:placeholder_image];
        [cell.titleLabel setText:entity.title];
        [cell.subTitleLabel setText:entity.intro];
    }else if (self.searchType == SearchTypeNews) {
        NewsEntity *entity = self.infoArray[indexPath.row];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:entity.h_img_url] placeholderImage:placeholder_image];
        [cell.titleLabel setText:entity.title];
        [cell.subTitleLabel setText:entity.intro];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.searchType == SearchTypeActive) {
        
        ActiveEntity *entity = self.infoArray[indexPath.row];
        ActiveDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ActiveDetail"];
        controller.activeId = entity.id;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
    }else if (self.searchType == SearchTypeNews) {
        NewsEntity *entity = self.infoArray[indexPath.row];
        RecallDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RecallDetail"];
        controller.newsInfo = entity;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
