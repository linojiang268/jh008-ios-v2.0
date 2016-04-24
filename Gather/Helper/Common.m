//
//  Common.m
//  Gather
//
//  Created by apple on 15/1/12.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "Common.h"
#import "FullUserInfoEntity.h"
#import "TagListEntity.h"
#import "NSUserDefaults+Extend.h"
#import "Network+Push.h"
#import "Network+UserInfo.h"
#import "Network+CityList.h"
#import "BPush.h"
#import "BMapKit.h"

@interface Common ()<BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, SKStoreProductViewControllerDelegate>

@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, assign) BOOL needReverseGeoCode;
@property (nonatomic, assign) NSUInteger locationCount;
@property (nonatomic, copy) void(^locationUpdateHandler)(CLLocationCoordinate2D coor,LocationState state);

@end

@implementation Common

- (BMKLocationService *)locService {
    if (!_locService) {
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
    }
    _locService.delegate = self;
    return _locService;
}

- (BMKGeoCodeSearch *)geoCodeSearch {
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    }
    _geoCodeSearch.delegate = self;
    return _geoCodeSearch;
}

+ (Common *)shared {
    static Common *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[Common alloc] init];
        _shared.locationCount = 0;
    });
    return _shared;
}

+ (void)getCurrentLocationWithNeedReverseGeoCode:(BOOL)flag updateHandler:(void(^)(CLLocationCoordinate2D coor,LocationState state))handler {
    
    if (handler) {
        [[self shared]setLocationUpdateHandler:handler];
    }
    [[self shared].geoCodeSearch setDelegate:nil];
    [[self shared] setNeedReverseGeoCode:flag];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (([self shared].locationCount > 0 && status != kCLAuthorizationStatusNotDetermined) || [self shared].locationCount == 0) {
        [[self shared].locService stopUserLocationService];
        [[self shared] startLocationService];
    }
}

- (void)startLocationService {
    self.locationCount += 1;
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status || ![CLLocationManager locationServicesEnabled]) {
        if (self.locationUpdateHandler) {
            self.locationUpdateHandler(CLLocationCoordinate2DMake(0, 0),LocationStateFailed);
            self.locationUpdateHandler = nil;
            log_value(@"LocationStateFailed:3333333333333");
        }
    }else {
        //启动LocationService
        [self.locService startUserLocationService];
    }
}

/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser {
    log_value(@"willStartLocatingUser");
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser {
    log_value(@"didStopLocatingUser");
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    log_value(@"%@",error);
    
    if (self.locationUpdateHandler) {
        self.locationUpdateHandler(CLLocationCoordinate2DMake(0, 0),LocationStateFailed);
        self.locationUpdateHandler = nil;
        log_value(@"LocationStateFailed:2222222222");
    }
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [Common setCurrentLocationCoordinate2D:userLocation.location.coordinate];
    if (self.locationUpdateHandler) {
        if (self.needReverseGeoCode) {
            self.locationUpdateHandler(userLocation.location.coordinate,LocationStateActive);
        }else {
            self.locationUpdateHandler(userLocation.location.coordinate,LocationStateEnd);
            self.locationUpdateHandler = nil;
        }
    }
    if (!self.needReverseGeoCode) {
        [self.locService stopUserLocationService];
        return;
    }
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [self.geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
        
        if (self.locationUpdateHandler) {
            self.locationUpdateHandler(CLLocationCoordinate2DMake(0, 0),LocationStateFailed);
            self.locationUpdateHandler = nil;
            
            log_value(@"LocationStateFailed:11111111111");
        }
        [self.geoCodeSearch setDelegate:nil];
        [self.locService stopUserLocationService];
    }
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    log_value(@"is GetReverseGeoCode");
    
    if (error == 0) {
        if (self.locationUpdateHandler) {
            self.locationUpdateHandler(result.location,LocationStateActive);;
        }
        [self.geoCodeSearch setDelegate:nil];
        [self.locService stopUserLocationService];
        [Common setCurrentCityName:result.addressDetail.city];
        [Common setCurrentFullAddress:result.address];
        
        __weak typeof(self) wself = self;
        void(^callblock)(NSArray *citys) = ^(NSArray *citys){
            __block BOOL exist = NO;
            __block int cityId = 0;
            __block NSString *cityName = @"";
            [citys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                CityEntity *entity = obj;
                
                if ([result.addressDetail.city hasPrefix:entity.name]) {
                    exist = YES;
                    cityId = entity.id;
                    cityName = entity.name;
                }
            }];
            
            if (exist) {
                [Common setCurrentCityId:@(cityId)];
                [Common setCurrentCityName:cityName];
                [Common setCurrentFullAddress:result.address];
                if ([Common isLogin]) {
                    [Network getUserInfoWithUserId:[Common getCurrentUserId] cityID:[Common getCurrentCityId]
                                           success:^(FullUserInfoEntity *entity) {}
                                           failure:^(NSString *errorMsg, StatusCode code) {}];
                }
            }
            if (wself.locationUpdateHandler) {
                wself.locationUpdateHandler(result.location,LocationStateEnd);;
                self.locationUpdateHandler = nil;
            }
        };
        
        CityListEntity *cityListEntity = [Common getCacheCityList];
        if (cityListEntity && [cityListEntity.cities count] > 0) {
            callblock(cityListEntity.cities);
        }else {
            [Network getCityListWithSuccess:^(CityListEntity *entity) {
                callblock([Common getCacheCityList].cities);
            } failure:^(NSString *errorMsg, StatusCode code) {
                
            }];
        }
    }else {
        log_value(@"errorCode:%d",error);
    }
}

