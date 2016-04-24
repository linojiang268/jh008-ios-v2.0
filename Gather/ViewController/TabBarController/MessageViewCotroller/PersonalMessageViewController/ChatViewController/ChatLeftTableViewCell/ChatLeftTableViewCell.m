//
//  ChatLeftTableViewCell.m
//  Gather
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ChatLeftTableViewCell.h"

@interface ChatLeftTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeViewHeight;
@property (weak, nonatomic) IBOutlet UIView *timeView;

@property (nonatomic, copy) void(^copyActionHandler)(void);
@property (nonatomic, copy) void(^deleteActionHandler)(void);

@end

@implementation ChatLeftTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    circle_view(self.headImage);
    
    self.timeLabel.text = @" ";
    self.timeLabel.textColor = color_with_hex(kColor_6e7378);
    self.timeViewHeight.constant = 0;
    self.timeView.hidden = YES;
    self.timeView.backgroundColor = color_clear;
    self.contentLabel.textColor = color_with_hex(0x4d4d4d);
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    
    self.backgroundColor = color_with_hex(kColor_f8f8f8);
    
    UIImage *image = image_with_name(@"img_message_bubble_left");
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
    self.bubbleImageView.image = image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHeadImageURL:(NSString *)imageURL {
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:placeholder_image];
}

- (void)setContent:(NSString *)text {
    self.contentLabel.text = text;
}

- (void)setTime:(NSString *)stringTime {
    self.timeLabel.text = stringTime;
    self.timeViewHeight.constant = 21;
    self.timeView.hidden = NO;
}

- (void)hideTimeView {
    self.timeLabel.text = @" ";
    self.timeViewHeight.constant = 0;
    self.timeView.hidden = YES;
}

- (void)menuCopyAction:(void(^)(void))copyHandler deleteAction:(void(^)(void))deleteHandler {
    self.copyActionHandler = copyHandler;
    self.deleteActionHandler = deleteHandler;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:) || action == @selector(delete:)) {
        return YES;
    }
    return NO;
}

- (void)copy:(id)sender {
    if (self.copyActionHandler) {
        self.copyActionHandler();
    }
}

- (void)delete:(id)sender {
    if (self.deleteActionHandler) {
        self.deleteActionHandler();
    }
}


@end
