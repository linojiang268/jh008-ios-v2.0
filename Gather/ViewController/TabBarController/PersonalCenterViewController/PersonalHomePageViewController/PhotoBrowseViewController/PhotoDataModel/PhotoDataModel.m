//
//  PhotoDataModel.m
//  Gather
//
//  Created by apple on 15/2/28.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "PhotoDataModel.h"

@interface PhotoDataModel ()

@property (nonatomic, assign) NSUInteger photoWallNumber;
@property (nonatomic, assign) NSUInteger dynamicTotalNumber;

@property (nonatomic, strong) void(^receiveDataHandler)(NSArray *photos);
@property (nonatomic, strong) void(^requestDataErrorHandler)(void);

@end

@implementation PhotoDataModel

- (void)setPhotos:(NSMutableArray *)photos {
    _photos = photos;
}

- (void)addPhotos:(NSArray *)photos {
    if (!self.photos) {
        self.photos = [[NSMutableArray alloc] init];
    }
    [self.photos addObjectsFromArray:photos];
}

- (void)requestDataErrorHandler:(void(^)(void))handler {
    _requestDataErrorHandler = handler;
}

- (void)receiveDataHandler:(void (^)(NSArray *))handler {
    _receiveDataHandler = handler;
}

- (void)getPhotoWall {
    
    __weak typeof(self) wself = self;
    [Network getPhotoWallWithUserId:self.userId success:^(PhotosEntity *entity) {
        [wself addPhotos:entity.photos];
        [wself loadMorePhoto];
        [wself setPhotoWallNumber:entity.total_num];
    } failure:^(NSString *errorMsg, StatusCode code) {
        if (self.requestDataErrorHandler) {
            self.requestDataErrorHandler();
        }
    }];
}

- (void)loadMorePhoto {
    if (self.loading || ((self.photos && self.photos.count >= (self.dynamicTotalNumber + self.photoWallNumber)) && self.dynamicTotalNumber != 0)) {
        log_value(@"loading");
    }else {
        self.loading = YES;
        self.currentPage += 1;
        __weak typeof(self) wself = self;
        [Network getUserDynamicPhotoWithUserId:self.userId page:self.currentPage size:kSize success:^(PhotosEntity *entity) {
            
            log_value(@"load more page:%d",wself.currentPage);
            [wself addPhotos:entity.photos];
            [wself setLoading:NO];
            [wself setDynamicTotalNumber:entity.total_num];
            [wself setTotalNumber:(wself.photoWallNumber + wself.dynamicTotalNumber)];
            if (wself.receiveDataHandler && wself.photos && wself.photos.count > 0) {
                wself.receiveDataHandler(wself.photos);
            }
        } failure:^(NSString *errorMsg, StatusCode code) {
            if (self.requestDataErrorHandler) {
                self.requestDataErrorHandler();
            }
        }];
    }
}

@end
