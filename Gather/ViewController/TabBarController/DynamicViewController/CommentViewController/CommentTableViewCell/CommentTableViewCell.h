//
//  DetailCommentTableViewCell.h
//  Gather
//
//  Created by apple on 15/1/14.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)setValue:(id)value;
- (void)showLine:(BOOL)show;

@end
