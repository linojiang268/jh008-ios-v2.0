//
//  PerfectInfoViewController.m
//  Gather
//
//  Created by Ray on 14-12-24.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "PerfectInfoViewController.h"
#import "UploadHeadPortraitsViewController.h"
#import "UIControl+Extend.h"


@interface PerfectInfoViewController () {
    Sex _sex;
}

@property (weak, nonatomic) IBOutlet UIButton *womanButton;
@property (weak, nonatomic) IBOutlet UIButton *manButton;

@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthDayTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIImageView *lastLineView;

@end

@implementation PerfectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _sex = SexWoman;
    
    [self.womanButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
        _sex = SexWoman;
        [self.womanButton setSelected:YES];
        [self.manButton setSelected:NO];
    }];
    [self.manButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
        _sex = SexMan;
        [self.womanButton setSelected:NO];
        [self.manButton setSelected:YES];
    }];
    
    if (!self.isPhoneRegistered) {
        [self.passwordTextField removeFromSuperview];
        [self.lastLineView removeFromSuperview];
    }
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    __weak typeof(self) wself = self;
    [self.birthDayTextField addEvent:UIControlEventEditingDidBegin handler:^(id sender) {
        NSString *stringDate = [f stringFromDate:[datePicker date]];
        wself.birthDayTextField.text = stringDate;
    }];
    [datePicker addEvent:UIControlEventValueChanged handler:^(id sender) {
        NSString *stringDate = [f stringFromDate:[(UIDatePicker *)sender date]];
        wself.birthDayTextField.text = stringDate;
    }];
    self.birthDayTextField.inputView = datePicker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightItemButtonClick {
    if (string_is_empty(self.nicknameTextField.text)) {
        alert(nil, @"请输入昵称");
        return;
    }
    if ([self.nicknameTextField.text countWord] > 20) {
        alert(nil, @"昵称最大长度为20字符");
        return;
    }
    if (string_is_empty(self.birthDayTextField.text)) {
        alert(nil, @"请输入出生日期");
        return;
    }
    if (self.isPhoneRegistered) {
        if (string_is_empty(self.passwordTextField.text)) {
            alert(nil, @"请输入密码");
            return;
        }
        if (string_length(self.passwordTextField.text) < 6 || string_length(self.passwordTextField.text) > 18) {
            alert(nil, @"密码长度在6-16位之间");
            return;
        }
    }
    
    UploadHeadPortraitsViewController *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadHead"];
    nextController.phoneNumber = self.phoneNumber;
    nextController.nickname = self.nicknameTextField.text;
    nextController.birthDay = self.birthDayTextField.text;
    nextController.password = self.passwordTextField.text;
    nextController.sex = _sex;
    nextController.isPhoneRegistered = self.isPhoneRegistered;
    [self.navigationController pushViewController:nextController animated:YES];
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
