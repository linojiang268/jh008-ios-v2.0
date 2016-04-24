//
//  Network+ActiveGroupPhoto.h
//  Gather
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "ActiveGroupPhotoListEntity.h"
#import "ActiveGroupPhotoDetailListEntity.h"

@interface Network (ActiveGroupPhoto)

+ (void)getActivePhotoWithActiveId:(NSUInteger)activeId cityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveGroupPhotoListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getActivePhotoDetailListWithPhotoId:(NSUInteger)photoId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveGroupPhotoDetailListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)createPhotoWithActiveId:(NSUInteger)activeId name:(NSString *)name success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)addPhotoWithPhotoId:(NSUInteger)photoId photoArray:(NSArray *)photoArray success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
