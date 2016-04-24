//
//  ActiveApplyViewController.m
//  Gather
//
//  Created by apple on 15/1/29.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveApplyViewController.h"
#import "FullUserInfoEntity.h"

@interface ActiveApplyViewController ()

@property (weak, nonatomic) IBOutlet UIView *frontView;
@property (weak, nonatomic) IBOutlet UIView *inputBackgroundView;

@end

@implementation ActiveApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    self.frontView.backgroundColor = [UIColor whiteColor];
    self.inputBackgroundView.backgroundColor = [UIColor whiteColor];
    
    self.frontView.layer.masksToBounds = YES;
    self.frontView.layer.cornerRadius = 3.0;
    
    FullUserInfoEntity *user = [Common getSelfUserInfo];
    self.nameTextField.text = user.real_name;
    self.phoneTextField.text = user.contact_phone;
}

- (IBAction)add:(id)sender {
    
    NSUInteger number = [self.numberTextField.text integerValue];
    number += 1;
    
    self.numberTextField.text = [NSString stringWithFormat:@"%d",number];
}

- (IBAction)subtract:(id)sender {
    
    NSUInteger number = [self.numberTextField.text integerValue];
    if (number > 1) {
        number -= 1;
        self.numberTextField.text = [NSString stringWithFormat:@"%d",number];
    }
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
