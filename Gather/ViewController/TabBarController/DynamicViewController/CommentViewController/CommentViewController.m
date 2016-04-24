//
//  CommentViewController.m
//  Gather
//
//  Created by apple on 15/1/14.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "CommentViewController.h"
#import "DynamicTableViewCell.h"
#import "CommentTableViewCell.h"
#import "Network+Dynamic.h"
#import "IQKeyboardManager.h"
#import "CommentTableViewCell.h"
#import "DXMessageToolBar.h"
#import "FullUserInfoEntity.h"
#import "IDMPhotoBrowser.h"
#import "Network+PersonalHomePage.h"

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,DXMessageToolBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) int totalNumber;

@property (strong, nonatomic) DXMessageToolBar *chatToolBar;

@property (nonatomic, strong) NSIndexPath *atIndexPath;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) SimpleUserInfoEntity *authorUser;

@end

@implementation CommentViewController

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    }
    return _tapGesture;
}

- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], self.view.frame.size.width, [DXMessageToolBar defaultHeight])];
        _chatToolBar.maxTextInputViewHeight = 120;
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
    }
    
    return _chatToolBar;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage = 0;
    self.comments = [[NSMutableArray alloc] init];
    
    [self.tableView setEstimatedRowHeight:178];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DynamicTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"DynamicCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    [self.view addSubview:self.chatToolBar];
    [self requestCommentInfo];
    if (self.pushId > 0) {
        
        __weak typeof(self) wself = self;
        SHOW_LOAD_HUD;
        [Network getDynamicDetailWithDynamicId:self.pushId success:^(DynamicEntity *entity) {
            [wself setDynamicInfo:entity];
            
            [Network getPersonalHomePageInfoWithUserId:entity.author_id cityId:[Common getCurrentCityId] success:^(PersonalHomePageEntity *entity) {
                [wself setAuthorUser:entity];
                [wself.tableView reloadData];
                DISMISS_HUD;
            } failure:^(NSString *errorMsg, StatusCode code) {
                [SVProgressHUD showErrorWithStatus:@"获取失败"];
            }];
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
        }];
        
        [self.navigationItem addLeftItem:[[BlockBarButtonItem alloc] initWithImage:image_with_name(@"btn_back_yellow") highlight:nil clickHandler:^(BlockBarButtonItem *item){
            [wself dismissViewControllerAnimated:YES completion:nil];
        }]];
    }
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight {
    
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        
        [self.chatToolBar clearText];
        if (text.length > 120) {
            alert(nil, @"只能评论120字以内");
        }else {
            NSUInteger atId = 0;
            DynamicCommentEntity *atComment = nil;
            if (self.atIndexPath) {
                
                atComment = self.comments[self.atIndexPath.row - 1];
                atId = atComment.author_id;;
            }
            
            [self.chatToolBar endEditing:YES];
            
            DynamicCommentEntity *comment = [[DynamicCommentEntity alloc] init];
            
            if (atId > 0) {
                comment.at_id = atComment.author_id;
                comment.at_user = atComment.author_user;
            }
            
            comment.author_id = [Common getCurrentUserId];
            comment.content = text;
            SimpleUserInfoEntity *authorUser = [[SimpleUserInfoEntity alloc] init];
            authorUser.nick_name = [Common getSelfUserInfo].nick_name;
            comment.author_user = authorUser;
            
            __weak typeof(self) wself = self;
            SHOW_LOAD_HUD;
            [Network addCommentWithDynamicId:self.dynamicInfo.id atId:atId content:text success:^(id response) {
                
                [wself.comments insertObject:comment atIndex:0];
                [wself.tableView reloadData];
                DISMISS_HUD;
            } failure:^(NSString *errorMsg, StatusCode code) {
                SHOW_ERROR_HUD;
            }];
        }
    }else {
        [self keyBoardHidden];
    }
}

- (void)requestCommentInfo {
    
    if (self.currentPage != 0 && self.comments.count >= self.totalNumber) {
        return;
    }
    self.currentPage += 1;
    
    NSUInteger dynamicId = 0;
    if (self.pushId > 0) {
        dynamicId = self.pushId;
    }else if (self.dynamicInfo) {
        dynamicId = self.dynamicInfo.id;
    }
    
    __weak typeof(self) wself = self;
    [Network getDynamicCommentWithDynamicId:dynamicId page:self.currentPage size:kSize success:^(DynamicCommentListEntity *entity) {
        
        wself.totalNumber = entity.total_num;
        [wself.comments addObjectsFromArray:entity.comments];
        [wself.tableView reloadData];
    } failure:^(NSString *errorMsg, StatusCode code) {
        
    }];
}

// 点击背景隐藏
-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
    [self.view removeGestureRecognizer:self.tapGesture];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!self.dynamicInfo) {
        return 0;
    }
    if (self.comments.count > 0) {
        return self.comments.count + 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    __weak typeof(self) wself = self;
    if (indexPath.row == 0) {
        DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        DynamicEntity *entity = self.dynamicInfo;
        [cell setValue:entity user:self.authorUser];
        [cell setCommentButtonTitle:@"回复"];
        [cell deleteHandler:^{
            SHOW_LOAD_HUD;
            [Network deleteDynamicWithDynamicId:entity.id success:^(id response) {
                SHOW_SUCCESS_HUD;
                [[NSNotificationCenter defaultCenter] postNotificationName:kCOMMENT_DELETE_NOTIFICATION_NAME object:entity];
                [wself.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *errorMsg, StatusCode code) {
                SHOW_ERROR_HUD;
            }];
        }];
        [cell commentHandler:^{
            [wself.chatToolBar.inputTextView becomeFirstResponder];
        }];
        [cell didTapImageViewHandler:^(id sender, UIImage *scaleImage, NSUInteger index) {
            
            NSMutableArray *urls = [NSMutableArray array];
            [entity.imgs.imgs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Img *img = obj;
                [urls addObject:img.img_url];
            }];
            IDMPhotoBrowser *browser = [IDMPhotoBrowser controllerWithPhotoURLs:urls animatedFromView:sender];
            browser.scaleImage = scaleImage;
            [browser setInitialPageIndex:index];
            [wself presentViewController:browser animated:YES completion:nil];
        }];

        return cell;
    }else {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.comments.count > 0 && indexPath.row <= self.comments.count) {
            
            [cell setValue:self.comments[indexPath.row - 1]];
        }else {
            [cell.contentLabel setText:@"没有评论"];
        }
        if (indexPath.row == 1) {
            [cell showLine:NO];
        }
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.comments.count > 0 && indexPath.row > 0) {
        self.atIndexPath = indexPath;
        DynamicCommentEntity *comment = self.comments[indexPath.row - 1];
        [self.chatToolBar.inputTextView setPlaceHolder:[NSString stringWithFormat:@"回复%@",comment.author_user.nick_name]];
        [self.chatToolBar.inputTextView becomeFirstResponder];
        [self.view addGestureRecognizer:self.tapGesture];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > 0 && self.comments.count > 0) {
        
        DynamicCommentEntity *entity = self.comments[indexPath.row - 1];
        if (entity.author_id == [Common getCurrentUserId]) {
            return YES;
        }
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DynamicCommentEntity *entity = self.comments[indexPath.row - 1];
    
    __weak typeof(self) wself = self;
    SHOW_LOAD_HUD;
    [Network deleteDynamicCommnetWithDynamicId:entity.id success:^(id response) {
        DISMISS_HUD;
        [wself.comments removeObject:entity];
        [wself.tableView reloadData];
    } failure:^(NSString *errorMsg, StatusCode code) {
        SHOW_ERROR_HUD;
    }];
}

















@end
