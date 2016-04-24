//
//  Network+UploadFile.h
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"

@interface Network (UploadFile)

+ (void)uploadHeadImageWithImage:(UIImage *)image success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)uploadPhotoWithImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
