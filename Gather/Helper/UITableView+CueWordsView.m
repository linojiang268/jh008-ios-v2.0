//
//  UITableView+EmptyDataView.m
//  Gather
//
//  Created by apple on 15/3/3.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "UITableView+CueWordsView.h"

@implementation UITableView (CueWordsView)

- (void)reloadDataIfEmptyShowCueWordsView {
    
    if (!self.emptyDataSetSource) {
        self.emptyDataSetSource = self;
    }
    if (!self.emptyDataSetDelegate) {
        self.emptyDataSetDelegate = self;
    }
    
    [self reloadData];
}

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    
    if (!NETWORK_REACHABLE && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        text = @"网络异常，请连接网络后重试";
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
