//
//  RecallDetailViewController.m
//  Gather
//
//  Created by apple on 15/1/30.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "RecallDetailViewController.h"
#import "NewsListEntity.h"
#import "Network+News.h"
#import <ShareSDK/ShareSDK.h>
#import "ShareViewController.h"
#import "ShowMaskViewController.h"
#import "OrderPreviewController.h"
#import "Network+Pay.h"

@interface RecallDetailViewController ()<UIWebViewDelegate>

@property (nonatomic ,strong) BlockBarButtonItem *collectItem;

@property (nonatomic, strong) ShareViewController *shareController;

@end

@implementation RecallDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (__Gather_Version_Max < __Gather_2_0_2__) {
        if (self.newsInfo.type_id == 3) {
            [self.navigationController setToolbarHidden:NO animated:YES];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (__Gather_Version_Max < __Gather_2_0_2__) {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.pushId > 0) {
        SHOW_LOAD_HUD;
        __weak typeof(self) wself = self;
        [Network getNewsDetailWithNewsId:self.pushId success:^(NewsDetailEntity *entity) {
            [wself setNewsInfo:entity];
            [wself setup];
            DISMISS_HUD;
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
        }];
    }else {
        [self setup];
    }
}

- (void)setup {
    
    if (self.pushId > 0) {
        
        switch (self.newsInfo.type_id) {
            case 1:
                self.title = @"攻略详情";
                break;
            case 2:
                self.title = @"记忆详情";
                break;
            case 3:
                self.title = @"订购详情";
                break;
            default:
                self.title = @"资讯详情";
                break;
        }
        
        __weak typeof(self) wself = self;
        [self.navigationItem addLeftItem:[[BlockBarButtonItem alloc] initWithImage:image_with_name(@"btn_back_yellow") highlight:nil clickHandler:^(BlockBarButtonItem *item){
            [wself dismissViewControllerAnimated:YES completion:nil];
        }]];
    }
    
    if (self.newsInfo) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.newsInfo.detail_url]]];
    }
    
    if (__Gather_Version_Max < __Gather_2_0_2__) {
        if (self.newsInfo.type_id == 3) {
            
            __weak typeof(self) wself = self;
            UIBarButtonItem *leftSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            UIBarButtonItem *rightsSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            UIBarButtonItem *item = [[BlockBarButtonItem alloc] initWithTitle:@"购买" clickHandler:^(BlockBarButtonItem *item) {
                [wself buy];
            }];
            self.toolbarItems = @[leftSpace, item, rightsSpace];
        }
    }
    
    if (![self.title isEqualToString:@"收藏详情"]) {
        self.collectItem = [[BlockBarButtonItem alloc] initWithTitle:self.newsInfo.is_loved != 1 ? @"收藏":@"取消收藏"  clickHandler:^(BlockBarButtonItem *item) {
            [self collect];
        }];
        [self.navigationItem addRightItem:self.collectItem];
    }
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"分享" clickHandler:^(BlockBarButtonItem *item) {
        [self share];
    }]];
}

- (void)buy {
    
    verify_is_login;
    
    __weak typeof(self) wself = self;
    [SVProgressHUD showWithStatus:@"创建订单中"];
    [Network getOrderNumberWithGoodsName:self.newsInfo.title goodsDesc:self.newsInfo.intro totalFee:self.newsInfo.price success:^(id response) {
        DISMISS_HUD;
        NSString *orderNumber = [[response objectForKey:@"body"] objectForKey:@"trade_no"];
        OrderPreviewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"OrderPreview"];
        controller.goodsInfo = wself.newsInfo;
        controller.orderNumber = orderNumber;
        [wself.navigationController pushViewController:controller animated:YES];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"创建订单失败"];
    }];
}

- (ShareViewController *)shareController {
    if (!_shareController) {
        _shareController = [[ShareViewController alloc] init];
        
        id<ISSContent> content = [ShareSDK content:self.newsInfo.intro defaultContent:nil image:nil title:self.newsInfo.title url:self.newsInfo.detail_url description:nil mediaType:SSPublishContentMediaTypeNews];
        
        _shareController.sharedId = self.newsInfo.id;
        _shareController.content = content;
    }
    return _shareController;
}

- (void)share {
    
    ShowMaskViewController *controlelr = [ShowMaskViewController sharedController];
    [controlelr showInWindow:self.view.window otherView:self.shareController.view];
    [self.shareController cancelHandler:^{
        [controlelr dismiss];
    }];
}

- (void)collect {
    
    verify_is_login;

    __weak typeof(self) wself = self;
    SHOW_LOAD_HUD;
    if (self.newsInfo.is_loved != 1) {
        [Network collectNewsWithId:self.newsInfo.id success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            wself.newsInfo.is_loved = 1;
            wself.collectItem.title = @"取消收藏";
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showSuccessWithStatus:@"收藏失败"];
        }];
    }else {
        [Network cancelCollectNewsWithId:self.newsInfo.id success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            wself.newsInfo.is_loved = 0;
            wself.collectItem.title = @"收藏";
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showSuccessWithStatus:@"取消失败"];
        }];
    }
}

@end
