//
//  MyApplyViewController.m
//  Gather
//
//  Created by apple on 15/2/2.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "MyApplyViewController.h"
#import "MyApplyTableViewCell.h"
#import "Network+Active.h"
#import "BarcodeViewController.h"
#import "ActiveDetailViewController.h"
#import "Network+Apply30.h"

@interface MyApplyViewController ()

@property (nonatomic, strong) NSMutableArray *infoArray;

@property (nonatomic, strong) BarcodeViewController *barcodeControlelr;

@end

@implementation MyApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.infoArray = [[NSMutableArray alloc] init];
    
    self.tableView.estimatedRowHeight = 118;
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
    
    if (__Gather_Version_Max == __Gather_2_0_2__) {
        [Network getMyApplyActiveHistoryWithUserId:self.userId page:self.currentPage size:kSize success:^(MyApplyActiveListEntity *entity) {
            wself.totalNumber = entity.total_num;
            
            if (wself.currentPage == 1) {
                [wself.infoArray setArray:entity.enrolls];
                [wself.tableView headerEndRefreshing];
            }else {
                [wself.infoArray addObjectsFromArray:entity.enrolls];
                [wself.tableView footerEndRefreshing];
            }
            [wself.tableView reloadDataIfEmptyShowCueWordsView];
        } failure:^(NSString *errorMsg, StatusCode code) {
            [wself.tableView headerEndRefreshing];
            [wself.tableView footerEndRefreshing];
        }];
    }else {
        [Network getMyApplyActiveWithUserId:self.userId page:self.currentPage size:kSize success:^(MyApplyActiveListEntity *entity) {
            wself.totalNumber = entity.total_num;
            
            if (wself.currentPage == 1) {
                [wself.infoArray setArray:entity.enrolls];
                [wself.tableView headerEndRefreshing];
            }else {
                [wself.infoArray addObjectsFromArray:entity.enrolls];
                [wself.tableView footerEndRefreshing];
            }
            [wself.tableView reloadDataIfEmptyShowCueWordsView];
        } failure:^(NSString *errorMsg, StatusCode code) {
            [wself.tableView headerEndRefreshing];
            [wself.tableView footerEndRefreshing];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    MyApplyActiveEntity *entity = self.infoArray[indexPath.row];
    
    [cell.titleLabel setText:entity.act.title];
    [cell.timeLabel setText:[entity.create_time dateString]];
    [cell.isEndLabel setText:entity.act.statusString];
    [cell.nameLabel setText:[NSString stringWithFormat:@"姓名：%@",entity.name]];
    [cell.phoneLabel setText:[NSString stringWithFormat:@"联系电话：%@",entity.phone]];
    if (__Gather_Version_Max == __Gather_2_0_2__) {
        [cell.numberLabel setText:[NSString stringWithFormat:@"报名人数：%d",(entity.with_people_num + 1)]];
    }else {
        [cell.numberLabel setText:[NSString stringWithFormat:@"报名人数：%d",entity.people_num]];
    }
    
    //[cell showCheckInButton:!entity.act.is_checkin];
    [cell showApplyInfo:(self.userId == [Common getCurrentUserId])];
    
    /*__weak typeof(self) wself = self;
    [cell checkInHandler:^{
        [wself checkIn];
    }];*/
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyApplyActiveEntity *entity = self.infoArray[indexPath.row];
    ActiveDetailViewController *controller = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"ActiveDetail"];
    controller.activeId = entity.act_id;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)checkIn {
    
    self.barcodeControlelr = [BarcodeViewController controllerWithCompleteHandler:^(NSString *result) {
        
        NSError *error;
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            alert(nil, @"签到失败");
            return;
        }
        
        if (dict && dict.count == 2 && [dict[@"value"] intValue] > 0) {
            NSUInteger activeId = [dict[@"value"] intValue];
            CLLocationCoordinate2D coor = [Common getCurrentLocationCoordinate2D];
            SHOW_LOAD_HUD;
            [Network activeCheckInWithActiveId:activeId lon:coor.longitude lat:coor.latitude address:[Common getCurrentFullAddress] success:^(id response) {
                [SVProgressHUD showSuccessWithStatus:@"签到成功"];
            } failure:^(NSString *errorMsg, StatusCode code) {
                [SVProgressHUD showErrorWithStatus:@"签到失败"];
            }];
        }else {
             alert(nil, @"签到失败");
        }
    }];
    self.barcodeControlelr.title = @"扫描二维码";
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.barcodeControlelr];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
