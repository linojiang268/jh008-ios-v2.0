//
//  BlockAlertView.h
//  Gather
//
//  Created by Ray on 14-12-25.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockAlertView : UIAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message handler:(void(^)(UIAlertView *alertView, NSUInteger index))handler cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle;

@end
