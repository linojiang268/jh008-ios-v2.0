//
//  CustomToolBarkeyBoard.m
//  CustomToolBarKeyBoard
//
//  Created by apple on 15/1/11.
//  Copyright (c) 2015年 CustomToolBarKeyBoard. All rights reserved.
//

#import "CustomToolBarKeyBoard.h"

@interface CustomToolBarKeyBoard ()<UITextViewDelegate> {
    CGFloat keyboardHeight;
}

@property (nonatomic, assign) CGFloat oldHeight;
@property (nonatomic, assign) CGRect oldRect;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic, weak) UIView *view;

@property (nonatomic, copy) void(^willShowKeyboardHandler)(CGRect keyboardRect);
@property (nonatomic, copy) void(^willHideKeyboardHandler)(CGRect keyboardRect);
@property (nonatomic, copy) void(^textViewDidChangeHandler)(void);
@property (nonatomic, copy) void(^sendHandler)(UITextView *textView);

@end

@implementation CustomToolBarKeyBoard

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [self init];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view {
    self = [self init];
    if (self) {
        self.view = view;
        self.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds)-108, CGRectGetWidth(self.view.bounds), 44);
    }
    return self;
}

- (void)setup {
    
    self.oldHeight = self.textViewHeight.constant;
    self.oldRect = self.bounds;
    self.textView.delegate = self;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [color_with_hex(kColor_ff9933) CGColor];
    self.textView.layer.cornerRadius = 3.0;
    self.sendButton.layer.borderWidth = 0.5;
    self.sendButton.layer.borderColor = [color_with_hex(kColor_ff9933) CGColor];
    self.sendButton.layer.cornerRadius = 3.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)textViewBecomeFirstResponder {
    [self.textView becomeFirstResponder];
}

- (IBAction)sendButtonClick:(id)sender {
    [self.textView resignFirstResponder];
    if (self.sendHandler) {
        self.sendHandler(self.textView);
    }
}

- (void)setWillShowKeyboardHandler:(void (^)(CGRect))willShowKeyboardHandler {
    _willShowKeyboardHandler = willShowKeyboardHandler;
}

- (void)setWillHideKeyboardHandler:(void (^)(CGRect))willHideKeyboardHandler {
    _willHideKeyboardHandler = willHideKeyboardHandler;
}

- (void)setTextViewDidChangeHandler:(void (^)(void))textViewDidChangeHandler {
    _textViewDidChangeHandler = textViewDidChangeHandler;
}

- (void)setSendHandler:(void (^)(UITextView *))sendHandler {
    _sendHandler = sendHandler;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    if (self.willShowKeyboardHandler) {
        self.willShowKeyboardHandler(keyboardRect);
    };
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
                         CGRect frame = self.frame;
                         
                         frame.origin.y += keyboardHeight;
                         frame.origin.y -= keyboardRect.size.height;
                         self.frame = frame;
                         
                         keyboardHeight = keyboardRect.size.height;
     }];
   
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (self.willHideKeyboardHandler) {
        self.willHideKeyboardHandler(CGRectMake(0, 0, 0, keyboardHeight));
    }
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect frame = self.frame;
        frame.origin.y += keyboardHeight;
        frame.size.height = self.oldRect.size.height;
        self.frame = frame;
        keyboardHeight = 0;
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    [self.textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {

    CGSize size = self.textView.contentSize;
    if ( size.height < 83 ) {
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat span = size.height - self.textView.frame.size.height;
            CGRect frame = self.frame;
            frame.origin.y -= span;
            frame.size.height += span;
            
            self.frame = frame;
            
            self.viewHeight.constant = size.height;
            self.textViewHeight.constant = size.height;
            [self layoutIfNeeded];
        }];
    }
    if (self.textViewDidChangeHandler) {
        self.textViewDidChangeHandler();
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

@end
