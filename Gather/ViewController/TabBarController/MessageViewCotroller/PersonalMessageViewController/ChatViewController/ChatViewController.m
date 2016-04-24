//
//  ChatViewController.m
//  Gather
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatLeftTableViewCell.h"
#import "ChatRightTableViewCell.h"
#import "Network+Message.h"
#import "MJRefresh.h"
#import <IQKeyboardManager.h>
#import "FullUserInfoEntity.h"
#import "DXMessageToolBar.h"
#import "NSDate+Extend.h"
#import "Network+Push.h"
#import "Network+PersonalHomePage.h"

@interface ChatViewController()<UITableViewDataSource,UITableViewDelegate,DXMessageToolBarDelegate> {
    BOOL _isFirstShow;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewDistanceBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *recordList;
@property (nonatomic, assign) int totalNumber;

@property (nonatomic, strong) FullUserInfoEntity *selfInfo;
@property (strong, nonatomic) DXMessageToolBar *chatToolBar;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic,strong) BlockBarButtonItem *rightItem;

@property (nonatomic, strong) SimpleUserInfoEntity *contactsInfo;

@end

@implementation ChatViewController

- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], self.view.frame.size.width, [DXMessageToolBar defaultHeight])];
        _chatToolBar.maxTextInputViewHeight = 120;
        _chatToolBar.sendButtonDefaultImage = image_with_name(@"btn_chat_send_d");
        _chatToolBar.sendButtonHighlightImage = image_with_name(@"btn_chat_send_h");
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
    }
    
    return _chatToolBar;
}

-(void)didChangeFrameToHeight:(CGFloat)toHeight
{
    if (toHeight == 46) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }else {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, toHeight - 46, 0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, toHeight - 46, 0);
        [self scrollToBottomAnimated:NO];
    }
}

- (void)didSendText:(NSString *)text
{
    [self.chatToolBar clearText];
    [self keyBoardHidden];
    if (text && text.length > 0) {
        
        SHOW_LOAD_HUD;
        __weak typeof(self) wself = self;
        [Network sendMsg:text revId:self.contactId success:^(id response) {
            MessageRecordEntity *entity = [[MessageRecordEntity alloc] init];
            entity.role = 1;
            entity.content = text;
            entity.create_time = [NSDate dateString];
            [wself.recordList addObject:entity];
            [wself.tableView reloadData];
            [wself scrollToBottomAnimated:NO];
            DISMISS_HUD;
            if (!string_is_empty(self.baidu_channel_id) && !string_is_empty(self.baidu_user_id)) {
                NSError *error;
                NSString *pushMsg = @"";
                
                NSString *msg = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (wself.last_login_platform == 3) {
                    
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:@{@"filter_k_id": @(PushTypeChat), @"filter_v_id": @(wself.selfInfo.id)} forKey:@"custom_content"];
                    [dict setObject:self.selfInfo.nick_name forKey:@"title"];
                    [dict setObject:msg forKey:@"description"];
                    
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
                    pushMsg = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                }else {
                    
                    NSString *alertMsg = [NSString stringWithFormat:@"%@:%@",wself.selfInfo.nick_name,msg];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:@{@"alert": alertMsg, @"sound": @"default"} forKey:@"aps"];
                    [dict setObject:@(PushTypeChat) forKey:@"filter_k_id"];
                    [dict setObject:@(wself.selfInfo.id) forKey:@"filter_v_id"];
                    
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
                    pushMsg = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                }
                
                if (!error) {
                    [Network pushMsgWithUserId:wself.baidu_user_id channel_id:wself.baidu_channel_id device_type:4 messages:pushMsg];
                }else {
                    log_value(@"push json create failed");
                }
            }
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }];
    }
}

// 点击背景隐藏
-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [self scrollToBottomAnimated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0] - 1;
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

