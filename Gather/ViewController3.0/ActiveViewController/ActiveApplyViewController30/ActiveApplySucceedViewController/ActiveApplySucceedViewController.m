//
//  ActiveApplySucceedViewController.m
//  Gather
//
//  Created by apple on 15/4/16.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveApplySucceedViewController.h"
#import "ActiveConfigEntity.h"

@interface ActiveApplySucceedViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;


@end

@implementation ActiveApplySucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.coverImageView.layer.masksToBounds = YES;
    [self.nameLabel setText:self.activeInfo.title];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.activeInfo.head_img_url] placeholderImage:placeholder_image];
    
    if ([ActiveConfigEntity sharedConfig].show_verify == ActiveConfigStatusHasSet) {
        [self.hintLabel setText:@"报名成功，等待审核"];
        [ActiveMoreConfigEntity sharedMoreConfig].enroll_status = 1;
    }else {
        [self.hintLabel setText:@"报名成功"];
        [ActiveMoreConfigEntity sharedMoreConfig].enroll_status = 3;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kAPPLY_SUCCESS_NOTIFICATION_NAME object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItems = @[];
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)backDetailPage:(id)sender {
    NSUInteger count = self.navigationController.viewControllers.count;
    UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:count-3];
    [self.navigationController popToViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
