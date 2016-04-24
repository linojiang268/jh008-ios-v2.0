//
//  Network+IndividualityTagList.h
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "TagListEntity.h"

@interface Network (Tag)

+ (void)getTagListWithType:(TagType)tagType page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(TagListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
