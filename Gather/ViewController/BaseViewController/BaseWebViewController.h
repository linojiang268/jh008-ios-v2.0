//
//  BaseWebViewController.h
//  Gather
//
//  Created by apple on 15/3/25.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseWebViewController : BaseViewController<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end
