//
//  UploadHeadPortraitsViewController.h
//  Gather
//
//  Created by Ray on 14-12-24.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "BaseLoginViewController.h"

@interface UploadHeadPortraitsViewController : BaseLoginViewController

@property (nonatomic ,copy) NSString *phoneNumber;
@property (nonatomic ,strong) NSString *nickname;
@property (nonatomic ,strong) NSString *birthDay;
@property (nonatomic ,strong) NSString *password;
@property (nonatomic ,assign) Sex sex;

@property (nonatomic, assign) BOOL isPhoneRegistered;

@end
