//
//  ShareTableViewCell.m
//  Gather
//
//  Created by apple on 15/1/28.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ShareTableViewCell.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApi.h>
#import "WXApi.h"

@interface ShareTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *weChatView;
@property (weak, nonatomic) IBOutlet UIView *weChatFriendsView;
@property (weak, nonatomic) IBOutlet UIView *qqZoneView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sinaWeiboMarginLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqZoneMarginRight;

@end

@implementation ShareTableViewCell

- (void)awakeFromNib {

    BOOL qqIsInstalled = [QQApi isQQInstalled];;
    BOOL wechatIsInstalled = [WXApi isWXAppInstalled];
    
    if (!wechatIsInstalled && !qqIsInstalled) {
        self.weChatView.hidden = YES;
        self.weChatFriendsView.hidden = YES;
        self.qqZoneView.hidden = YES;
        
        CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]) / 4;
        
        self.sinaWeiboMarginLeft.constant = (width * 2) - (width / 2);
        self.qqZoneMarginRight.constant = -((width * 2) - (width / 2));
    }else {
        if (!wechatIsInstalled) {
            self.weChatView.hidden = YES;
            self.weChatFriendsView.hidden = YES;
        }
        if (!qqIsInstalled) {
            
            CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]) / 4;
            self.sinaWeiboMarginLeft.constant = width / 2;
            self.qqZoneMarginRight.constant = -(width / 2);
            self.qqZoneView.hidden = YES;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
