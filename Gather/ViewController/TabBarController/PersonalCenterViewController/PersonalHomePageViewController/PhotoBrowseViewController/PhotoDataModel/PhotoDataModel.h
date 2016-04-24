//
//  PhotoDataModel.h
//  Gather
//
//  Created by apple on 15/2/28.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Network+Photos.h"

@interface PhotoDataModel : NSObject

@property (nonatomic, assign) NSUInteger userId;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) NSUInteger totalNumber;

- (void)receiveDataHandler:(void(^)(NSArray *photos))handler;
- (void)requestDataErrorHandler:(void(^)(void))handler;

- (void)getPhotoWall;
- (void)loadMorePhoto;

@end
