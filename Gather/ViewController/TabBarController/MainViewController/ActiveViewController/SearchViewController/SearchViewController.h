//
//  SearchViewController.h
//  Gather
//
//  Created by apple on 15/1/31.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, SearchType) {
    SearchTypeActive = 1,
    SearchTypeNews   = 2,
};

@interface SearchViewController : BaseViewController

@property (nonatomic, assign) SearchType searchType;

@property (nonatomic, assign) NewsType newsType;

@end
