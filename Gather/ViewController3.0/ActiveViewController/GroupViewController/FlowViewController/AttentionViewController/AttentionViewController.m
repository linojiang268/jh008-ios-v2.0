//
//  AttentionViewController.m
//  Gather
//
//  Created by apple on 15/3/25.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "AttentionViewController.h"
#import "Network+ActiveFlow.h"
#import "AttentionTableViewCell.h"


@interface AttentionViewController ()

@property (nonatomic, strong) AttentionListEntity *attentionInfo;

@end

@implementation AttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self requestMenuInfo];
}

- (void)requestMenuInfo {
    SHOW_LOAD_HUD;
    __weak typeof(self) wself = self;
    [Network getActiveAttentineListWithActiveId:self.activeId page:1 size:kActiveGroupSize success:^(AttentionListEntity *entity) {
        DISMISS_HUD;
        wself.attentionInfo = entity;
        [wself.tableView reloadDataIfEmptyShowCueWordsView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"信息获取失败"];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.attentionInfo.act_attentions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    AttentionEntity *entity = [self.attentionInfo.act_attentions objectAtIndex:indexPath.row];
    cell.titleLabel.text = entity.subject;
    
    return cell;
}



@end
