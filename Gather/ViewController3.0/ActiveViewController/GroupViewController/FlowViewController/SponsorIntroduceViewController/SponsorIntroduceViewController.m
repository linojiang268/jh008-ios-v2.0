//
//  SponsorIntroduceViewController.m
//  Gather
//
//  Created by apple on 15/3/25.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "SponsorIntroduceViewController.h"
#import "ActiveConfigEntity.h"

@interface SponsorIntroduceViewController ()

@end

@implementation SponsorIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[ActiveMoreConfigEntity sharedMoreConfig].busi_url]]];
}

@end
