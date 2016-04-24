//
//  DetailCommentTableViewCell.m
//  Gather
//
//  Created by apple on 15/1/14.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "DynamicCommentListEntity.h"

@interface CommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *backgroundColorView;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic, strong) DynamicCommentEntity *commentInfo;

@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.backgroundColorView setBackgroundColor:color_with_hex(kColor_f8f8f8)];
    [self.contentLabel setBackgroundColor:color_clear];
    self.contentLabel.textColor = color_with_hex(kColor_8e949b);
    [self.backgroundColorView addSubview:self.lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.backgroundColorView.bounds) - 20, 0.5)];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.backgroundColorView.bounds) - 20, 0.5)];
        _lineView.backgroundColor = color_with_hex(0xc9c9c9);
    }
    return _lineView;
}

- (void)showLine:(BOOL)show {
    self.lineView.hidden = !show;
}

- (void)setValue:(id)value {
    self.commentInfo = value;
    
    UIColor *nicknameColor = color_with_hex(0x29abe2);
    UIColor *fontColor = color_with_hex(kColor_8e949b);
    UIFont *font = [UIFont systemFontOfSize:14];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    if (self.commentInfo.at_id <= 0) {
        [attString setAttributedString:[[NSAttributedString alloc] initWithString:self.commentInfo.author_user.nick_name attributes:@{NSForegroundColorAttributeName: nicknameColor, NSFontAttributeName: font}]];
    }else {
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:self.commentInfo.author_user.nick_name attributes:@{NSForegroundColorAttributeName: nicknameColor,  NSFontAttributeName: font}]];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"回复" attributes:@{NSForegroundColorAttributeName: color_with_hex(kColor_808080), NSFontAttributeName: font}]];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:self.commentInfo.at_user.nick_name attributes:@{NSForegroundColorAttributeName: nicknameColor, NSFontAttributeName: font}]];
    }
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@":" attributes:@{NSForegroundColorAttributeName: fontColor, NSFontAttributeName: font}]];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:self.commentInfo.content attributes:@{NSForegroundColorAttributeName: fontColor, NSFontAttributeName: font}]];
    self.contentLabel.attributedText = attString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    [UIView animateWithDuration:0.1 animations:^{
        if (selected) {
            [self.backgroundColorView setBackgroundColor:[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1]];
        }else {
            [self.backgroundColorView setBackgroundColor:color_with_hex(kColor_f8f8f8)];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.backgroundColorView setBackgroundColor:color_with_hex(kColor_f8f8f8)];
        });
    }];
}

@end
