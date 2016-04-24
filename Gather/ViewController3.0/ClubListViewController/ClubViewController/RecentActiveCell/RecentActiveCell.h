//
//  RecentActiveCell.h
//  Gather
//
//  Created by apple on 15/4/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentActiveCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;

- (void)setIsEnd:(BOOL)isEnd;

@end
 