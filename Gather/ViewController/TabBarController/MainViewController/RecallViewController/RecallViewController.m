//
//  RecallViewController.m
//  Gather
//
//  Created by apple on 15/1/30.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "RecallViewController.h"
#import "HMSegmentedControl.h"
#import "RecallSubViewController.h"
#import "Network+ActiveTagList.h"
#import "SearchViewController.h"

@interface RecallViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segment;

@property (nonatomic, strong) NSArray *tagArray;

@end

@implementation RecallViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [((UIView *)self.navigationController.navigationBar.subviews.firstObject).subviews.lastObject setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [((UIView *)self.navigationController.navigationBar.subviews.firstObject).subviews.lastObject setHidden:NO];
}

- (void)initSubView {
    
    if (self.tagArray && self.tagArray.count) {
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds) * self.tagArray.count, CGRectGetHeight(self.scrollView.bounds));
        self.scrollView.delegate = self;
        self.scrollView.bounces = NO;
        
        NSMutableArray *tags = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.tagArray.count; i++) {
            
            ActiveTagEntity *tag = self.tagArray[i];
            [tags addObject:tag.name];
            
            RecallSubViewController *subViewControler = [self.storyboard instantiateViewControllerWithIdentifier:@"RecallSubView"];
            subViewControler.view.frame = CGRectMake(i * CGRectGetWidth(self.scrollView.bounds), 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
            subViewControler.parentVC = self;
            subViewControler.tagId = tag.id;
            subViewControler.newsType = self.newsType;
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
        [wself showSearchView];
    }]];
    
    SHOW_LOAD_HUD;
    [Network getActiveTagListWithPage:1 size:kSize success:^(ActiveTagListEntity *entity) {
        DISMISS_HUD;
        [wself setTagArray:entity.tags];
        [wself initSubView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        
    }];
}

- (void)showSearchView {
    SearchViewController *controler = [self.storyboard instantiateViewControllerWithIdentifier:@"Search"];
    controler.searchType = SearchTypeNews;
    if (self.newsType == NewsTypeCollect) {
        controler.newsType = NewsTypeRecall;
    }else if (self.newsType == NewsTypeTicket) {
        controler.newsType = self.newsType;
    }
    [self.navigationController pushViewController:controler animated:YES];
}

- (void)segmentControlValueChanged:(HMSegmentedControl *)segment {
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex * CGRectGetWidth(self.view.bounds), 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.segment setSelectedSegmentIndex:scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.bounds) animated:YES];
}

@end
