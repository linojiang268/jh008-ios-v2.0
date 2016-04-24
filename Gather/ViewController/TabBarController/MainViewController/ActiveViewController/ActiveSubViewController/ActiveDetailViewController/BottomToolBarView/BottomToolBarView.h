//
//  BottomToolBarView.h
//  Gather
//
//  Created by apple on 15/1/28.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ActiveBottomViewStyle) {
    ActiveBottomViewStyleShowAll         = 1,
    ActiveBottomViewStyleHideApply       = 2,
    ActiveBottomViewStyleOnlyShowComment = 3,
};

@interface BottomToolBarView : UIView

- (instancetype)initWithStyle:(ActiveBottomViewStyle)style;

@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;

@end
