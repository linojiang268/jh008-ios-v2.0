//
//  GroupEmptyView.h
//  Gather
//
//  Created by apple on 15/3/18.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupEmptyView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (instancetype)viewWithTitle:(NSString *)title;

@end
