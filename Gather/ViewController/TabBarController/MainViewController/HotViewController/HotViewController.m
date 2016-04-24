//
//  HotViewController.m
//  Gather
//
//  Created by apple on 15/1/30.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "HotViewController.h"
#import <HMSegmentedControl.h>
#import "ActiveSubViewController.h"
#import "RecallSubViewController.h"

@interface HotViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segment;

@end

@implementation HotViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [((UIView *)self.navigationController.navigationBar.subviews.firstObject).subviews.lastObject setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [((UIView *)self.navigationController.navigationBar.subviews.firstObject).subviews.lastObject setHidden:NO];
}

- (void)initSubView {
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds) * 2, CGRectGetHeight(self.scrollView.bounds));
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    
    ActiveSubViewController *controller1 = [self.storyboard instantiateViewControllerWithIdentifier:@"ActiveSubView"];
    RecallSubViewController *controller2 = [self.storyboard instantiateViewControllerWithIdentifier:@"RecallSubView"];
    
    controller1.view.frame =  CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    controller2.view.frame =  CGRectMake(CGRectGetWidth(self.scrollView.bounds), 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    
    controller1.parentVC = self;
    controller2.parentVC = self;
    
    controller1.isHot = YES;
    controller2.isAll = YES;
    controller2.newsType = NewsTypeStrategy;
    
    [self.scrollView addSubview:controller1.view];
    [self.scrollView addSubview:controller2.view];
    
    [self addChildViewController:controller1];
    [self addChildViewController:controller2];
    [self.segment setSelectedSegmentIndex:0 animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _navigationBarBackgroundStyle = NavigationBarBackgroundStyleWhite;
    
    self.segment = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"活动",@"攻略"]];
    self.segment.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 44);
    self.segment.font = [UIFont systemFontOfSize:16];
    self.segment.textColor = color_with_hex(kColor_8e949b);
    self.segment.selectedTextColor = color_with_hex(kColor_ff9933);
    self.segment.selectionIndicatorColor = color_with_hex(kColor_ff9933);
    self.segment.selectionIndicatorHeight = 2;
    self.segment.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [self.segment addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segment];
    
    /// 未知 需要延迟才能获取到真实屏幕宽度
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initSubView];
    });
}

- (void)segmentControlValueChanged:(HMSegmentedControl *)segment {
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex * CGRectGetWidth(self.view.bounds), 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.segment setSelectedSegmentIndex:scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.bounds) animated:YES];
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
