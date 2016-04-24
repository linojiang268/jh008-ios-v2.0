//
//  SearchViewController.m
//  Gather
//
//  Created by apple on 15/1/21.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "StarSearchViewController.h"

@interface StarSearchViewController ()

@property (weak, nonatomic) IBOutlet UIView *textBackgroundView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, copy) void(^searchDoneHandler)(NSString *keywords);

@end

@implementation StarSearchViewController

- (void)searchDoneHanlder:(void (^)(NSString *keywords))hanlder {
    self.searchDoneHandler = hanlder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = color_with_hex(kColor_f8f8f8);
    self.textBackgroundView.backgroundColor = color_white;
    self.textField.backgroundColor = color_white;
    self.textBackgroundView.layer.borderWidth = 0.5;
    self.textBackgroundView.layer.borderColor = [color_with_hex(kColor_c9c9c9) CGColor];
    
    __weak typeof(self) wself = self;
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"确认" clickHandler:^(BlockBarButtonItem *item) {
        
        if (!string_is_empty(wself.textField.text)) {
            if (wself.searchDoneHandler) {
                wself.searchDoneHandler(wself.textField.text);
            }
        }
        [wself.navigationController popViewControllerAnimated:YES];
    }]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

@end
