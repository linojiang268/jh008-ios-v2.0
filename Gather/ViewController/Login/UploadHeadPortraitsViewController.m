//
//  UploadHeadPortraitsViewController.m
//  Gather
//
//  Created by Ray on 14-12-24.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "UploadHeadPortraitsViewController.h"
#import "ChooseInterestViewController.h"
#import "UIControl+Extend.h"
#import "Network+Account.h"
#import "Network+UploadFile.h"
#import "Network+UserInfo.h"

@interface UploadHeadPortraitsViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UIImage *_headImage;
    NSUInteger _headImageId;
}

@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@end

@implementation UploadHeadPortraitsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    circle_view(self.uploadButton);
    
    __weak typeof(self) wself = self;
    [self.uploadButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机拍照",@"相册选取", nil];
        [actionSheet showInView:wself.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightItemButtonClick {
    
    __weak typeof(self) wself = self;
    SHOW_LOAD_HUD;
    [Network uploadHeadImageWithImage:_headImage success:^(id response) {
        _headImageId = [response[@"body"][@"img_id"] intValue];
        [Network perfectInfoWithNickname:wself.nickname password:[[wself.password md5] lowercaseString] sex:wself.sex birthDay:wself.birthDay address:nil email:nil headImageId:_headImageId success:^(id response) {
            
            if (wself.isPhoneRegistered) {
                [Network loginWithPhoneNumber:wself.phoneNumber password:[[wself.password md5] lowercaseString] success:^(id response) {
                    DISMISS_HUD;
                    [Common setIsLogin:YES];
                    [Common setCurrentUsesrId:@([response[@"body"][@"uid"] intValue])];
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainView];
                    if ([Common getCurrentCityId] > 0) {
                        [Network getUserInfoWithUserId:[Common getCurrentUserId] cityID:[Common getCurrentCityId]
                                               success:^(FullUserInfoEntity *entity) {}
                                               failure:^(NSString *errorMsg, StatusCode code) {}];
                    }

                } failure:^(NSString *errorMsg, StatusCode code) {
                    [SVProgressHUD showErrorWithStatus:@"登录失败"];
                }];
            }else {
                 DISMISS_HUD;
                [Common setIsLogin:YES];
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainView];
                if ([Common getCurrentCityId] > 0) {
                    [Network getUserInfoWithUserId:[Common getCurrentUserId] cityID:[Common getCurrentCityId]
                                           success:^(FullUserInfoEntity *entity) {}
                                           failure:^(NSString *errorMsg, StatusCode code) {}];
                }
            }
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"上传失败，请重试"];
        }];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"上传失败，请重试"];
    }];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
     if(buttonIndex == 0) {
         [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];  /// 拍照
     }else if(buttonIndex == 1) {
         [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];  //从相册中选择
     }
}

 -(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
     _headImage =[info objectForKey:UIImagePickerControllerEditedImage];
     [self.uploadButton setImage:_headImage forState:UIControlStateNormal];
     [self.uploadButton setImage:_headImage forState:UIControlStateHighlighted];
     [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:13 forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: color_white, NSFontAttributeName: [UIFont systemFontOfSize:20]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: color_white} forState:UIControlStateNormal];
}

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
     NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
     if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0){
         
         [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
         [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:20]}];
         [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];
         
         NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
         UIImagePickerController *picker=[[UIImagePickerController alloc] init];
         picker.mediaTypes = mediatypes;
         picker.delegate = self;
         picker.allowsEditing = YES;
         picker.sourceType=sourceType;
         [self presentViewController:picker animated:YES completion:nil];
      }else {
          alert(nil, @"当前设备不支持拍摄功能");
      }
}

@end
