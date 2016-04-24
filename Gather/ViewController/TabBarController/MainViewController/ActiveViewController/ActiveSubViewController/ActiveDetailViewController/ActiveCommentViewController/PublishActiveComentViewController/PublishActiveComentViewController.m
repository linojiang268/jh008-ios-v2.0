//
//  PublishActiveComentViewController.m
//  Gather
//
//  Created by apple on 15/1/30.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "PublishActiveComentViewController.h"
#import "Network+Active.h"

@interface PublishActiveComentViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *characterNumberLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation PublishActiveComentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backgroundView.layer.borderWidth = 0.5;
    self.backgroundView.layer.borderColor = [color_with_hex(kColor_c9c9c9) CGColor];
    self.characterNumberLabel.textColor = color_with_hex(kColor_8e949b);
    self.textView.delegate = self;
    
    __weak typeof(self) wself = self;
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"确认" clickHandler:^(BlockBarButtonItem *item) {
        [wself publish];
    }]];
}


- (void)publish {
    if (self.textView.text.length <= 0) {
        alert(nil, @"请输入评论内容");
        return;
    }
    
    if (self.textView.text.length > 120) {
        alert(nil, @"内容长度超出最大限制");
        return;
    }
    
    __weak typeof(self) wself = self;
    SHOW_LOAD_HUD;
    [Network activeCommentWithActiveId:self.activeId content:self.textView.text success:^(id response) {
        
        [SVProgressHUD showSuccessWithStatus:@"评论成功"];
        [wself.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showInfoWithStatus:@"评论失败"];
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.characterNumberLabel.text = [NSString stringWithFormat:@"%d/120",textView.text.length];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
