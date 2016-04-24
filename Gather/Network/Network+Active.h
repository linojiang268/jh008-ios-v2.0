//
//  Network+Active.h
//  Gather
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Network.h"
#import "ActiveListEntity.h"
#import "NewsListEntity.h"
#import "StarListEntity.h"
#import "ActiveCommentListEntity.h"
#import "MyApplyActiveListEntity.h"

@interface Network (Active)

+ (void)getActiveListWithCityId:(NSUInteger)cityId tagId:(NSUInteger)tagId keyWords:(NSString *)keyWords startTime:(NSString *)startTime endTime:(NSString *)endTime page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getHotActiveListWithCityId:(NSUInteger)cityId  page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getNearbyActiveWithSearchType:(BaiduCloudSearchType)searchType location:(NSString *)location bounds:(NSString *)bounds filter:(NSString *)filter page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(NearbyActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;


+ (void)getActiveDetailWithId:(NSUInteger)activeId success:(void (^)(ActiveDetailEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getNewsWithActiveId:(NSUInteger)activeId typeId:(NewsType)typeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(NewsListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getStarWithActiveId:(NSUInteger)activeId cityId:(NSUInteger)cityId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(StarListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getCommentWithActiveId:(NSUInteger)activeId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveCommentListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)collectActiveWithId:(NSUInteger)activeId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)cancelCollectActiveWithId:(NSUInteger)activeId success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)applyWithActiveId:(NSUInteger)activeId name:(NSString *)name phone:(NSString *)phone peopleNumber:(NSUInteger)peopleNumber lon:(CGFloat)lon lat:(CGFloat)lat address:(NSString *)address success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)activeCommentWithActiveId:(NSUInteger)activeId content:(NSString *)content success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)activeShareWithActiveId:(NSUInteger)activeId shareType:(GatherShareType)shareType success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getMyApplyActiveWithUserId:(NSUInteger)userId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(MyApplyActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getMyCheckInActiveWithUserId:(NSUInteger)userId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(MyCheckInActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getMyCommentActiveWithUserId:(NSUInteger)userId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)getMyFocusActiveWithUserId:(NSUInteger)userId page:(NSUInteger)page size:(NSUInteger)size success:(void (^)(ActiveListEntity *entity))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)activeCheckInWithActiveId:(NSUInteger)activeId lon:(CGFloat)lon lat:(CGFloat)lat address:(NSString *)address success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

+ (void)tipOffWithCityId:(NSUInteger)cityId phone:(NSString *)phone address:(NSString *)address intro:(NSString *)intro imgIds:(NSArray *)imgIds lon:(CGFloat)lon lat:(CGFloat)lat locationAddress:(NSString *)locationAddress success:(void (^)(id response))success failure:(void (^)(NSString *errorMsg, StatusCode code))failure;

@end
