//
//  FriendListTableViewCell.m
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "FriendListTableViewCell.h"

@interface FriendListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UIImageView *isStarImage;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;

@property (nonatomic, assign) NSUInteger isFocus;
@property (nonatomic, copy) void(^handler)(int currentFocusStatus);

@end


typedef NS_ENUM(NSUInteger, CellType) {
    CellTypeMyFocus = 1,
    CellTypeMyFans  = 2,
};

@implementation FriendListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    circle_view(self.headImage);
    
    self.nicknameLabel.textColor = color_with_hex(kColor_6e7378);
    self.nicknameLabel.textColor = color_with_hex(kColor_8e949b);
    
    self.focusButton.layer.masksToBounds = YES;
    self.focusButton.layer.borderWidth = 1.0;
    self.focusButton.layer.borderColor = [color_with_hex(kColor_ff9933) CGColor];
    self.focusButton.layer.cornerRadius = 3.0;
    [self.focusButton setTitleColor:color_with_hex(kColor_ff9933) forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHeadImageStringURL:(NSString *)stringURL {
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:stringURL] placeholderImage:placeholder_image];
}

- (void)setNickname:(NSString *)nickname {
    self.nicknameLabel.text = nickname;
}

- (void)setSexWithIntSex:(NSUInteger)intSex {
    if (intSex == 1) {
        self.sexImage.image = image_with_name(@"img_friend_list_sex_man");
    }
    if (intSex == 2) {
        self.sexImage.image = image_with_name(@"img_friend_list_sex_woman");
    }
}

- (void)setIsStar:(NSUInteger)isStar {
    self.isStarImage.hidden = !isStar;
}

- (void)setIntro:(NSString *)intro {
    self.introLabel.text =intro;
}

- (void)setIsFocus:(NSUInteger)isFocus {
    _isFocus = isFocus;
    if (isFocus) {
        [self.focusButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }else {
        [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
    }
}

- (IBAction)focusButtonClick:(id)sender {
    if (self.handler) {
        self.handler(self.isFocus);
    }
}

- (void)setAddOrCancelFocusHandler:(void(^)(int currentFocusStatus))handler {
    self.handler = handler;
}


@end
