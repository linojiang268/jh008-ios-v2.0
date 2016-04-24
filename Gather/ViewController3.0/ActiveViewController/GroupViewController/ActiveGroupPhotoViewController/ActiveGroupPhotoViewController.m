//
//  ActiveGroupPhotoViewControllerTableViewController.m
//  Gather
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveGroupPhotoViewController.h"
#import "Network+ActiveGroupPhoto.h"
#import "ActiveGroupPhotoTableViewCell.h"
#import "ActiveConfigEntity.h"
#import "ActiveGroupPhotoDetailViewController.h"
#import "ActiveGroupPhotoAddViewController.h"

@interface ActiveGroupPhotoViewController ()

@property (nonatomic, strong) NSMutableArray *memberPhotoArray;
@property (nonatomic, strong) ActiveGroupPhotoListEntity *photoEntityInfo;

@end

@implementation ActiveGroupPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.memberPhotoArray = [[NSMutableArray alloc] init];
    
    self.tableView.estimatedRowHeight = 70.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    __weak typeof(self) wself = self;
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithImage:image_with_name(@"btn_active_photo_add_self_photo") highlight:nil clickHandler:^(BlockBarButtonItem *item) {
        
        ActiveGroupPhotoAddViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"AddPhoto"];
        [wself.navigationController pushViewController:controller animated:YES];
    }]];
    [self.tableView addHeaderWithCallback:^{
        wself.currentPage = 0;
        [wself requestPhotoInfo];
    }];
    [self.tableView addFooterWithCallback:^{
        [wself requestPhotoInfo];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([ActiveMoreConfigEntity sharedMoreConfig].album_id != self.photoEntityInfo.my_album_id) {
        [self.tableView headerBeginRefreshing];
    }
}

- (void)requestPhotoInfo {
    
    if (self.currentPage > 0 && self.memberPhotoArray.count >= self.totalNumber) {
        [self.tableView footerEndRefreshing];
        return;
    }

    self.currentPage += 1;
    __weak typeof(self) wself = self;
    [Network getActivePhotoWithActiveId:self.activeId cityId:[Common getCurrentCityId] page:self.currentPage size:kSize success:^(ActiveGroupPhotoListEntity *entity) {
        wself.photoEntityInfo = entity;
        if (wself.currentPage == 1) {
            [wself.memberPhotoArray removeAllObjects];
            [wself.memberPhotoArray setArray:entity.albums];
            [wself.tableView headerEndRefreshing];
        }else {
            [wself.memberPhotoArray addObjectsFromArray:entity.albums];
            [wself.tableView footerEndRefreshing];
        }
        [wself.tableView reloadDataIfEmptyShowCueWordsView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"相册获取失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.memberPhotoArray.count > 0) {
        return self.memberPhotoArray.count + 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActiveGroupPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.nameLabel.text = self.photoEntityInfo.busi_photo.subject;
        cell.numberLabel.text = self.photoEntityInfo.busi_photo.sum;
        [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.photoEntityInfo.busi_photo.cover_url] placeholderImage:placeholder_image];
    }else {
        MemberPhotoEntity *entity = [self.memberPhotoArray objectAtIndex:(indexPath.section-1)];
        cell.nameLabel.text = entity.subject;
        cell.numberLabel.text = entity.sum;
        [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:entity.cover_url] placeholderImage:placeholder_image];
    }
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActiveGroupPhotoDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoDetail"];
    if (indexPath.section == 0) {
        controller.photoId = self.photoEntityInfo.busi_photo.id;
        controller.title = self.photoEntityInfo.busi_photo.subject;
    }else {
        MemberPhotoEntity *entity = [self.memberPhotoArray objectAtIndex:(indexPath.section - 1)];
        controller.photoId = entity.id;
        controller.title = entity.subject;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
