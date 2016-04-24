//
//  BannerView.h
//  Gather
//
//  Created by Ray on 14-12-26.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 属性 imageArray 是一个数组，里边储存着要循环显示的图片信息
 如果 imageArray 成员若是 NSURL 类，则展示网络图片，网络图片未下载下来时，显示 属性placeholderImage图片
 如果 imageArray 成员若是 NSString 类，并且 NSString 类是以 "http://" 开头的，将该NSString视为一个有效网络图片链接，同上。
 如果 imageArray 成员若是 NSString 类，并且 NSString 类是不是以 "http://" 开头的，则将NSString视为一个有效本地图片名称，进行显示
 imageArray 中至少应该有一张图片，否则显示不正常
 
 属性 placeholderImage 是当网络图片未下载下来时，所显示的图片。该属性有默认值，可不设置
 
 */

@interface BannerView : UIView

@property (nonatomic,retain) NSArray *imageItems;                  // 要显示的图片信息数组
@property (nonatomic,retain) UIImage *currentImage;                // 当前显示的图片
@property (nonatomic,retain) UIImage *placeholderImage;            // 网络图片未下载下来时，显示该本地图片。该属性有默认值，可不设置
@property (nonatomic,assign) BOOL showPageControl;                 // Default YES.
@property (nonatomic,assign) UIViewContentMode imageViewContentMode;    // Default UIViewContentModeScaleAspectFill.

- (id)initWithFrame:(CGRect)frame handler:(void(^)(UIImageView *imageView,NSUInteger index))handler;
- (id)initWithFrame:(CGRect)frame handler:(void(^)(UIImageView *imageView,NSUInteger index))handler imageItems:(NSArray*)items;

- (void)enventHandler:(void(^)(UIImageView *imageView,NSUInteger index))handler;

@end
