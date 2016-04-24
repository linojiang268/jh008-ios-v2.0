//
//  OrderPreviewController.h
//  Gather
//
//  Created by apple on 15/3/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NewsListEntity.h"

@interface OrderPreviewController : BaseTableViewController

@property (nonatomic, strong) NewsEntity *goodsInfo;
@property (nonatomic, strong) NSString *orderNumber;

@end
