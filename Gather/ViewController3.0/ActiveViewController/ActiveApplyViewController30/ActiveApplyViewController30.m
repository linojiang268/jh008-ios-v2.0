//
//  ActiveApplyViewController30.m
//  Gather
//
//  Created by apple on 15/3/31.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveApplyViewController30.h"
#import "ActiveApplyTableViewCell30.h"
#import "ActiveConfigEntity.h"
#import "Network+Apply30.h"
#import "ActiveApplyFooterView.h"
#import "FullUserInfoEntity.h"
#import "ActiveApplySucceedViewController.h"
#import "SelectPayWayViewController.h"

@interface ActiveApplyViewController30 ()

@property (nonatomic, strong) ActiveApplyCustomFieldsListEntity *customFieldsEntity;

@property (nonatomic, strong) ActiveApplyFooterView *footerView;

@property (nonatomic, strong) NSMutableDictionary *params;

/// 是否已经完成支付
@property (nonatomic, assign) BOOL isPayEnd;

@end

@implementation ActiveApplyViewController30

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWE_CHAT_PAY_END_NOTIFICATION_NAME object:nil];
}

- (void)payEnd {
    self.isPayEnd = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isPayEnd = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payEnd) name:kWE_CHAT_PAY_END_NOTIFICATION_NAME object:nil];
    
    self.params = [[NSMutableDictionary alloc] init];
    
    self.footerView = [[ActiveApplyFooterView alloc] init];
    self.tableView.tableFooterView = self.footerView;
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if ([ActiveConfigEntity sharedConfig].show_pay == ActiveConfigStatusHasSet) {
        self.footerView.costLabel.text = [NSString stringWithFormat:@"%.2f",[ActiveMoreConfigEntity sharedMoreConfig].product.unit_price];
    }else {
        [self.footerView hideCostView];
    }
    
    __weak typeof(self) wself = self;
    [self.footerView.commitButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
        [wself verify];
    }];
    
    if ([ActiveConfigEntity sharedConfig].show_enroll_custom == ActiveConfigStatusHasSet) {
        [self requestCustomFields];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isPayEnd) {
        ActiveApplySucceedViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ApplySucceed"];
        controller.activeInfo = self.activeInfo;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)verify {

    NSMutableArray *keys = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    
    [self.params setObject:@(self.activeId) forKey:@"actId"];
    [self.params setObject:@([Common getCurrentLocationCoordinate2D].longitude) forKey:@"lon"];
    [self.params setObject:@([Common getCurrentLocationCoordinate2D].longitude) forKey:@"lon"];
    if (!string_is_empty([Common getCurrentFullAddress])) {
        [self.params setObject:[Common getCurrentFullAddress] forKey:@"address"];
    }
    
    for (int i = 0; i < [self.tableView numberOfRowsInSection:0]; i++) {
        ActiveApplyTableViewCell30 *cell = (ActiveApplyTableViewCell30 *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        switch (i) {
            case 0:
            {
                if (string_is_empty(cell.textFieldView.text)) {
                    [SVProgressHUD showInfoWithStatus:@"请输入姓名"];
                    return;
                }else {
                    [self.params setObject:cell.textFieldView.text forKey:@"name"];
                }
            }
                break;
            case 1:
                if (string_is_empty(cell.textFieldView.text)) {
                    [SVProgressHUD showInfoWithStatus:@"请输入生日"];
                    return;
                }else {
                    [self.params setObject:cell.textFieldView.text forKey:@"birth"];
                }
                break;
            case 2:
                if (string_is_empty(cell.textFieldView.text)) {
                    [SVProgressHUD showInfoWithStatus:@"数据异常，请稍后重试"];
                    return;
                }else {
                    [self.params setObject:@([cell.textFieldView.text intSexFromSelf]) forKey:@"sex"];
                }
                break;
            case 3:
                if (string_is_empty(cell.textFieldView.text)) {
                    [SVProgressHUD showInfoWithStatus:@"请输入联系电话"];
                    return;
                }else {
                    
                    if (![cell.textFieldView.text validateMobile]) {
                        [SVProgressHUD showInfoWithStatus:@"请输入正确的电话号码"];
                    }else {
                        [self.params setObject:cell.textFieldView.text forKey:@"phone"];
                    }
                }
                break;
            default:
            {
                if (([self.tableView numberOfRowsInSection:0] == (4 + self.customFieldsEntity.custom_keys.count + 1)) && i == ([self.tableView numberOfRowsInSection:0]-1)) {
                    [self.params setObject:cell.textFieldView.text forKey:@"withPeopleNum"];
                }else {
                    if (string_is_empty(cell.textFieldView.text)) {
                        NSInteger index = (i - 4);
                        ActiveApplyCustomFieldsEntity *entity = [self.customFieldsEntity.custom_keys objectAtIndex:index];
                        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"请输入%@",entity.subject]];
                        return;
                    }else {
                        
                        NSInteger index = (i - 4);
                        ActiveApplyCustomFieldsEntity *entity = [self.customFieldsEntity.custom_keys objectAtIndex:index];
                        [keys addObject:@(entity.id)];
                        [values addObject:cell.textFieldView.text];
                    }
                }
            }
                
                break;
        }
    }
    
    __weak typeof(self) wself = self;
    SHOW_LOAD_HUD;
    [Network appplyWithParams:self.params success:^(id response) {
        DISMISS_HUD;
        ActiveConfigEntity *config = [ActiveConfigEntity sharedConfig];
        if (config.show_pay == ActiveConfigStatusHasSet) {
            
            SelectPayWayViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"SelectPayWay"];
            controller.product = [ActiveMoreConfigEntity sharedMoreConfig].product;
            [wself.navigationController pushViewController:controller animated:YES];
        }else {
            ActiveApplySucceedViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"ApplySucceed"];
            controller.activeInfo = wself.activeInfo;
            [wself.navigationController pushViewController:controller animated:YES];
        }
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"提交失败，请重试"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestCustomFields {
    
    __weak typeof(self) wself = self;
    SHOW_LOAD_HUD;
    [Network getCustomFieldsListWithActiveId:self.activeId page:1 size:kActiveGroupSize success:^(ActiveApplyCustomFieldsListEntity *entity) {
        DISMISS_HUD;
        wself.customFieldsEntity = entity;
        [wself.tableView reloadData];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"获取报名信息失败"];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,35,0,35)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        int placeholder = 0;
        if ([ActiveMoreConfigEntity sharedMoreConfig].can_with_people == ActiveConfigStatusHasSet) {
            placeholder = 1;
        };
        
        return 4+self.customFieldsEntity.custom_keys.count+placeholder;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,35,0,35)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActiveApplyTableViewCell30 *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d",indexPath.row]];
    if (!cell) {
        cell = [[ActiveApplyTableViewCell30 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%d",indexPath.row]];
    }
    cell.textFieldView.textColor = color_with_hex(kColor_8e949b);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                cell.titleLabel.text = @"姓名:";
                if (string_is_empty(cell.textFieldView.text)) {
                    cell.textFieldView.text = [Common getSelfUserInfo].real_name;
                }
                break;
            case 1:
            {
                cell.titleLabel.text = @"生日:";
                
                UIDatePicker *datePicker = [[UIDatePicker alloc] init];
                [datePicker setDatePickerMode:UIDatePickerModeDate];
                [datePicker setMaximumDate:[NSDate date]];
                
                NSDateFormatter *f = [[NSDateFormatter alloc] init];
                [f setDateFormat:@"yyyy-MM-dd"];
                
                cell.textFieldView.inputView = datePicker;
                if (string_is_empty(cell.textFieldView.text)) {
                    cell.textFieldView.text = [[Common getSelfUserInfo].birth yearMonthDayString];
                }
                [datePicker addEvent:UIControlEventValueChanged handler:^(id sender) {
                    cell.textFieldView.text = [f stringFromDate:[sender date]];
                }];
            }
                break;
            case 2:
                cell.titleLabel.text = @"性别:";
                cell.textFieldView.text = [NSString sexFromInt:[Common getSelfUserInfo].sex];
                cell.textFieldView.enabled = NO;
                break;
            case 3:
                cell.titleLabel.text = @"电话:";
                if (string_is_empty(cell.textFieldView.text)) {
                    cell.textFieldView.text = [Common getSelfUserInfo].contact_phone;
                }
                cell.textFieldView.keyboardType = UIKeyboardTypeNumberPad;
                break;
            default:
            {
                if (([tableView numberOfRowsInSection:0] == (4 + self.customFieldsEntity.custom_keys.count + 1)) && indexPath.row == ([tableView numberOfRowsInSection:0]-1)) {
                    cell.titleLabel.text = @"随行人数:";
                    cell.textFieldView.text = @"0";
                    cell.textFieldView.keyboardType = UIKeyboardTypeNumberPad;
                }else {
                    NSInteger index = (indexPath.row - 4);
                    ActiveApplyCustomFieldsEntity *entity = [self.customFieldsEntity.custom_keys objectAtIndex:index];
                    cell.titleLabel.text = [entity.subject stringByAppendingString:@":"];
                    cell.textFieldView.text = @"";
                    cell.textFieldView.keyboardType = UIKeyboardTypeDefault;
                }
            }
                break;
        }
    }
    
    
    return cell;
}

@end
