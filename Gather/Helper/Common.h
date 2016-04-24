//
//  Common.h
//  Gather
//
//  Created by apple on 15/1/12.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <StoreKit/StoreKit.h>

typedef NS_ENUM(NSUInteger, LocationState) {
    LocationStateActive = 1,
    LocationStateFailed = 2,
    LocationStateEnd    = 3
};

@class TagListEntity;
@class CityListEntity;
@class FullUserInfoEntity;
@interface Common : NSObject

+ (Common *)shared;

+ (void)getCurrentLocationWithNeedReverseGeoCode:(BOOL)flag updateHandler:(void(^)(CLLocationCoordinate2D coor,LocationState state))handler;

+ (void)checkVersionUpdateWithManual:(BOOL)isManual;

+ (void)skipToGradePageWithPresentingController:(UIViewController *)controller;

+ (void)setIsLogin:(BOOL)flag;
+ (BOOL)isLogin;

+ (void)saveSelfUserInfo:(NSDictionary *)userInfo;
+ (FullUserInfoEntity *)getSelfUserInfo;

+ (void)setCurrentUsesrId:(NSNumber *)userId;
+ (int)getCurrentUserId;

+ (void)saveCityList:(NSDictionary *)citys;
+ (CityListEntity *)getCacheCityList;

+ (void)setCurrentLocationCoordinate2D:(CLLocationCoordinate2D)coordinate;
+ (CLLocationCoordinate2D)getCurrentLocationCoordinate2D;

+ (void)setCurrentCityId:(NSNumber *)cityId;
+ (int)getCurrentCityId;

+ (void)setCurrentCityName:(NSString *)cityName;
+ (NSString *)getCurrentCityName;

+ (void)setCurrentFullAddress:(NSString *)address;
+ (NSString *)getCurrentFullAddress;

+ (void)setCategoryTagList:(NSDictionary *)list;
+ (TagListEntity *)getCategoryList;

+ (void)setIndividualityTagList:(NSDictionary *)list;
+ (TagListEntity *)getIndividualityTagList;

+ (NSString *)eventStringFromShareType:(NSUInteger)type;

@end
