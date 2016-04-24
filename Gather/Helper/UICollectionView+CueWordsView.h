//
//  UICollectionView+CueWordsView.h
//  Gather
//
//  Created by apple on 15/3/3.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (CueWordsView)<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

- (void)reloadDataIfEmptyShowCueWordsView;

@end
