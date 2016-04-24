//
//  BaseCollectionCollectionViewController.m
//  Gather
//
//  Created by apple on 15/3/16.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseCollectionViewController.h"

@interface BaseCollectionViewController ()

@end

@implementation BaseCollectionViewController

- (void)addCustomNavigationBar {
    
    _shouldHideNavigationBar = YES;
    
    __weak typeof(self) wself = self;
    _customNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 64)];
    _customNavigationItem = [[UINavigationItem alloc] initWithTitle:self.title];
    [_customNavigationItem addLeftItem:[[BlockBarButtonItem alloc] initWithImage:BACK_IMAGE_YELLOW highlight:nil clickHandler:^(BlockBarButtonItem *item){
        [wself.navigationController popViewControllerAnimated:YES];
    }]];
    [_customNavigationBar pushNavigationItem:_customNavigationItem animated:NO];
    [self.view addSubview:_customNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = color_with_hex(kColor_f8f8f8);
    self.collectionView.backgroundColor = color_with_hex(kColor_f8f8f8);
    _interactivePopGestureRecognizerEnabled = YES;
    _navigationBarBackButtonStyle = NavigationBarBackButtonStyleYellow;
    [self setupGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIImage *image = nil;
    switch (_navigationBarBackgroundStyle) {
        case NavigationBarBackgroundStyleWhite:
            image = NAVIGATION_BAR_BACKGROUND_IMAGE_WHITE;
            break;
        case NavigationBarBackgroundStyleTranslucence:
            image = NAVIGATION_BAR_BACKGROUND_IMAGE_TRANSLUCENCE;
            break;
        case NavigationBarBackgroundStyleTranslucent:
            image = NAVIGATION_BAR_BACKGROUND_IMAGE_TRANSLUCENT;
            _interactivePopGestureRecognizerEnabled = NO;
            break;
    }
    if (self.navigationItem.leftBarButtonItems.count == 0 && self.navigationController.viewControllers.count > 1) {
        UIImage *image = nil;
        switch (_navigationBarBackButtonStyle) {
            case NavigationBarBackButtonStyleWhite:
                image = BACK_IMAGE_WHITE;
                break;
            case NavigationBarBackButtonStyleYellow:
                image = BACK_IMAGE_YELLOW;
                break;
        }
        __weak typeof(self) wself = self;
        self.navigationController.interactivePopGestureRecognizer.delegate = self.navigationController.viewControllers.firstObject;
        [self.navigationItem addLeftItem:[[BlockBarButtonItem alloc] initWithImage:image highlight:nil clickHandler:^(BlockBarButtonItem *item){
            [wself.navigationController popViewControllerAnimated:YES];
        }]];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:_shouldHideNavigationBar animated:YES];
    [self.navigationController.navigationBar setTranslucent:_shouldTranslucentNavigationBar];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:_interactivePopGestureRecognizerEnabled];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TalkingData trackPageBegin:self.title];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [TalkingData trackPageEnd:self.title];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognize {
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
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

#pragma mark <UICollectionViewDataSource>
/*
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}*/

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
