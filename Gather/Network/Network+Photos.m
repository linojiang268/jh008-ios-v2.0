//
//  Network+Photos.m
//  Gather
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+Photos.h"

@implementation Network (Photos)

+ (void)getPhotoWallWithUserId:(NSUInteger)userId success:(void (^)(PhotosEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId > 0) {
        [params setObject:@(userId) forKey:@"uid"];
    }
    [params setObject:@"1" forKey:@"page"];
    [params setObject:@(kSize) forKey:@"size"];
    [self GET:@"act/user/photos" params:params responseClass:[PhotosEntity class] success:success failure:failure];
}

+ (void)getUserDynamicPhotoWithUserId:(NSUInteger)userId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(PhotosEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId > 0) {
        [params setObject:@(userId) forKey:@"uid"];
    }
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(size) forKey:@"size"];
    [self GET:@"act/dynamic/photos" params:params responseClass:[PhotosEntity class] success:success failure:failure];
}

+ (void)updatePhotoWithImgIds:(NSArray *)imgIds success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/user/updatePhotos" params:@{@"imgIds": imgIds} success:success failure:failure];
}

@end
