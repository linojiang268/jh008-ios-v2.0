//
//  CustomTextField.m
//  Gather
//
//  Created by Ray on 14-12-24.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
