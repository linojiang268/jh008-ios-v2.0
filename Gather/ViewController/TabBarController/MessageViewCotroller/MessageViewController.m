//
//  MessageViewController.m
//  Gather
//
//  Created by Ray on 14-12-26.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "MessageViewController.h"
#import "SystemMessageViewController.h"
#import "PersonalMessageViewController.h"
#import "HMSegmentedControl.h"

@interface MessageViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segment;

@property (nonatomic, strong) SystemMessageViewController *systemMessageController;
@property (nonatomic, strong) PersonalMessageViewController *personalMessageController;

@end

@implementation MessageViewController

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
    
    self.systemMessageController = [[UIStoryboard messageStoryboard] instantiateViewControllerWithIdentifier:@"SystemMessage"];
    self.personalMessageController = [[UIStoryboard messageStoryboard] instantiateViewControllerWithIdentifier:@"PersonalMessage"];
    
    self.personalMessageController.parentVC = self;
    
    self.systemMessageController.view.frame = CGRectMake(CGRectGetWidth(self.scrollView.bounds), 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    self.personalMessageController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    
    [self.scrollView addSubview:self.systemMessageController.view];
    [self.scrollView addSubview:self.personalMessageController.view];
    
    [self addChildViewController:self.systemMessageController];
    [self addChildViewController:self.personalMessageController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationBarBackgroundStyle = NavigationBarBackgroundStyleWhite;
    
    self.segment = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"私信",@"系统消息"]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
