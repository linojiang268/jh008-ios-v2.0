//
//  PersonalHomePageHeaderView.m
//  Gather
//
//  Created by apple on 15/1/4.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "PersonalHomePageHeaderView.h"
#import <SVBlurView.h>
#import <UIImage+ImageEffects.h>

@interface PersonalHomePageHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *starImage;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UILabel *focusNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundHeadImage;

@property (weak, nonatomic) IBOutlet UIView *nicknameBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *focusAndFansBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *bottomStarView;
@property (weak, nonatomic) IBOutlet UIView *bottomOrdinaryView;

@property (nonatomic, copy) void(^focusOrFansHandler)(FriendType friendType);
@property (nonatomic, copy) void(^interviewClickHandler)(void);
@property (nonatomic, copy) void(^dynamicClickHandler)(void);
@property (nonatomic, copy) void(^activeClickHandler)(void);

@end

@implementation PersonalHomePageHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    circle_view(self.headImage);

    self.bottomStarView.hidden = YES;
    self.nicknameBackgroundView.backgroundColor = color_clear;
    self.focusAndFansBackgroundView.backgroundColor = color_clear;
    self.bottomOrdinaryView.backgroundColor = color_clear;
    self.bottomStarView.backgroundColor = color_clear;
    
    self.nicknameLabel.text = @"";
    self.focusNumberLabel.text = @"0";
    self.fansNumberLabel.text = @"0";
    
    self.parallaxHeaderView = [ParallaxHeaderView parallaxHeaderViewWithImage:[UIImage imageNamed:@"img_home_page_header_background.jpg"] forSize:CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight(self.frame))];
    [self.backgroundHeadImage addSubview:self.parallaxHeaderView];
}

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    if (self) {

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [self init];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)setHeadImageWithStringURL:(NSString *)stringURL {
    __weak typeof(self) wself = self;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:stringURL] placeholderImage:placeholder_image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            //[wself.parallaxHeaderView setHeaderImage:[image applyBlurWithRadius:10 tintColor:nil saturationDeltaFactor:1.5 maskImage:nil]];
            //wself.backgroundHeadImage.image = [image applyBlurWithRadius:10 tintColor:nil saturationDeltaFactor:1.5 maskImage:nil];
        }
    }];
}

- (void)setNickname:(NSString *)nickname {
    [self.nicknameLabel setText:nickname];
}

- (void)setSexWithIntSex:(int)intSex {
    
    if (intSex == 1) {
        [self.sexImage setImage:image_with_name(@"img_personal_home_page_sex_man")];
    }
    if (intSex == 2) {
        [self.sexImage setImage:image_with_name(@"img_personal_home_page_sex_woman")];
    }
}

- (void)setIsStar:(int)isStar {
    self.starImage.hidden = !isStar;
    self.bottomOrdinaryView.hidden = isStar;
    self.bottomStarView.hidden = !isStar;
}

- (void)setFocusNumber:(int)focusNumber {
    [self.focusNumberLabel setText:[@(focusNumber) stringValue]];
}

- (void)setFansNumber:(int)fansNumber {
    [self.fansNumberLabel setText:[@(fansNumber) stringValue]];
}


- (void)setFocusOrFansClickHandler:(void(^)(FriendType friendType))focusOrFansHandler
             interviewClickHandler:(void(^)(void))interviewClickHandler
               dynamicClickHandler:(void(^)(void))dynamicClickHandler
                activeClickHandler:(void(^)(void))activeClickHandler {
    self.focusOrFansHandler = focusOrFansHandler;
    self.interviewClickHandler = interviewClickHandler;
    self.dynamicClickHandler = dynamicClickHandler;
    self.activeClickHandler = activeClickHandler;
}

- (IBAction)focusButtonClick:(id)sender {
    if (self.focusOrFansHandler) {
        self.focusOrFansHandler(FriendTypeMyFocus);
    }
}

- (IBAction)fansButtonclick:(id)sender {
    if (self.focusOrFansHandler) {
        self.focusOrFansHandler(FriendTypeMyFans);
    }
}

- (IBAction)interviewButtonClick:(id)sender {
    if (self.interviewClickHandler) {
        self.interviewClickHandler();
    }
}

- (IBAction)dynamicButtonClick:(id)sender {
    if (self.dynamicClickHandler) {
        self.dynamicClickHandler();
    }
}

- (IBAction)activeButtonClick:(id)sender {
    if (self.activeClickHandler) {
        self.activeClickHandler();
    }
}

@end
