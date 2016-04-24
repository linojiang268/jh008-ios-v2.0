//
//  BarcodeViewController.h
//  ZXingDemo
//
//  Created by CP_Kiwi on 14-5-5.
//  Copyright (c) 2014年 cpsoft. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface BarcodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

+ (id)controllerWithCompleteHandler:(void(^)(NSString *result))completeHandler;

@end