+ (void)checkVersionUpdateWithManual:(BOOL)isManual {
    
    if (!NETWORK_REACHABLE && isManual && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        return;
    }
    
    if (isManual) {
        SHOW_LOAD_HUD;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        // 中国 http://itunes.apple.com/cn/lookup?id=appid 世界 http://itunes.apple.com/lookup?id=appid
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",kAPP_ID]]];
        [request setHTTPMethod:@"GET"];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isManual) {
                DISMISS_HUD;
            }
            
            if (response.length > 0) {
                NSDictionary *appInfo = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
                NSDictionary *onLineVersionInfo = [[appInfo objectForKey:@"results"] firstObject];
                
                NSString *trackViewUrl = [onLineVersionInfo objectForKey:@"trackViewUrl"];//地址trackViewUrl
                NSString *trackName = [onLineVersionInfo objectForKey:@"trackName"];//trackName
                
                NSString *onlineVersionString = [onLineVersionInfo objectForKey:@"version"];
                NSString *currentVersionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                
                NSArray *onlineVersionArray = [onlineVersionString componentsSeparatedByString:@"."];
                NSArray *currentVersionArray = [currentVersionString componentsSeparatedByString:@"."];
                
                if ([onlineVersionArray count] > 0 && [currentVersionArray count] > 0) {
                    
                    BOOL haveNewVersion = NO;
                    
                    for (int i = 0; i < onlineVersionArray.count; i++) {
                        
                        if (currentVersionArray.count > i) {
                            
                            NSUInteger onlineNumber = [[onlineVersionArray objectAtIndex:i] integerValue];
                            NSUInteger currentNumber = [[currentVersionArray objectAtIndex:i] integerValue];
                            
                            if (onlineNumber > currentNumber) {
                                haveNewVersion = YES;
                                break;
                            }else if (onlineNumber == currentNumber) {
                                continue;
                            }else {
                                break;
                            }
                            
                        }else {
                            haveNewVersion = YES;
                            break;
                        }
                    }
                    
                    if (haveNewVersion) {
                        
                        [[[BlockAlertView alloc] initWithTitle:trackName message:@"有新版本，是否更新！" handler:^(UIAlertView *alertView, NSUInteger index) {
                            
                            if (index) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
                            }
                            
                        } cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即更新"] show];
                        
                    }else {
                        if (isManual) {
                            alert(nil, @"当前已是最新版本");
                        }
                    }
                }
            }else {
                if (isManual) {
                    [SVProgressHUD showErrorWithStatus:@"版本信息获取失败"];
                }
            }
        });
    });
}

