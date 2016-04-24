//
//  SitePlanViewController.m
//  Gather
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "SitePlanViewController.h"
#import "SitePlanTableViewCell.h"
#import "Network+Graphic.h"

@interface SitePlanViewController ()

@property (nonatomic, strong) SitePlanListEntty *sitePlanInfo;

@end

@implementation SitePlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 170;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self requestSitePlanInfo];
}

- (void)requestSitePlanInfo {
    SHOW_LOAD_HUD;
    __weak typeof(self) wself = self;
    [Network getSitePlanListWithActiveId:self.activeId page:1 size:kActiveGroupSize success:^(SitePlanListEntty *entity) {
        DISMISS_HUD;
        wself.sitePlanInfo = entity;
        [wself.tableView reloadDataIfEmptyShowCueWordsView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"获取失败"];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sitePlanInfo.place_imgs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SitePlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    SitePlanEntty *entity = [self.sitePlanInfo.place_imgs objectAtIndex:indexPath.section];
    
    cell.titleLabel.text = entity.subject;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:entity.img_url]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SitePlanTableViewCell *cell = (SitePlanTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    [self.sitePlanInfo.place_imgs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        SitePlanEntty *entity = obj;
        [urls addObject:entity.img_url];
    }];
    
    IDMPhotoBrowser *controller = [IDMPhotoBrowser controllerWithPhotoURLs:urls animatedFromView:cell.imgView];
    [controller setInitialPageIndex:indexPath.section];
    
    [self presentViewController:controller animated:YES completion:nil];
}


@end
