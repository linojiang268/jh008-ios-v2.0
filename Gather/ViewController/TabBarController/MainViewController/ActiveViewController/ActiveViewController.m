//
//  ActiveViewController.m
//  Gather
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveViewController.h"
#import <HMSegmentedControl.h>
#import "Network+ActiveTagList.h"
#import "ActiveSubViewController.h"
#import "SearchViewController.h"
#import "NearbyActiveController.h"

@interface ActiveViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segment;

@property (nonatomic, strong) NSArray *tagArray;

@end

@implementation ActiveViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [((UIView *)self.navigationController.navigationBar.subviews.firstObject).subviews.lastObject setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [((UIView *)self.navigationController.navigationBar.subviews.firstObject).subviews.lastObject setHidden:NO];
}

- (void)initSubView {
    
    if (self.tagArray && self.tagArray.count > 0) {
        
        __weak typeof(self) wself = self;
        [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"附近" clickHandler:^(BlockBarButtonItem *item) {
            
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status || ![CLLocationManager locationServicesEnabled]) {
                [SVProgressHUD showInfoWithStatus:@"请先开启定位功能"];
            }else {
                NearbyActiveController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"NearbyActive"];
                [wself.navigationController pushViewController:controller animated:YES];
            }
        }]];
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds) * self.tagArray.count, CGRectGetHeight(self.scrollView.bounds));
        self.scrollView.delegate = self;
        
        NSMutableArray *tags = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.tagArray.count; i++) {
            
            ActiveTagEntity *tag = self.tagArray[i];
            [tags addObject:tag.name];
            
            ActiveSubViewController *subViewControler = [self.storyboard instantiateViewControllerWithIdentifier:@"ActiveSubView"];
            subViewControler.view.frame = CGRectMake(i * CGRectGetWidth(self.scrollView.bounds), 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
            subViewControler.parentVC = self;
            subViewControler.activeClassifyId = tag.id;
            [self.scrollView addSubview:subViewControler.view];
            [self addChildViewController:subViewControler];
        }
        self.segment.sectionTitles = tags;
        [self.segment setSelectedSegmentIndex:0 animated:YES];
        
        if (self.tagArray.count == 1) {
            [self.segment setHidden:YES];
            [self.view.constraints enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLayoutConstraint *layout = obj;
                if (layout.constant == 44) {
                    layout.constant = 0;
                }
            }];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationBarBackgroundStyle = NavigationBarBackgroundStyleWhite;
    
    self.segment = [[HMSegmentedControl alloc] initWithSectionTitles:nil];
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
    
    __weak typeof(self) wself = self;
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"搜索" clickHandler:^(BlockBarButtonItem *item) {
        
        SearchViewController *controler = [wself.storyboard instantiateViewControllerWithIdentifier:@"Search"];
        controler.searchType = SearchTypeActive;
        [wself.navigationController pushViewController:controler animated:YES];
    }]];
    
    SHOW_LOAD_HUD;
    [Network getActiveTagListWithPage:1 size:kSize success:^(ActiveTagListEntity *entity) {
        DISMISS_HUD;
        [wself setTagArray:entity.tags];
        [wself initSubView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        
    }];
}

- (void)segmentControlValueChanged:(HMSegmentedControl *)segment {
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex * CGRectGetWidth(self.view.bounds), 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.segment setSelectedSegmentIndex:scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.bounds) animated:YES];
}

@end
