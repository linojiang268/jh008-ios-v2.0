//
//  UITableView+EmptyDataView.h
//  Gather
//
//  Created by apple on 15/3/3.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIScrollView+EmptyDataSet.h>

@interface UITableView (CueWordsView)<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

- (void)reloadDataIfEmptyShowCueWordsView;

@end
