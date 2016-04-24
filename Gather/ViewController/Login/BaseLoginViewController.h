//
//  BaseLoginViewController.h
//  Gather
//
//  Created by Ray on 14-12-26.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseLoginViewController : BaseViewController {
    BOOL _shouldShowRightItemButton;
    NSString *_rightitemButtonTitle;
}

- (void)rightItemButtonClick;

@end
