//
//  PublishDynamic.m
//  Gather
//
//  Created by apple on 15/1/19.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "PublishDynamic.h"
#import "Network.h"

@interface PublishDynamic ()

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSMutableArray *imgIds;

@property (nonatomic,strong) NSArray *imgNames;
@property (nonatomic,strong) DynamicCacheEntity *dynamicEntity;

@property (nonatomic, strong) id cancelNoti;

@end

@implementation PublishDynamic

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.cancelNoti];
}

- (instancetype)initWithDynamicEntity:(DynamicCacheEntity *)entity {
    self = [super init];
    if (self) {
        self.dynamicEntity = entity;
        self.index = 0;
        if (!string_is_empty(entity.imgNames)) {
            self.imgNames = [self.dynamicEntity.imgNames componentsSeparatedByString:@"|"];
            self.imgIds = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)notificationSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPUBLISH_SUCCESS_NOTIFICATION_NAME object:self.dynamicEntity];
}

- (void)notificationFailed {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPUBLISH_FAILED_NOTIFICATION_NAME object:self.dynamicEntity];
}

- (void)cancel {
    AFHTTPRequestOperationManager *manager = [Network manager];
    NSOperationQueue *queue = manager.operationQueue;
    
    [queue.operations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AFHTTPRequestOperation *operation = obj;
        
        if ([operation.name isEqualToString:self.dynamicEntity.create_time]) {
            [operation cancel];
        }
    }];
}

- (void)publish {
    
    self.cancelNoti = [[NSNotificationCenter defaultCenter] addObserverForName:kPUBLISH_CANCEL_NOTIFICATION_NAME object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        if ([self.dynamicEntity.create_time isEqualToString:note.object]) {
            [self cancel];
        }
    }];
    
    if (self.imgNames.count > 0) {
        [self uploadPhoto];
    }else {
        [self uploadContent];
    }
}

- (void)uploadContent {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:self.dynamicEntity.content forKey:@"content"];
    if (self.imgIds && self.imgIds.count > 0) {
        [param setObject:self.imgIds forKey:@"imgIds"];
    }
    
    AFHTTPRequestOperationManager *manager = [Network manager];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:@"act/dynamic/add" relativeToURL:manager.baseURL] absoluteString] parameters:param error:nil];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        log_value(@"response:%@____msg:%@",responseObject,responseObject[@"msg"]);
        NSUInteger statusCode = [responseObject[@"code"] intValue];
        if (statusCode == StatusCodeNone) {
            [self notificationSuccess];
        }else {
            [self notificationFailed];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        log_error(@"%@",error);
        [self notificationFailed];
    }];
    operation.name = self.dynamicEntity.create_time;
    [manager.operationQueue addOperation:operation];
}

- (void)uploadPhoto {
    AFHTTPRequestOperationManager *manager = [Network manager];
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:@"act/user/imgUp" relativeToURL:manager.baseURL] absoluteString] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = PUBLISH_IMAGE_WITH_NAME(self.imgNames[self.index]);
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image,1) name:@"img" fileName:@"img.jpg" mimeType:@"image/jpg"];
    } error:nil];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        log_value(@"response:%@____msg:%@",responseObject,responseObject[@"msg"]);
        
        NSUInteger statusCode = [responseObject[@"code"] intValue];
        if (statusCode == StatusCodeNone) {
            [self.imgIds addObject:responseObject[@"body"][@"img_id"]];
            self.index += 1;
            if (self.index < self.imgNames.count) {
                [self publish];
            }else if(self.index == self.imgNames.count){
                [self uploadContent];
            }
        }else {
            [self notificationFailed];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        log_error(@"%@",error);
        [self notificationFailed];
    }];
    operation.name = self.dynamicEntity.create_time;
    [manager.operationQueue addOperation:operation];
}

@end
