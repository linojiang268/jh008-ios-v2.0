//
//  ActiveCommentViewController.m
//  Gather
//
//  Created by apple on 15/1/29.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveCommentViewController.h"
#import "ActiveCommentTableViewCell.h"
#import "Network+Active.h"
#import "PublishActiveComentViewController.h"

@interface ActiveCommentViewController ()

@property (nonatomic, strong) NSMutableArray *commentArray;

@end

@implementation ActiveCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentArray = [[NSMutableArray alloc] init];
    
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ActiveCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"ActiveCommentCell"];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    __weak typeof(self) wself = self;
    [self.navigationItem addLeftItem:[[BlockBarButtonItem alloc] initWithImage:image_with_name(@"btn_back_yellow") highlight:nil clickHandler:^(BlockBarButtonItem *item){
        [wself dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"发表评论" clickHandler:^(BlockBarButtonItem *item) {
        
        PublishActiveComentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PublishActiveComment"];
        controller.activeId = wself.activeId;
        [wself.navigationController pushViewController:controller animated:YES];
    }]];
    
    [self.tableView addHeaderWithCallback:^{
        wself.currentPage = 0;
        [wself requestInfo];
    }];
    [self.tableView addFooterWithCallback:^{
        [wself requestInfo];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.activeId) {
        [self.tableView headerBeginRefreshing];
    }
}

- (void)requestInfo {
    self.currentPage += 1;
    __weak typeof(self) wself = self;
    [Network getCommentWithActiveId:self.activeId page:self.currentPage size:kSize success:^(ActiveCommentListEntity *entity) {
        wself.totalNumber = entity.total_num;
        if (wself.currentPage == 1) {
            [wself.commentArray removeAllObjects];
            [wself.commentArray setArray:entity.comments];
        }else {
            [wself.commentArray addObjectsFromArray:entity.comments];
        }
        
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [wself.tableView reloadDataIfEmptyShowCueWordsView];
        DISMISS_HUD;
    } failure:^(NSString *errorMsg, StatusCode code) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [SVProgressHUD showErrorWithStatus:@"获取失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActiveCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActiveCommentCell" forIndexPath:indexPath];
    [cell.contentLabel setNumberOfLines:0];
    
    CommentEntity *entity = self.commentArray[indexPath.row];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:entity.user.head_img_url] placeholderImage:placeholder_image];
    [cell.nicknameLabel setText:entity.user.nick_name];
    [cell.contentLabel setText:entity.content];
    [cell.timeLabel setText:[entity.create_time dateString]];
    
    return cell;
}

@end
