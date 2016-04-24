//
//  CityListViewController.m
//  Gather
//
//  Created by apple on 15/1/12.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "CityListViewController.h"
#import "Network+CityList.h"

@interface CityListViewController ()

@property (nonatomic, strong) NSArray *citysArray;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation CityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[Common getCacheCityList].cities count] > 0) {
        [self refreshView];
    }else {
        __weak typeof(self) wself = self;
        [Network getCityListWithSuccess:^(CityListEntity *entity) {
            [wself refreshView];
        }failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"获取城市信息失败"];
        }];
    }
    
    __weak typeof(self) wself = self;
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"确定" clickHandler:^(BlockBarButtonItem *item) {
        if (!wself.selectedIndexPath) {
            [SVProgressHUD showErrorWithStatus:@"请选择一个城市"];
        }else {
            
            if (!string_is_empty(wself.locationName)) {
                if (wself.selectedIndexPath.section == 0) {
                    [SVProgressHUD showErrorWithStatus:@"当前城市不支持"];
                    return;
                }
            }
            
            CityEntity *entity = wself.citysArray[wself.selectedIndexPath.row];
            
            [Common setCurrentCityId:@(entity.id)];
            [Common setCurrentCityName:entity.name];
            [[NSNotificationCenter defaultCenter] postNotificationName:kCHANGE_CITY_NOTIFICATION_NAME object:nil];
            [wself.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }]];
}

- (void)refreshView {
    self.citysArray = [NSArray arrayWithArray:[Common getCacheCityList].cities];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!string_is_empty(self.locationName)) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && !string_is_empty(self.locationName)) {
        return 1;
    }
    return self.citysArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        cell.tintColor = color_with_hex(kColor_ff9933);
    }
    if (indexPath.section == 0 && !string_is_empty(self.locationName)) {
        cell.textLabel.text = [NSString stringWithFormat:@"GPS定位城市 %@",self.locationName];
    }else {
        
        CityEntity *entity = self.citysArray[indexPath.row];
        
        cell.textLabel.text = entity.name;
        
        if (entity.id == [Common getCurrentCityId]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectedIndexPath = indexPath;
        }
    }
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
    if (cell) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedIndexPath = indexPath;
}

@end
