//
//  HobbyViewController.h
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HobbyViewController : UICollectionViewController

@property (nonatomic, copy) void(^selectDoneHandler)(NSArray *hobbys);

@end
