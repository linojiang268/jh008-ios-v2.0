//
//  BaseTableViewController.m
//  Gather
//
//  Created by Ray on 14-12-27.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

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
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor = color_with_hex(kColor_f8f8f8);
    
    _statusBarStyle = UIStatusBarStyleDefault;
    _interactivePopGestureRecognizerEnabled = YES;
    _navigationBarBackButtonStyle = NavigationBarBackButtonStyleYellow;
    
    if (self.navigationController.viewControllers.count > 1) {
        __weak typeof(self) wself = self;
        [wself.navigationController.interactivePopGestureRecognizer.rac_gestureSignal subscribeNext:^(id x) {
            UIScreenEdgePanGestureRecognizer *gesture = x;
            if (gesture.state == UIGestureRecognizerStateBegan) {
                wself.tableView.panGestureRecognizer.enabled = NO;
            }
            if (gesture.state != UIGestureRecognizerStateChanged) {
                wself.tableView.panGestureRecognizer.enabled = YES;
            }
        }];
    }
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

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}


#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
