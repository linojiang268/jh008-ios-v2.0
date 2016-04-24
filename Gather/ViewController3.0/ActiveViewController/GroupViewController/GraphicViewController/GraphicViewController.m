//
//  GraphicViewController.m
//  Gather
//
//  Created by apple on 15/3/25.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "GraphicViewController.h"
#import "PersonalHomePageSubTitleTableViewCell.h"
#import "NavigationParkingSpaceViewController.h"
#import "ActiveConfigEntity.h"
#import "SitePlanViewController.h"
#import "RoadmapViewController.h"

@implementation GraphicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PersonalHomePageSubTitleTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"TitleCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonalHomePageSubTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell hideSubTitle];
    switch (indexPath.section) {
        case 0:
            [cell setTitle:@"位置导航及停车点"];
            break;
        case 1:
            [cell setTitle:@"场地平面图"];
            break;
        case 2:
            [cell setTitle:@"比赛路线图"];
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            if ([ActiveConfigEntity sharedConfig].show_more_addr != ActiveConfigStatusHasSet) {
                [SVProgressHUD showInfoWithStatus:kHintNoOpenString];
            }else {
                NavigationParkingSpaceViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationParkingSpace"];
                controller.activeId = self.activeId;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
        case 1:
        {
            if ([ActiveConfigEntity sharedConfig].show_place_img != ActiveConfigStatusHasSet) {
                [SVProgressHUD showInfoWithStatus:kHintNoOpenString];
            }else {
                SitePlanViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SitePlan"];
                controller.activeId = self.activeId;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
        case 2:
        {
            if ([ActiveConfigEntity sharedConfig].show_route_map != ActiveConfigStatusHasSet) {
                [SVProgressHUD showInfoWithStatus:kHintNoOpenString];
            }else {
                RoadmapViewController *controller = [[RoadmapViewController alloc] init];
                controller.activeId = self.activeId;
                controller.groupId = [ActiveMoreConfigEntity sharedMoreConfig].group_id;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
    }
}


@end
