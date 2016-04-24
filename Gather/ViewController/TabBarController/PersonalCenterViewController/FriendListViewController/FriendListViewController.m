//
//  FriendListViewController.m
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "FriendListViewController.h"
#import "HMSegmentedControl.h"
#import "MyFocusFriendViewController.h"
#import "MyFansViewController.h"

@interface FriendListViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segment;

@property (nonatomic, strong) MyFocusFriendViewController *myFocusController;
@property (nonatomic, strong) MyFansViewController *myFansController;

@end

@implementation FriendListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [((UIView *)self.navigationController.navigationBar.subviews.firstObject).subviews.lastObject setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [((UIView *)self.navigationController.navigationBar.subviews.firstObject).subviews.lastObject setHidden:NO];
}

- (void)initSubView {
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds) * 2, CGRectGetHeight(self.scrollView.bounds));
    
    self.myFocusController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFocusFriend"];
    self.myFansController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFans"];
    
    self.myFocusController.userId = self.userId;
    self.myFansController.userId = self.userId;
    
    self.myFocusController.parentVC = self;
    self.myFansController.parentVC = self;
    
    self.myFocusController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    self.myFansController.view.frame = CGRectMake(CGRectGetWidth(self.scrollView.bounds), 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    
    [self.scrollView addSubview:self.myFocusController.view];
    [self.scrollView addSubview:self.myFansController.view];
    [self addChildViewController:self.myFocusController];
    [self addChildViewController:self.myFansController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationBarBackgroundStyle = NavigationBarBackgroundStyleWhite;
    
    NSArray *titles = @[@"我的关注",@"我的粉丝"];
    if (self.userId > 0) {
        titles = @[@"TA的关注",@"TA的粉丝"];
    }
    
    self.segment = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
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


@end
