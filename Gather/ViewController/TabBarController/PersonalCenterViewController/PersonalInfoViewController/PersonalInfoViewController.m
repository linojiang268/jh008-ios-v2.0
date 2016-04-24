//
//  UpdateInfoViewController.m
//  Gather
//
//  Created by apple on 14/12/29.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "InputARowInfoViewControlller.h"
#import "SignatureOrHobbyTableViewCell.h"
#import "SelectImageViewController.h"
#import "HeadImageTableViewCell.h"
#import "Network+UserInfo.h"
#import "Network+UploadFile.h"

@interface PersonalInfoViewController ()

@property (nonatomic ,strong) UIImage *headImage;

@property (nonatomic, strong) NSArray *sectionOneRowKeys;
@property (nonatomic, strong) NSArray *sectionTwoRowKeys;

@property (nonatomic, strong) FullUserInfoEntity *userInfoEntity;
@property (nonatomic, strong) SelectImageViewController *selectImageViewController;

@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userInfoEntity = [Common getSelfUserInfo];
    
    self.sectionOneRowKeys = @[@"headImage",@"nickname",@"sex",@"age",@"signatureOrHobbyCell",@"signatureOrHobbyCell"];
    self.sectionTwoRowKeys = @[@"name",@"contactNumber",@"address"];
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SignatureOrHobbyTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"signatureOrHobbyCell"];

    [self getUserInfo];
}

-(void)getUserInfo {
    __weak typeof(self) wself = self;
    if ([Common getCurrentCityId]) {
        [Network getUserInfoWithUserId:[Common getCurrentUserId] cityID:[Common getCurrentCityId] success:^(BaseEntity *entity) {
            wself.userInfoEntity = (FullUserInfoEntity *)entity;
            [wself.tableView reloadDataIfEmptyShowCueWordsView];
        } failure:^(NSString *errorMsg, StatusCode code) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)textHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font {
    
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = font;
    detailTextView.text = text;
    CGSize size = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];

    return size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return 10;
    return 25;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = indexPath.section == 0 ? self.sectionOneRowKeys[indexPath.row] : self.sectionTwoRowKeys[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    if (self.headImage) {
                        [(HeadImageTableViewCell *)cell setImage:self.headImage];
                    }else {
                         [(HeadImageTableViewCell *)cell setImageStringURL:self.userInfoEntity.head_img_url];
                    }
                }
                    break;
                case 1:
                {
                    cell.detailTextLabel.text = string(self.userInfoEntity.nick_name);
                }
                    break;
                case 2:
                {
                    cell.detailTextLabel.text = [NSString sexFromInt:self.userInfoEntity.sex];
                }
                    break;
                case 3:
                {
                    if (self.userInfoEntity.birth) {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                        NSDate *date = [dateFormatter dateFromString:string(self.userInfoEntity.birth)];
                        
                        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                        NSDate *startDate = date;
                        NSDate *endDate = [NSDate date];
                        unsigned int unitFlags = NSCalendarUnitYear;
                        NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
                        int year = [comps year];
                        
                        cell.detailTextLabel.text = string([@(year) stringValue]);
                    }
                }
                    break;
                case 4:
                {
                    SignatureOrHobbyTableViewCell *aCell = (SignatureOrHobbyTableViewCell *)cell;
                    
                    [aCell setCellType:CellTypeHobby];
                    [aCell.subTitleLabel setText:string(self.userInfoEntity.hobby)];
                    
                    /*CGFloat width = aCell.subTitleLabel.frame.size.width;
                    NSString *text = string(self.userInfoEntity.hobby);
                    UIFont *font = aCell.subTitleLabel.font;
                    
                    if ([self textHeightWithText:text width:width font:font] < 36) {
                        aCell.subTitleLabel.textAlignment = NSTextAlignmentRight;
                    }else {
                        aCell.subTitleLabel.textAlignment = NSTextAlignmentLeft;
                    }*/
                }
                    break;
                case 5:
                {
                    SignatureOrHobbyTableViewCell *aCell = (SignatureOrHobbyTableViewCell *)cell;
                    
                    [aCell setCellType:CellTypeSignature];
                    [aCell.subTitleLabel setText:string(self.userInfoEntity.intro)];
                    
                    /*CGFloat width = aCell.subTitleLabel.frame.size.width;
                    NSString *text = string(self.userInfoEntity.intro);
                    UIFont *font = aCell.subTitleLabel.font;
                    
                    if ([self textHeightWithText:text width:width font:font] < 36) {
                        aCell.subTitleLabel.textAlignment = NSTextAlignmentRight;
                    }else {
                        aCell.subTitleLabel.textAlignment = NSTextAlignmentLeft;
                    }*/
                }
                    break;
            }

        }
            break;
            case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.detailTextLabel.text = string(self.userInfoEntity.real_name);
                }
                    break;
                case 1:
                {
                    cell.detailTextLabel.text = string(self.userInfoEntity.contact_phone);
                }
                    break;
                case 2:
                {
                    cell.detailTextLabel.text = string(self.userInfoEntity.address);
                }
                    break;
            }
        }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) wself = self;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                self.selectImageViewController = [[SelectImageViewController alloc] initWithViewController:self getType:GetImageTypeEdited done:^(UIImage *image) {
                    if (image) {
                        [wself updateValue:image forInputType:InputTypeHeadImage];
                        [wself.tableView reloadDataIfEmptyShowCueWordsView];
                    }
                }];
                [self.selectImageViewController open];
            }
                break;
            case 4:
            {
                InputARowInfoViewControlller *inputView = [self.storyboard instantiateViewControllerWithIdentifier:@"inputARow"];
                inputView.inputDoneHandler = ^(InputType inputType,NSString *value) {
                    [wself updateValue:value forInputType:inputType];
                };
                inputView.inputType = InputTypeHobby;
                inputView.title = @"爱好";
                inputView.currentValue = self.userInfoEntity.hobby;
                [self.navigationController pushViewController:inputView animated:YES];
            }
                break;
            case 5:
            {
                InputARowInfoViewControlller *inputView = [self.storyboard instantiateViewControllerWithIdentifier:@"inputARow"];
                inputView.inputDoneHandler = ^(InputType inputType,NSString *value) {
                    [wself updateValue:value forInputType:inputType];
                };
                inputView.inputType = InputTypeSignature;
                inputView.title = @"个性签名";
                inputView.currentValue = self.userInfoEntity.intro;
                [self.navigationController pushViewController:inputView animated:YES];
            }
                break;
            default:
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)updateValue:(id)value forInputType:(InputType)inputType {
    
    NSString *key;
    switch (inputType) {
        case InputTypeHeadImage:
            key = @"headImgId";
            self.headImage = value;
            break;
        case InputTypeNickname:
            key = @"nickName";
            self.userInfoEntity.nick_name = value;
            break;
        case InputTypeSignature:
            key = @"intro";
            self.userInfoEntity.intro = value;
            break;
        case InputTypeName:
            key = @"realName";
            self.userInfoEntity.real_name = value;
            break;
        case InputTypeContactNumber:
            key = @"contactPhone";
            self.userInfoEntity.contact_phone = value;
            break;
        case InputTypeAddress:
            key = @"address";
            self.userInfoEntity.address = value;
            break;
        case InputTypeAge:
            key = @"birth";
            self.userInfoEntity.birth = [value stringByAppendingString:@" 00:00:00"];
            break;
        case InputTypeHobby:
            key = @"hobby";
            self.userInfoEntity.hobby = value;
            break;
        default:
            break;
    }
    [self.tableView reloadDataIfEmptyShowCueWordsView];
    [self updateUserInfoWithKey:key value:value];
}

