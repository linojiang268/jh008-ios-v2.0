//
//  ShareViewController.h
//  Gather
//
//  Created by apple on 15/1/31.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>

@interface ShareViewController : UIViewController

@property (nonatomic, assign) NSUInteger sharedId;
@property (nonatomic, strong) id<ISSContent> content;

- (void)cancelHandler:(void(^)(void))cancelHandler;

@end
