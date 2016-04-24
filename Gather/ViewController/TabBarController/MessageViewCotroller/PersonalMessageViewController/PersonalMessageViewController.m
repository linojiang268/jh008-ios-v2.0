//
//  PersonalMessageViewController.m
//  Gather
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "PersonalMessageViewController.h"
#import "Network+Contacts.h"
#import "PersonalMessageTableViewCell.h"
#import "ChatViewController.h"
#import "PersonalHomePageViewController.h"

@interface PersonalMessageViewController ()

@property (nonatomic, strong) NSMutableArray *contactsArray;

@end

@implementation PersonalMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage = 1;
    self.contactsArray = [[NSMutableArray alloc] init];
    
    self.tableView.rowHeight = 90;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    __weak typeof(self) wself = self;
    [self.tableView addHeaderWithCallback:^{
        [wself setCurrentPage:0];
        [wself requestInfo];
    }];
    
    [self.tableView addFooterWithCallback:^{
        [wself requestInfo];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView headerBeginRefreshing];
}

- (void)requestInfo {
    if (self.tableView.footerRefreshing && self.currentPage != 0 && self.contactsArray.count >= self.totalNumber) {
        [self.tableView footerEndRefreshing];
        return;
    }
    
    self.currentPage += 1;
    
    __weak typeof(self) wself = self;
    [Network getContactsListWithCityId:[Common getCurrentCityId] page:self.currentPage size:kSize success:^(ContactsListEntity *entity) {
        wself.totalNumber = entity.total_num;
        
        if (wself.currentPage == 1) {
            [wself.contactsArray setArray:entity.users];
            [wself.tableView headerEndRefreshing];
        }else {
            [wself.contactsArray addObjectsFromArray:entity.users];
            [wself.tableView footerEndRefreshing];
        }
        [wself.tableView reloadDataIfEmptyShowCueWordsView];
        
    } failure:^(NSString *errorMsg, StatusCode code) {
        [wself.tableView footerEndRefreshing];
        [wself.tableView headerEndRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    SimpleUserInfoEntity *entity = self.contactsArray[indexPath.row];
    
    __weak typeof(self) wself = self;
    [cell setHeadImageURL:entity.head_img_url];
    [cell setNickname:entity.nick_name];
    [cell setSex:entity.sex];
    [cell setLastContent:entity.content];
    [cell setlastTime:[entity.last_contact_time dateString]];
    [cell hideRedPoint:(entity.new_msg_num <= 0)];
    [cell setHeadImageTapHandler:^{
        PersonalHomePageViewController *controller = [[UIStoryboard personalCenterStoryboard] instantiateViewControllerWithIdentifier:@"PersonalHomePage"];
        controller.userId = entity.id;
        controller.isFocus = entity.is_focus;
        controller.nickName = entity.nick_name;
        controller.headImageUrl = entity.head_img_url;
        controller.userInfo = (PersonalHomePageEntity *)entity;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [wself.parentVC presentViewController:nav animated:YES completion:nil];
    }];
    [cell setTag:entity.id];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteContactAction:)];
    longGesture.minimumPressDuration = 1;
    [cell addGestureRecognizer:longGesture];
    
    return cell;
}

- (void)deleteContactAction:(UILongPressGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        __weak typeof(self) wself = self;
        [[[BlockAlertView alloc] initWithTitle:nil message:@"删除此联系人？" handler:^(UIAlertView *alertView, NSUInteger index) {
            
            if (index) {
                SHOW_LOAD_HUD;
                [Network deleteContactWithId:gesture.view.tag success:^(id response) {
                    DISMISS_HUD;
                    __block SimpleUserInfoEntity *deleteEntity;
                    [wself.contactsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        SimpleUserInfoEntity *entity = obj;
                        if (entity.id == gesture.view.tag) {
                            deleteEntity = entity;
                        }
                    }];
                    
                    if (deleteEntity) {
                        NSUInteger row = [wself.contactsArray indexOfObject:deleteEntity];
                        [wself.contactsArray removeObject:deleteEntity];
                        [wself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                } failure:^(NSString *errorMsg, StatusCode code) {
                    [SVProgressHUD showErrorWithStatus:@"删除失败"];
                }];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"好"] show];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SimpleUserInfoEntity *entity = self.contactsArray[indexPath.row];
    entity.new_msg_num = 0;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    ChatViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Chat"];
    controller.contactId = entity.id;
    controller.isShield = entity.status;
    controller.nickName = entity.nick_name;
    controller.headImageUrl = entity.head_img_url;
    controller.baidu_user_id = entity.baidu_user_id;
    controller.baidu_channel_id = entity.baidu_channel_id;
    controller.last_login_platform = entity.last_login_platform;
    [self.parentVC.navigationController pushViewController:controller animated:YES];
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