- (void)updateUserInfoWithKey:(NSString *)key value:(NSString *)value {
    
    if ([key isEqualToString:@"headImgId"]) {
        [Network uploadHeadImageWithImage:_headImage success:^(id response) {
            NSUInteger headImageId = [response[@"body"][@"img_id"] intValue];
            [Network updateUserInfoWithParams:@{key: @(headImageId)} success:^(id response) {
                
            } failure:^(NSString *errorMsg, StatusCode code) {
                alert(nil, @"头像上传失败");
            }];
        } failure:^(NSString *errorMsg, StatusCode code) {
            alert(nil, @"头像上传失败");
        }];
    }else {
        [Network updateUserInfoWithParams:@{key: value} success:^(id response) {
            
        } failure:^(NSString *errorMsg, StatusCode code) {
            alert(nil, @"资料修改失败");
        }];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    InputARowInfoViewControlller *nextController = [segue destinationViewController];
    nextController.inputDoneHandler = ^(InputType inputType,NSString *value) {
        switch (inputType) {
            case InputTypeNickname:
                [self updateValue:value forInputType:inputType];
                break;
            case InputTypeName:
                [self updateValue:value forInputType:inputType];
                break;
            case InputTypeContactNumber:
                [self updateValue:value forInputType:inputType];
                break;
            case InputTypeAddress:
                [self updateValue:value forInputType:inputType];
                break;
            case InputTypeAge:
                [self updateValue:value forInputType:inputType];
                break;
            default:
                break;
        }
    };
    
    if ([segue.identifier isEqualToString:@"nickname"]) {
        nextController.inputType = InputTypeNickname;
        nextController.currentValue = self.userInfoEntity.nick_name;
        nextController.title = @"昵称";
    }else if ([segue.identifier isEqualToString:@"age"]) {
        nextController.inputType = InputTypeAge;
        nextController.currentValue = self.userInfoEntity.birth;
        nextController.title = @"年龄";
    }else if ([segue.identifier isEqualToString:@"name"]) {
        nextController.inputType = InputTypeName;
        nextController.currentValue = self.userInfoEntity.real_name;
        nextController.title = @"姓名";
    }else if ([segue.identifier isEqualToString:@"contactNumber"]) {
        nextController.inputType = InputTypeContactNumber;
                nextController.currentValue = self.userInfoEntity.contact_phone;
        nextController.title = @"联系电话";
    }else if ([segue.identifier isEqualToString:@"address"]) {
        nextController.inputType = InputTypeAddress;
        nextController.currentValue = self.userInfoEntity.address;
        nextController.title = @"通讯地址";
    }
}

@end
