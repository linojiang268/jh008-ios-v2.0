//
//  ActiveApplyFooterView.h
//  Gather
//
//  Created by apple on 15/3/31.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActiveApplyFooterView : UIView

@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

- (void)hideCostView;

@end
