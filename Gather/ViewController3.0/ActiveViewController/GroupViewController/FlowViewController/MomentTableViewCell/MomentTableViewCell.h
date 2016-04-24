//
//  MomentTableViewCell.h
//  Gather
//
//  Created by apple on 15/3/18.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MomentStatus) {
    MomentStatusIsNoSet         = 0,
    MomentStatusIsAboutToBegin  = 1,
    MomentStatusIsOngoing       = 2,
    MomentStatusIsEnd           = 3,
};

@interface MomentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectLabel;

- (void)setStatus:(MomentStatus)status;
- (void)hideBottomLineView:(BOOL)flag;

@end
