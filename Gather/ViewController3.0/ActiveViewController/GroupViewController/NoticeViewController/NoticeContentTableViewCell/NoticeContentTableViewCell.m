//
//  NoticeContentTableViewCell.m
//  Gather
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "NoticeContentTableViewCell.h"

@implementation NoticeContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentLabel.textColor = color_with_hex(kColor_8e949b);
    self.timeLabel.textColor = color_with_hex(kColor_8e949b);
}

@end
