//
//  NoticeTitleTableViewCell.h
//  Gather
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTitleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) BOOL isExpand;

- (void)setReadStatus:(BOOL)flag;

@end
