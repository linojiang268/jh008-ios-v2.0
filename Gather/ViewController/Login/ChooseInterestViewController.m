//
//  ChooseInterestViewController.m
//  Gather
//
//  Created by Ray on 14-12-24.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "ChooseInterestViewController.h"
#import "Network+Account.h"

@interface ChooseInterestViewController ()

@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;
@property (weak, nonatomic) IBOutlet UIButton *five;
@property (weak, nonatomic) IBOutlet UIButton *sixButton;
@property (weak, nonatomic) IBOutlet UIButton *sevenButton;

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) NSMutableArray *allInterests;
@property (nonatomic, strong) NSMutableArray *selectedInterests;


@end

@implementation ChooseInterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.buttons = @[self.oneButton,self.twoButton,self.threeButton,self.fourButton,self.five,self.sixButton,self.sevenButton];
    self.selectedInterests = [NSMutableArray array];
    
    [Network getUserInterestTagWithSuccess:^(id response) {
        
    } failure:^(NSString *errorMsg, StatusCode code) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tagButtonPressed:(id)sender {
    [sender setSelected:YES];
    if (self.allInterests && self.allInterests.count) {
        if ([sender tag] > self.allInterests.count) {
            return;
        }
        [self.selectedInterests addObject:self.allInterests[[sender tag]]];
    }
}

- (IBAction)next:(id)sender {
    
    
    
}


@end