- (void)shieldOrCancel {
    SHOW_LOAD_HUD;
    __weak typeof(self) wself = self;
    
    if (self.isShield == 0) {
        [Network shieldingContact:self.contactId success:^(id response) {
            DISMISS_HUD;
            
            wself.rightItem.title = @"取消屏蔽";
            wself.isShield = 1;
            
        } failure:^(NSString *errorMsg, StatusCode code) {
            SHOW_ERROR_HUD;
        }];
    }else if (self.isShield == 1) {
        [Network cancelShieldingContact:self.contactId success:^(id response) {
            DISMISS_HUD;
            
            wself.rightItem.title = @"屏蔽";
            wself.isShield = 0;
            
        } failure:^(NSString *errorMsg, StatusCode code) {
            SHOW_ERROR_HUD;
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isFirstShow = YES;
    self.selfInfo = [Common getSelfUserInfo];
    
    self.tableView.backgroundColor = color_with_hex(kColor_f8f8f8);
    self.tableView.estimatedRowHeight = 500;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChatLeftTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"LeftCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChatRightTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"RightCell"];
    
    self.currentPage = 0;
    self.totalNumber = 0;
    self.recordList = [[NSMutableArray alloc] init];

    
    [self.view addSubview:self.chatToolBar];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    
    __weak typeof(self) wself = self;
    [self.tableView addHeaderWithCallback:^{
        [wself requestInfo];
    }];
    
    if (self.pushId > 0) {
        SHOW_LOAD_HUD;
        [Network getPersonalHomePageInfoWithUserId:self.pushId cityId:[Common getCurrentCityId] success:^(PersonalHomePageEntity *entity) {
            
            [wself setContactsInfo:entity];
            [wself.tableView headerBeginRefreshing];
            [wself addRightButton];
            DISMISS_HUD;
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
        }];
        
        [self.navigationItem addLeftItem:[[BlockBarButtonItem alloc] initWithImage:image_with_name(@"btn_back_yellow") highlight:nil clickHandler:^(BlockBarButtonItem *item){
            [wself dismissViewControllerAnimated:YES completion:nil];
        }]];
    }else {
        self.title = self.nickName;
        [self addRightButton];
        [self.tableView headerBeginRefreshing];
    }
}

- (void)setContactsInfo:(SimpleUserInfoEntity *)contactsInfo {
    _contactsInfo = contactsInfo;
    
    self.contactId = contactsInfo.id;
    self.isShield = contactsInfo.is_shield;
    self.nickName = contactsInfo.nick_name;
    self.title = self.nickName;
    self.headImageUrl = contactsInfo.head_img_url;
    self.baidu_user_id = contactsInfo.baidu_user_id;
    self.baidu_channel_id = contactsInfo.baidu_channel_id;
    self.last_login_platform = contactsInfo.last_login_platform;
}

- (void)addRightButton {
    
    NSString *title = @"屏蔽";
    if (self.isShield == 1) {
        title = @"取消屏蔽";
    }
    
    __weak typeof(self) wself = self;
    self.rightItem = [[BlockBarButtonItem alloc] initWithTitle:title clickHandler:^(BlockBarButtonItem *item) {
        [wself shieldOrCancel];
    }];
    [self.navigationItem addRightItem:self.rightItem];
}


- (void)requestInfo {
    if (self.totalNumber !=0 && self.recordList.count >= self.totalNumber) {
        [self.tableView headerEndRefreshing];
        return;
        
    }
    self.currentPage += 1;
    
    NSUInteger size = kSize;
    if (self.currentPage == 1) {
        size = 5;
    }
    
    __weak typeof(self) wself = self;
    [Network getRecordListWithContactId:self.contactId page:self.currentPage size:size success:^(MessageRecordListEntity *entity) {
        wself.totalNumber = entity.total_num;

        NSMutableArray *temp = [NSMutableArray arrayWithArray:[[entity.messages reverseObjectEnumerator] allObjects]];
        [temp addObjectsFromArray:wself.recordList];
        [wself.recordList setArray:temp];
        [wself.tableView reloadData];
        [wself.tableView headerEndRefreshing];
        
        if (wself.currentPage == 1) {
            [wself scrollToBottomAnimated:NO];
        }
    } failure:^(NSString *errorMsg, StatusCode code) {
        [wself.tableView headerEndRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordList.count;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return YES;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
}

- (NSString *)dateStringWithIndexPath:(NSIndexPath *)indexPath {
    NSString *time = nil;
    
    MessageRecordEntity *current = self.recordList[indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:current.create_time];
    
    NSTimeInterval interval = 0;
    if (indexPath.row > 0) {
        MessageRecordEntity *previous = self.recordList[indexPath.row - 1];
        NSDate *previousDate = [dateFormatter dateFromString:previous.create_time];
        interval = [date timeIntervalSinceDate:previousDate];
    }else {
        interval = [[NSDate date] timeIntervalSinceDate:date];
    }
    
    if ((interval > 60 * 2)) {
        return [current.create_time dateString];
    }
    
    return time;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MessageRecordEntity *current = self.recordList[indexPath.row];
    
    NSString *time = [self dateStringWithIndexPath:indexPath];
    
    __weak typeof(self) wself = self;
    if (current.role == 2) {
        ChatLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setHeadImageURL:self.headImageUrl];
        [cell setContent:current.content];
        if (!string_is_empty(time)) {
            [cell setTime:time];
        }else {
            [cell hideTimeView];
        }
        [cell menuCopyAction:^{
            [UIPasteboard  generalPasteboard].string = current.content;
        } deleteAction:^{
            [wself deleteMsgWithMsgEntity:current];
        }];
        
        return cell;
    }else {
        
        ChatRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setHeadImageURL:self.selfInfo.head_img_url];
        [cell setContent:current.content];
        if (!string_is_empty(time)) {
            [cell setTime:time];
        }else {
            [cell hideTimeView];
        }
        [cell menuCopyAction:^{
            [UIPasteboard  generalPasteboard].string = current.content;
        } deleteAction:^{
            [wself deleteMsgWithMsgEntity:current];
        }];
        
        return cell;
    }
    
    return nil;
}

- (void)deleteMsgWithMsgEntity:(MessageRecordEntity *)entity {
    
    int row = [self.recordList indexOfObject:entity];
    
    SHOW_LOAD_HUD;
    __weak typeof(self) wself = self;
    [Network deleteMsg:entity.id success:^(id response) {
        DISMISS_HUD;
        [wself.recordList removeObject:entity];
        [wself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    } failure:^(NSString *errorMsg, StatusCode code) {
        SHOW_ERROR_HUD;
    }];
}


@end
