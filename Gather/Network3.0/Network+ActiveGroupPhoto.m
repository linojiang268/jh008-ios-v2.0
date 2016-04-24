//
//  Network+ActiveGroupPhoto.m
//  Gather
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network+ActiveGroupPhoto.h"

@implementation Network (ActiveGroupPhoto)

+ (void)getActivePhotoWithActiveId:(NSUInteger)activeId cityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveGroupPhotoListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/albums_v2" params:@{@"actId":@(activeId), @"cityId": @(cityId), @"page": @(page), @"size": @(size)} responseClass:[ActiveGroupPhotoListEntity class] success:success failure:failure];
}

+ (void)getActivePhotoDetailListWithPhotoId:(NSUInteger)photoId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveGroupPhotoDetailListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self GET:@"act/actMore/photoes_v2" params:@{@"albumId":@(photoId), @"page": @(page), @"size": @(size)} responseClass:[ActiveGroupPhotoDetailListEntity class] success:success failure:failure];
}

+ (void)createPhotoWithActiveId:(NSUInteger)activeId name:(NSString *)name success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/actMore/createAlbum_v2" params:@{@"actId": @(activeId), @"subject": name} success:success failure:failure];
}

+ (void)addPhotoWithPhotoId:(NSUInteger)photoId photoArray:(NSArray *)photoArray success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure {
    [self POST:@"act/actMore/addPhoto_v2" params:@{@"albumId": @(photoId), @"imgIds": photoArray} success:success failure:failure];
}

@end
