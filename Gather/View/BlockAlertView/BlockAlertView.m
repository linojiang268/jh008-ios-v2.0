//
//  BlockAlertView.m
//  Gather
//
//  Created by Ray on 14-12-25.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "BlockAlertView.h"

@interface BlockAlertView ()<UITextFieldDelegate>

@property (nonatomic, copy) void(^handler)(UIAlertView *alertView, NSUInteger index);

@end

@implementation BlockAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message handler:(void(^)(UIAlertView *alertView, NSUInteger index))handler cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle {
    
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
    if (self) {
        self.handler = handler;
    }
    return self;
}

- (void)show {
    if (self.alertViewStyle == UIAlertViewStylePlainTextInput) {
        [[self textFieldAtIndex:0] setDelegate:self];
    }
    [super show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.handler) {
        self.handler(self,buttonIndex);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self alertViewShouldEnableFirstOtherButton:self];
    return YES;
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (self.alertViewStyle == UIAlertViewStylePlainTextInput) {
        return [alertView textFieldAtIndex:0].text.length > 0;
    }
    return YES;
}

@end
