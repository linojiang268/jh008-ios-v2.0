//
//  VerifyCodeViewController.m
//  Gather
//
//  Created by Ray on 14-12-25.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "VerifyCodeViewController.h"
#import "PerfectInfoViewController.h"
#import "NewPasswordViewController.h"
#import "Network+Account.h"

@interface VerifyCodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextfield;
@property (weak, nonatomic) IBOutlet UILabel *resendView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (assign, nonatomic) BOOL resendViewEnabled;

@end

@implementation VerifyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableString *text = [NSMutableString stringWithString:self.phoneNumberLabel.text];
    [text replaceOccurrencesOfString:@"187 8888 8888" withString:self.phoneNumber options:NSNumericSearch range:NSMakeRange(0, text.length)];
    [self.phoneNumberLabel setText:text];
    [self.resendView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resend)]];
    [self countdown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resend {
    if (self.resendViewEnabled) {
        [self getAuthCode];
    }
}

- (void)countdown {
    __block NSInteger second = 60;
    __weak typeof(self) wself = self;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = [NSString stringWithFormat:@"%ds 重新发送", second];
            if (second < 0) {
                title = @"重新发送";
                dispatch_source_cancel(timer);
                wself.resendViewEnabled = YES;
            }
            second -= 1;
            wself.resendView.text = title;
        });
    });
    dispatch_resume(timer);
}

- (void)getAuthCode {
    
    if (!self.phoneNumber) {
        return;
    }
    SHOW_LOAD_HUD;
    switch (self.pageType) {
        case VerifyCodeTypeNewUser: {
            [Network getAuthCodeWithNewPhoneNumber:self.phoneNumber success:^(id response) {
                DISMISS_HUD;
            } failure:^(NSString *errorMsg, StatusCode code) {
                [SVProgressHUD showErrorWithStatus:@"获取验证码失败"];
            }];
        }
            break;
        case VerifyCodeTypeForgetPassword: {
            [Network getAuthCodeWithOldPhoneNumber:self.phoneNumber success:^(id response) {
                DISMISS_HUD;
            } failure:^(NSString *errorMsg, StatusCode code) {
                [SVProgressHUD showErrorWithStatus:@"获取验证码失败"];
            }];
        }
            break;
    }
}

- (void)rightItemButtonClick {
    SHOW_LOAD_HUD;
    [Network verifyAuthCodeWithType:(VerifyCodeType)self.pageType PhoneNumber:self.phoneNumber code:self.verificationCodeTextfield.text success:^(id response) {
        DISMISS_HUD;
        BaseViewController *nextController = nil;
        switch (self.pageType) {
            case VerifyCodeTypeNewUser: {
                nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"PerfectInfo"];
                ((PerfectInfoViewController *)nextController).phoneNumber = self.phoneNumber;
                ((PerfectInfoViewController *)nextController).isPhoneRegistered = YES;
            }
                break;
            case VerifyCodeTypeForgetPassword: {
                nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewPassword"];
            }
                break;
        }
        [self.navigationController pushViewController:nextController animated:YES];
    } failure:^(NSString *errorMsg, StatusCode code) {
        if (code == StatusCodePhoneCodeTimeout) {
            [SVProgressHUD showErrorWithStatus:@"验证码已过期，请重新获取"];
        }else if (code == StatusCodePhoneCodeWrong) {
            [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        }
        [SVProgressHUD showErrorWithStatus:@"验证失败，请重试"];
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
