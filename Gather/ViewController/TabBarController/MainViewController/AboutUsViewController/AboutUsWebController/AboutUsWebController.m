//
//  AboutUsWebController.m
//  Gather
//
//  Created by apple on 15/2/10.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "AboutUsWebController.h"

@interface AboutUsWebController ()

@end

@implementation AboutUsWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *fullUrlString = [NSString stringWithFormat:@"%@act/site/%@",kSERVER_BASE_URL,self.urlSuffixString];
    
    if ([self.urlSuffixString isEqualToString:@"officialWebsite"]) {
        fullUrlString = @"http://www.jhla.com.cn";
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrlString]]];
}

@end
