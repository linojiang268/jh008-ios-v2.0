//
//  InputARowInfoViewControlller.h
//  Gather
//
//  Created by apple on 14/12/29.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSUInteger, InputType) {
    InputTypeNickname       = 1,
    InputTypeHobby          = 2,
    InputTypeSignature      = 3,
    InputTypeName           = 4,
    InputTypeContactNumber  = 5,
    InputTypeAddress        = 6,
    InputTypeSex            = 7,
    InputTypeAge            = 8,
    InputTypeHeadImage      = 9
};

@interface InputARowInfoViewControlller : BaseTableViewController

@property (nonatomic, assign) InputType inputType;
@property (nonatomic, strong) NSString *currentValue;
@property (nonatomic, copy) void(^inputDoneHandler)(InputType inputType,NSString *value);

@end
