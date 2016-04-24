//
//  ActiveDetailHeaderView.h
//  Gather
//
//  Created by apple on 15/1/27.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerView.h"
#import "ParallaxHeaderView.h"

@interface ActiveDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet BannerView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shadowView;

@property (nonatomic, strong) ParallaxHeaderView *parallaxHeaderView;

@end
