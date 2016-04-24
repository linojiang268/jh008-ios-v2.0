//
//  GroupFirstHeaderView.h
//  Gather
//
//  Created by apple on 15/3/20.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupFirstHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

+ (instancetype)viewWithTitle:(NSString *)title time:(NSString *)time;

@end
