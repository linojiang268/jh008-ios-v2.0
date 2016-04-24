//
//  ActiveSubViewController.m
//  Gather
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveSubViewController.h"
#import "ActiveSubViewTableViewCell.h"
#import "Network+Active.h"
#import "ActiveDetailViewController.h"

@interface ActiveSubViewController ()

@property (nonatomic, strong) NSMutableArray *activeArray;

@end

@implementation ActiveSubViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ((self.activeClassifyId > 0 || self.isHot) && self.activeArray.count == 0) {
        [self.tableView headerBeginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activeArray = [[NSMutableArray alloc] init];
    self.tableView.rowHeight = 210;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ActiveSubViewTableViewCell class]) bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    
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

- (void)requestInfo {
    
    if (self.tableView.footerRefreshing && self.currentPage != 0 && self.activeArray.count >= self.totalNumber) {
        [self.tableView footerEndRefreshing];
        return;
    }
    
    self.currentPage += 1;
    
    __weak typeof(self) wself = self;
    
    if (self.isHot) {
        [Network getHotActiveListWithCityId:[Common getCurrentCityId] page:self.currentPage size:kActiveSize success:^(ActiveListEntity *entity) {
            wself.totalNumber = entity.total_num;
            
            if (wself.currentPage == 1) {
                [wself.activeArray setArray:entity.acts];
                [wself.tableView headerEndRefreshing];
            }else {
                [wself.activeArray addObjectsFromArray:entity.acts];
                [wself.tableView footerEndRefreshing];
            }
            [wself.tableView reloadDataIfEmptyShowCueWordsView];
        } failure:^(NSString *errorMsg, StatusCode code) {
            [wself.tableView headerEndRefreshing];
            [wself.tableView footerEndRefreshing];
        }];
    }else {
        [Network getActiveListWithCityId:[Common getCurrentCityId] tagId:self.activeClassifyId keyWords:nil startTime:nil endTime:nil page:self.currentPage size:kActiveSize success:^(ActiveListEntity *entity) {
            wself.totalNumber = entity.total_num;
            
            if (wself.currentPage == 1) {
                [wself.activeArray setArray:entity.acts];
                [wself.tableView headerEndRefreshing];
            }else {
                [wself.activeArray addObjectsFromArray:entity.acts];
                [wself.tableView footerEndRefreshing];
            }
            [wself.tableView reloadDataIfEmptyShowCueWordsView];
        } failure:^(NSString *errorMsg, StatusCode code) {
            
            [wself.tableView headerEndRefreshing];
            [wself.tableView footerEndRefreshing];
        }];
    }
}


- (NSString *)distanceWithLon:(double)lon lat:(double)lat {
    
    CLLocationCoordinate2D coor = [Common getCurrentLocationCoordinate2D];
    CLLocation *orig = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    CLLocation* dist = [[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude];
    
    CLLocationDistance kilometers = [orig distanceFromLocation:dist] / 1000;
    
    return [NSString stringWithFormat:@"%.2f千米",kilometers];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActiveSubViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ActiveEntity *entity = self.activeArray[indexPath.row];
    
    [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:thumbnail_url(entity.head_img_url, CGRectGetWidth(cell.backgroundImageView.bounds), CGRectGetHeight(cell.backgroundImageView.bounds))] placeholderImage:placeholder_image];
    [cell.titleLabel setText:entity.title];
    [cell.subTitleLabel setText:entity.addr_road];
    [cell.distanceLabel setText:[self distanceWithLon:entity.lon lat:entity.lat]];
    [cell.startTimeLabel setText:[entity.b_time monthAndDayString]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ActiveEntity *entity = self.activeArray[indexPath.row];
    ActiveDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ActiveDetail"];
    controller.activeId = entity.id;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.parentVC presentViewController:nav animated:YES completion:nil];
}

@end
