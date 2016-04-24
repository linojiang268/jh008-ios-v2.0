//
//  NewPasswordViewController.m
//  Gather
//
//  Created by Ray on 14-12-25.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "NewPasswordViewController.h"
#import "LoginViewController.h"
#import "Network+Account.h"

@interface NewPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyPasswordTextField;

@end

@implementation NewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightItemButtonClick {

    if (string_is_empty(self.passwordTextField.text)) {
        alert(nil, @"请输入密码");
        return;
    }
    if (string_length(self.passwordTextField.text) < 6 || string_length(self.passwordTextField.text) > 18) {
        alert(nil, @"密码长度在6-16位之间");
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.verifyPasswordTextField.text]) {
        alert(nil, @"两次密码输入不一致");
        return;
    }
    
    __weak typeof(self) wself = self;
    SHOW_LOAD_HUD;
    [Network updatePassword:[[self.passwordTextField.text md5] lowercaseString] success:^(id response) {
        DISMISS_HUD;
        [[[BlockAlertView alloc] initWithTitle:nil message:@"修改成功" handler:^(UIAlertView *alertView, NSUInteger index) {
            [wself.navigationController popToRootViewControllerAnimated:YES];
        } cancelButtonTitle:@"马上登陆" otherButtonTitles:nil] show];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"修改失败，请重试"];
    }];
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
