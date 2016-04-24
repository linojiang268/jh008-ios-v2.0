//
//  Network+Photos.h
//  Gather
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "PhotosEntity.h"

@interface Network (Photos)

+ (void)getPhotoWallWithUserId:(NSUInteger)userId success:(void (^)(PhotosEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getUserDynamicPhotoWithUserId:(NSUInteger)userId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(PhotosEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)updatePhotoWithImgIds:(NSArray *)imgIds success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
