//
//  CustomToolBarkeyBoard.h
//  CustomToolBarKeyBoard
//
//  Created by apple on 15/1/11.
//  Copyright (c) 2015年 CustomToolBarKeyBoard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomToolBarKeyBoard : UIView

- (instancetype)initWithView:(UIView *)view;
- (void)textViewBecomeFirstResponder;

- (void)setWillShowKeyboardHandler:(void (^)(CGRect))willShowKeyboardHandler ;
- (void)setWillHideKeyboardHandler:(void (^)(CGRect))willHideKeyboardHandler ;
- (void)setTextViewDidChangeHandler:(void (^)(void))textViewDidChangeHandler ;
- (void)setSendHandler:(void (^)(UITextView *))sendHandler ;

@end
