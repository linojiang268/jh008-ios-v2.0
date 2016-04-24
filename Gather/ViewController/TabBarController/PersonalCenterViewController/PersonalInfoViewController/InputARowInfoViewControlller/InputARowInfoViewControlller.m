//
//  InputARowInfoViewControlller.m
//  Gather
//
//  Created by apple on 14/12/29.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "InputARowInfoViewControlller.h"

@interface InputARowInfoViewControlller ()

@property (weak, nonatomic) IBOutlet SZTextView *textView;

@end

@implementation InputARowInfoViewControlller

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textView.text = self.currentValue;
    
    NSString *placeholder = @"";
    switch (_inputType) {
        case InputTypeNickname:
            placeholder = @"请输入你的昵称（中英文开头 4-20字符）";
            break;
        case InputTypeSignature:
            placeholder = @"请输入签名";
            break;
        case InputTypeName:
            placeholder = @"请输入姓名";
            break;
        case InputTypeContactNumber:
            placeholder = @"请输入联系电话";
            break;
        case InputTypeAddress:
            placeholder = @"请输入地址";
            break;
        case InputTypeAge:
            placeholder = @"请输入年龄";
            break;
        case InputTypeHobby:
            placeholder = @"请输入爱好";
            break;
        default:
            break;
    }
    self.textView.placeholder = placeholder;
    
    if (_inputType == InputTypeAge) {
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker setMaximumDate:[NSDate date]];
        
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"yyyy-MM-dd"];
        
        self.textView.inputView = datePicker;
        self.textView.text = [f stringFromDate:[datePicker date]];
        __weak typeof(self) wself = self;
        [datePicker addEvent:UIControlEventValueChanged handler:^(id sender) {
            wself.textView.text = [f stringFromDate:[sender date]];
        }];
    }
    
    __weak typeof(self) wself = self;
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"确认" clickHandler:^(BlockBarButtonItem *item){
        [wself verify];
    }]];
}

- (void)verify {
    
    if (_inputType == InputTypeNickname) {
        if (string_is_empty(self.textView.text)) {
            alert(nil, @"请输入昵称");
            return;
        }
        if ([self.textView.text countWord] < 4 || [self.textView.text countWord] > 20) {
            alert(nil, @"昵称只能输入4-20位");
            return;
        }
    }
    if (_inputType == InputTypeContactNumber) {
        if (![self.textView.text validateMobile]) {
            alert(nil, @"请输入正确的电话号码");
            return;
        }
    }
    
    if (self.inputDoneHandler) {
        self.inputDoneHandler(_inputType,self.textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (_inputType) {
        case InputTypeHobby:
            return 150;
            break;
        case InputTypeSignature:
            return 150;
            break;
        case InputTypeContactNumber:
            self.textView.keyboardType = UIKeyboardTypeNumberPad;
        default:
            self.textView.scrollEnabled = NO;
            return 40;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.textView becomeFirstResponder];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
