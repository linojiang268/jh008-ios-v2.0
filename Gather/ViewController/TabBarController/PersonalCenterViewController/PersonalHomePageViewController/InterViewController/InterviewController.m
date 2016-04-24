//
//  InterViewController.m
//  Gather
//
//  Created by apple on 15/2/3.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "InterviewController.h"
#import "ShareViewController.h"
#import "ShowMaskViewController.h"
#import "Network+UserInfo.h"

@interface InterviewController ()

@property (nonatomic, strong) ShareViewController *shareController;

@end

@implementation InterviewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.interviewInfo) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.interviewInfo.detail_url]]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"分享" clickHandler:^(BlockBarButtonItem *item) {
        [self share];
    }]];
}

- (ShareViewController *)shareController {
    if (!_shareController) {
        _shareController = [[ShareViewController alloc] init];
        
        id<ISSContent> content = [ShareSDK content:self.interviewInfo.intro defaultContent:nil image:nil title:self.interviewInfo.title url:self.interviewInfo.detail_url description:nil mediaType:SSPublishContentMediaTypeNews];
        
        _shareController.sharedId = self.interviewInfo.id;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