+ (void)skipToGradePageWithPresentingController:(UIViewController *)controller {
    //初始化控制器
    SKStoreProductViewController *storeProductViewContorller =[[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = [self shared];
    //模态弹出appstore
    [controller presentViewController:storeProductViewContorller animated:YES completion:^{}];
    [storeProductViewContorller loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: kAPP_ID}//appId唯一的
                                          completionBlock:^(BOOL result, NSError *error) {
                                              //block回调
                                              if(error){
                                                  NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
                                                  [SVProgressHUD showErrorWithStatus:@"获取应用信息失败"];
                                                  [storeProductViewContorller dismissViewControllerAnimated:YES completion:nil];
                                              }else{
                                                  
                                              }
                                          }
     ];
}

//取消按钮监听
-(void)productViewControllerDidFinish:(SKStoreProductViewController*)viewController{
    [viewController dismissViewControllerAnimated:YES completion:^{}];
}

+ (void)setIsLogin:(BOOL)flag {
    [NSUserDefaults setBool:flag forKey:kLOGIN_FLAG];
}

+ (BOOL)isLogin {
    return [NSUserDefaults boolForKey:kLOGIN_FLAG];
}

+ (void)saveSelfUserInfo:(NSDictionary *)userInfo {
    [NSUserDefaults setObject:userInfo forKey:kUSER_INFO_FLAG];
}

+ (FullUserInfoEntity *)getSelfUserInfo {
    NSDictionary *dict = [NSUserDefaults objectForKey:kUSER_INFO_FLAG];
    if (dict && [dict count] > 0) {
        return [[FullUserInfoEntity alloc] initWithDictionary:dict error:nil];
    }
    return nil;
}

+ (void)setCurrentUsesrId:(NSNumber *)userId {
    [NSUserDefaults setObject:userId forKey:kUSER_ID_FLAG];
}

+ (int)getCurrentUserId {
    return [[NSUserDefaults objectForKey:kUSER_ID_FLAG] intValue];
}

+ (void)saveCityList:(NSDictionary *)citys {
    [NSUserDefaults setObject:citys forKey:kCITYS_FLAG];
}

+ (CityListEntity *)getCacheCityList {
    
    NSDictionary *dict = [NSUserDefaults objectForKey:kCITYS_FLAG];
    if (dict && [dict count] > 0) {
        return [[CityListEntity alloc] initWithDictionary:dict error:nil];
    }
    return nil;
}

+ (void)setCurrentLocationCoordinate2D:(CLLocationCoordinate2D)coordinate {
    [NSUserDefaults setObject:@(coordinate.latitude) forKey:kCURRENT_LOCATOIN_LATITUDEl_FLAG];
    [NSUserDefaults setObject:@(coordinate.longitude) forKey:kCURRENT_LOCATOIN_LONGITUDE_FLAG];
}

+ (CLLocationCoordinate2D)getCurrentLocationCoordinate2D {
    CLLocationDegrees latitude = [[NSUserDefaults objectForKey:kCURRENT_LOCATOIN_LATITUDEl_FLAG] doubleValue];
    CLLocationDegrees longitude = [[NSUserDefaults objectForKey:kCURRENT_LOCATOIN_LONGITUDE_FLAG] doubleValue];
    CLLocationCoordinate2D coor;
    coor.latitude = latitude;
    coor.longitude = longitude;
    return coor;
}

+ (void)setCurrentCityId:(NSNumber *)cityId {
    [NSUserDefaults setObject:cityId forKey:kCURRENT_CITY_ID_FLAG];
    
    if ([BPush getUserId] > 0 && [Common isLogin]) {
        [Network setUpWithCityId:[cityId unsignedIntegerValue]
                        platform:PlatformTypeIos
                     baiduUserId:[BPush getUserId]
                  baiduChannelId:[BPush getChannelId]
                         success:^(id response) {}
                         failure:^(NSString *errorMsg, StatusCode code) {}];
        if ([Common isLogin] && [Common getCurrentUserId] > 0) {
            [Network getUserInfoWithUserId:[Common getCurrentUserId] cityID:[Common getCurrentCityId]
                                   success:^(FullUserInfoEntity *entity) {}
                                   failure:^(NSString *errorMsg, StatusCode code) {}];
        }
    }
}

+ (int)getCurrentCityId {
    return [[NSUserDefaults objectForKey:kCURRENT_CITY_ID_FLAG] intValue];
}

+ (void)setCurrentCityName:(NSString *)cityName {
    [NSUserDefaults setObject:cityName forKey:kCURRENT_CYTI_NAME_FLAG];
}

+ (NSString *)getCurrentCityName {
    return [NSUserDefaults objectForKey:kCURRENT_CYTI_NAME_FLAG];
}

+ (void)setCurrentFullAddress:(NSString *)address {
    [NSUserDefaults setObject:address forKey:kCURRENT_FULL_ADDRESS_FLAG];
}

+ (NSString *)getCurrentFullAddress {
    NSString *address = [NSUserDefaults objectForKey:kCURRENT_FULL_ADDRESS_FLAG];
    if (string_is_empty(address)) {
        return @"";
    }
    return address;
}

+ (void)setCategoryTagList:(NSDictionary *)list {
    [NSUserDefaults setObject:list forKey:kTAG_CATEGORY_LIST_FLAG];
}

+ (TagListEntity *)getCategoryList {
    NSDictionary *dict = [NSUserDefaults objectForKey:kTAG_CATEGORY_LIST_FLAG];
    if (dict && [dict count] > 0) {
        return [[TagListEntity alloc] initWithDictionary:dict error:nil];
    }
    return nil;
}

+ (void)setIndividualityTagList:(NSDictionary *)list {
    [NSUserDefaults setObject:list forKey:kTAG_INDIVIDUALITY_LIST_FLAG];
}

+ (TagListEntity *)getIndividualityTagList {
    NSDictionary *dict = [NSUserDefaults objectForKey:kTAG_INDIVIDUALITY_LIST_FLAG];
    if (dict && [dict count] > 0) {
        return [[TagListEntity alloc] initWithDictionary:dict error:nil];
    }
    return nil;
}

+ (NSString *)eventStringFromShareType:(NSUInteger)type {
    switch (type) {
        case GatherShareTypeSinaWeibo:
            return @"分享到新浪微博";
            break;
        case GatherShareTypeWeChat:
            return @"分享给微信好友";
            break;
        case GatherShareTypeWeChatFriend:
            return @"分享到微信朋友圈";
            break;
        case GatherShareTypeQQZone:
            return @"分享到QQ空间";
            break;
        default:
            break;
    }
    return @"未知分享类型";
}

@end

