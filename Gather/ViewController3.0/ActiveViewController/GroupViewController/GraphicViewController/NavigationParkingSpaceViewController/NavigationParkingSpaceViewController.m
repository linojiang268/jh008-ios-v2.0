//
//  NavigationParkingSpaceViewController.m
//  Gather
//
//  Created by apple on 15/3/25.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "NavigationParkingSpaceViewController.h"
#import "NavigationParkingSpaceCell.h"
#import "NavigationParkingSpaceHeaderView.h"
#import "Network+Graphic.h"
#import "ParkingSpaceMapViewController.h"

@interface NavigationParkingSpaceViewController ()

@property (nonatomic, strong) AddressParkingSpaceListEntity *addressInfo;

@end

@implementation NavigationParkingSpaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 175;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableHeaderView = [[NavigationParkingSpaceHeaderView alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self requestMenuInfo];
}

- (void)requestMenuInfo {
    SHOW_LOAD_HUD;
    __weak typeof(self) wself = self;
    [Network getAddressParkingSpaceListWithActiveId:self.activeId page:1 size:kActiveGroupSize success:^(AddressParkingSpaceListEntity *entity) {
        DISMISS_HUD;
        wself.addressInfo = entity;
        [wself.tableView reloadDataIfEmptyShowCueWordsView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"地址信息获取失败"];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.addressInfo.act_addrs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NavigationParkingSpaceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    AddressParkingSpaceEntity *entity = [self.addressInfo.act_addrs objectAtIndex:indexPath.section];
    
    cell.titleLabel.text = entity.addr_name;
    cell.subTitleLabel.text = [NSString stringWithFormat:@"%@%@%@%@",entity.addr_city,entity.addr_area,entity.addr_road,entity.addr_num];
    
    NSMutableString *urlString = [NSMutableString stringWithString:@"http://api.map.baidu.com/staticimage?"];
    [urlString appendFormat:@"copyright=1"];
    [urlString appendFormat:@"&dpiType=ph"];
    [urlString appendFormat:@"&width=%f",CGRectGetWidth(cell.mapImageView.bounds)];
    [urlString appendFormat:@"&height=%f",CGRectGetHeight(cell.mapImageView.bounds)];
    [urlString appendFormat:@"&center=%f,%f",entity.lon,entity.lat];
    [urlString appendFormat:@"&zoom=15"];
    [urlString appendFormat:@"&scale=2"];
    [urlString appendFormat:@"&markers=%f,%f",entity.lon,entity.lat];
    for (int i = 0;i < entity.parking_spaces.count; i++) {
        
        ParkingSpaceEntity *parking = [entity.parking_spaces objectAtIndex:i];
        [urlString appendFormat:@"|%f,%f",parking.lon,parking.lat];
    }
    [urlString appendFormat:@"&markerStyles=-1,http://jhla-app-icons.oss-cn-qingdao.aliyuncs.com/ic_location.png"];
    for (int i = 0;i < entity.parking_spaces.count; i++) {
        [urlString appendFormat:@"|-1,%@",@"http://jhla-app-icons.oss-cn-qingdao.aliyuncs.com/ic_location_parking.png"];
    }
    [cell.mapImageView sd_setImageWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ParkingSpaceMapViewController *controller = [[ParkingSpaceMapViewController alloc] init];
    controller.addressEntity = [self.addressInfo.act_addrs objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
