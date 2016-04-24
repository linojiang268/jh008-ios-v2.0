//
//  MyActiveViewController.m
//  Gather
//
//  Created by apple on 15/1/31.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "MyActiveViewController.h"
#import "HMSegmentedControl.h"
#import "MyApplyViewController.h"
#import "MyCheckInViewController.h"
#import "MyCommentViewController.h"
#import "MyFocusActiveViewController.h"

@interface MyActiveViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segment;

@end

@implementation MyActiveViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [((UIView *)self.navigationController.navigationBar.subviews.firstObject).subviews.lastObject setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [((UIView *)self.navigationController.navigationBar.subviews.firstObject).subviews.lastObject setHidden:NO];
}

- (void)initSubView {
    
#pragma mark - 2.2 去掉签到
   
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds) * 3, CGRectGetHeight(self.scrollView.bounds));
    self.scrollView.delegate = self;
    
    MyApplyViewController *controller1 = [self.storyboard instantiateViewControllerWithIdentifier:@"MyApply"];
    //MyCheckInViewController *controller2 = [self.storyboard instantiateViewControllerWithIdentifier:@"MyCheckIn"];
    MyCommentViewController *controller3 = [self.storyboard instantiateViewControllerWithIdentifier:@"MyComment"];
    MyFocusActiveViewController *controller4 = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFocusActive"];
    
    controller1.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    //controller2.view.frame = CGRectMake(CGRectGetWidth(self.scrollView.bounds), 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    controller3.view.frame = CGRectMake(CGRectGetWidth(self.scrollView.bounds), 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    controller4.view.frame = CGRectMake(CGRectGetWidth(self.scrollView.bounds) * 2, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    
    controller1.parentVC = self;
    //controller2.parentVC = self;
    controller3.parentVC = self;
    controller4.parentVC = self;
    
    controller1.userId = self.userId;
    //controller2.userId = self.userId;
    controller3.userId = self.userId;
    controller4.userId = self.userId;
    
    [self.scrollView addSubview:controller1.view];
    //[self.scrollView addSubview:controller2.view];
    [self.scrollView addSubview:controller3.view];
    [self.scrollView addSubview:controller4.view];
    
    [self addChildViewController:controller1];
    //[self addChildViewController:controller2];
    [self addChildViewController:controller3];
    [self addChildViewController:controller4];
    
    [self.segment setSelectedSegmentIndex:0 animated:YES];
}
   
- (void)viewDidLoad {
        [super viewDidLoad];
        
    _navigationBarBackgroundStyle = NavigationBarBackgroundStyleWhite;
    
    self.segment = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"已报名",@"已评论",@"已关注"]];
    self.segment.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 44);
    self.segment.font = [UIFont systemFontOfSize:18];
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

@end
