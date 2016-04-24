//
//  Network+UploadFile.m
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+UploadFile.h"

@implementation Network (UploadFile)

+ (void)uploadHeadImageWithImage:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSString *, StatusCode))failure  {
    [self POST:@"user/userInfo/headImgUp" params:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image,0.5) name:@"headImg" fileName:@"img.jpg" mimeType:@"image/jpg"];
    } success:success failure:failure];
}

+ (void)uploadPhotoWithImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure; {
    [self POST:@"act/user/imgUp" params:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image,compressionQuality) name:@"img" fileName:@"img.jpg" mimeType:@"image/jpg"];
    } success:success failure:failure];
}

@end
