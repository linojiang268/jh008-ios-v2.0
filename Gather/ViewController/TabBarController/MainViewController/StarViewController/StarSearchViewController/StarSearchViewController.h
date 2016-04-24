//
//  SearchViewController.h
//  Gather
//
//  Created by apple on 15/1/21.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseViewController.h"

@interface StarSearchViewController : BaseViewController

- (void)searchDoneHanlder:(void(^)(NSString *keywords))hanlder;

@end
