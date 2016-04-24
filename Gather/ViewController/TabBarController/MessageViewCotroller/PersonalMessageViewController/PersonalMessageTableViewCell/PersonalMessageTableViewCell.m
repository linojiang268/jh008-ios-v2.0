//
//  PersonalMessageTableViewCell.m
//  Gather
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "PersonalMessageTableViewCell.h"

@interface PersonalMessageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *redPointView;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UILabel *lastContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;

@property (nonatomic, copy) void(^headImageTapHandler)(void);

@end

@implementation PersonalMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lastTimeLabel setTextColor:color_with_hex(kColor_808080)];
    [self.nicknameLabel setTextColor:color_with_hex(kColor_6e7378)];
    
    circle_view(self.headImage);
    circle_view(self.redPointView);
    
    self.headImage.userInteractionEnabled = YES;
    [self.headImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTap)]];
}

- (void)hideRedPoint:(BOOL)hide {
    self.redPointView.hidden = hide;
}

- (void)setHeadImageURL:(NSString *)imageURL {
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:placeholder_image];
}
- (void)setNickname:(NSString *)nickname {
    self.nicknameLabel.text = nickname;
}
- (void)setSex:(NSUInteger)sex {
    
    if (sex == 1) {
        self.sexImage.image = image_with_name(@"img_friend_list_sex_man");
    }
    if (sex == 2) {
        self.sexImage.image = image_with_name(@"img_friend_list_sex_woman");
    }
}
- (void)setLastContent:(NSString *)content {
    self.lastContentLabel.text = content;
}
- (void)setlastTime:(NSString *)time {
    
    /*NSString *timeString = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *currentDate = [dateFormatter dateFromString:time];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *curDateComponents = [calendar components:unitFlags fromDate:currentDate];
    
    if ([[NSDate date] timeIntervalSinceDate:currentDate] <= 24 * 60 * 60) {
        timeString = [NSString stringWithFormat:@"%d:%d",curDateComponents.hour,curDateComponents.minute];
    }else {
        timeString = [NSString stringWithFormat:@"%d月%d日 %d:%d",curDateComponents.month,curDateComponents.day,curDateComponents.hour,curDateComponents.minute];
    }
     */
    self.lastTimeLabel.text = time;
}

- (void)headImageTap {
    if (self.headImageTapHandler) {
        self.headImageTapHandler();
    }
}

- (void)setHeadImageTapHandler:(void (^)(void))headImageTapHandler
{
    _headImageTapHandler = headImageTapHandler;
}

@end
