//
//  RoadmapViewController.m
//  Gather
//
//  Created by apple on 15/4/20.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "RoadmapViewController.h"
#import "BMapKit.h"
#import "CustomOverlayView.h"
#import "CustomOverlay.h"
#import "Network+Graphic.h"
#import "CustomPointAnnotation.h"

#import "NSDate+Extend.h"

@interface RoadmapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate> {
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    
    NSUInteger _second;
    BOOL _isFirstAddTeammateAnnotation;
}

@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (nonatomic, strong) ActiveRouteListEntity *routeInfo;
@property (nonatomic, strong) NSMutableArray *selfRouteArray;
@property (nonatomic, strong) NSMutableArray *selfErrorRouteArray;
@property (nonatomic, strong) NSMutableArray *teammateRouteArray;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL isBackground;
@property (nonatomic, assign) BOOL isAddBackground;

@end

@implementation RoadmapViewController

- (NSMutableArray *)selfErrorRouteArray {
    if (!_selfErrorRouteArray) {
        _selfErrorRouteArray = [[NSMutableArray alloc] init];
    }
    return _selfErrorRouteArray;
}

- (NSMutableArray *)selfRouteArray {
    if (!_selfRouteArray) {
        _selfRouteArray = [[NSMutableArray alloc] init];
    }
    return _selfRouteArray;
}

- (NSMutableArray *)teammateRouteArray {
    if (!_teammateRouteArray) {
        _teammateRouteArray = [[NSMutableArray alloc] init];
    }
    return _teammateRouteArray;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

//- (void)applicationWillResignActive {
//    self.isBackground = YES;
//}
//
//- (void)applicationWillEnterForeground {
//    self.isBackground = NO;
//    //[self addBackgroundRoutes];
//}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_mapView) {
        [self initMapView];
    }
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.routeInfo) {
        [self getRoutes];
    }
}

- (void)initMapView {
    _locService = [[BMKLocationService alloc]init];
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.zoomLevel = 15;
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    /*BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    displayParam.locationViewImgName = @"img_roadmap_self_point";//定位图标名称
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [_mapView updateLocationViewWithParam:displayParam];*/
    
    [self.view addSubview:_mapView];
    [self.view bringSubviewToFront:self.locationButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"比赛路线及队友位置"];
    
    _isFirstAddTeammateAnnotation = YES;
    _shouldTranslucentNavigationBar = NO;
    _interactivePopGestureRecognizerEnabled = NO;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (IBAction)locationButtonPressed:(id)sender {
    
    if (self.locationButton.selected) {
        [_locService stopUserLocationService];
    }else {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status || ![CLLocationManager locationServicesEnabled]) {
            [SVProgressHUD showInfoWithStatus:@"请先开启定位功能"];
        }else {
            [_locService stopUserLocationService];
            [_locService startUserLocationService];
        }
    }
}

- (void)timerEvent:(NSTimer *)timer {
    _second += 1;
}

- (void)getRoutes {
    
    [SVProgressHUD showWithStatus:@"获取路线图中"];
    __weak typeof(self) wself = self;
    [Network getActiveRoutesWithActiveId:self.activeId success:^(ActiveRouteListEntity *entity) {
        [SVProgressHUD showSuccessWithStatus:@"路线图获取成功"];
        wself.routeInfo = entity;
        [wself drawRoarmap];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"获取路线图失败"];
    }];
}

- (void)drawRoarmap {
    
    NSInteger count = self.routeInfo.act_route_points.count;
    
    ActiveRouteEntity *startPoint = [self.routeInfo.act_route_points firstObject];
    ActiveRouteEntity *endPoint = [self.routeInfo.act_route_points lastObject];
    
    CustomPointAnnotation* startPointAnnotation = [[CustomPointAnnotation alloc]init];
    startPointAnnotation.tag = -1;
    startPointAnnotation.coordinate = CLLocationCoordinate2DMake(startPoint.lat, startPoint.lng);
    [_mapView addAnnotation:startPointAnnotation];
    
    CustomPointAnnotation* endPointAnnotation = [[CustomPointAnnotation alloc]init];
    endPointAnnotation.tag = -2;
    endPointAnnotation.coordinate = CLLocationCoordinate2DMake(endPoint.lat, endPoint.lng);
    [_mapView addAnnotation:endPointAnnotation];
    
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(startPoint.lat, startPoint.lng) animated:YES];
    
    BMKMapPoint points[count];
    for (int i = 0; i < count; i++) {
        ActiveRouteEntity *entity = [self.routeInfo.act_route_points objectAtIndex:i];
        
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(entity.lat, entity.lng);
        BMKMapPoint point = BMKMapPointForCoordinate(coor);
        points[i] = point;
    }
    
    CustomOverlay *custom = [[CustomOverlay alloc] initWithPoints:points count:count];
    [_mapView addOverlay:custom];
}

//- (void)addBackgroundRoutes {
//    
//    self.isAddBackground = YES;
//    
//    NSInteger count = self.selfRouteArray.count;
//    BMKMapPoint points[count];
//    for (int i = 0; i < count; i++) {
//        ActiveRouteEntity *entity = [self.selfRouteArray objectAtIndex:i];
//        
//        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(entity.lat, entity.lng);
//        BMKMapPoint point = BMKMapPointForCoordinate(coor);
//        points[i] = point;
//    }
//    
//    CustomOverlay *custom = [[CustomOverlay alloc] initWithPoints:points count:count];
//    custom.isSelf = YES;
//    [_mapView addOverlay:custom];
//    
//    self.isAddBackground = NO;
//}

- (void)updateSelfRoutes {
    
    NSUInteger count = self.selfRouteArray.count;
    if (count >= 2) {
        
        ActiveRouteEntity *newEntity = [self.selfRouteArray lastObject];
        CLLocationCoordinate2D newCoor = CLLocationCoordinate2DMake(newEntity.lat, newEntity.lng);
//        if (!self.isBackground && !self.isAddBackground) {
//            ActiveRouteEntity *oldEntity = [self.selfRouteArray objectAtIndex:count - 2];
//            CLLocationCoordinate2D oldCoor = CLLocationCoordinate2DMake(oldEntity.lat, oldEntity.lng);
//            
//            BMKMapPoint oldPoint = BMKMapPointForCoordinate(oldCoor);
//            BMKMapPoint newPoint = BMKMapPointForCoordinate(newCoor);
//            BMKMapPoint points[2];
//            points[0] = oldPoint;
//            points[1] = newPoint;
//            
//            CustomOverlay *custom = [[CustomOverlay alloc] initWithPoints:points count:2];
//            custom.isSelf = YES;
//            [_mapView addOverlay:custom];
//        }
        
        if ((_second % 10 == 0) && self.timer.isValid) {
        
//            NSString *curDateString = [NSDate dateString];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:curDateString forKey:@"lastDate"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            log_value(@"last date:%@",curDateString);
            
            time_t loc_time;
            time(&loc_time);
            [Network uploadUserLocationWithLat:newCoor.latitude lon:newCoor.longitude loc_time:loc_time success:^(id response) {
                
            } failure:^(NSString *errorMsg, StatusCode code) {
                
            }];
            
            //if (!self.isBackground && !self.isAddBackground) {
                [self.selfRouteArray removeObjectsInRange:NSMakeRange(0, count-2)];
                [self getTeammateLocation];
            //}
        }
    }
}

- (void)getTeammateLocation {
    if (self.groupId > 0) {
        if (self.teammateRouteArray.count == 0) {
            [SVProgressHUD showWithStatus:@"获取队友位置中"];
        }
        __weak typeof(self) wself = self;
        [Network getGroupTeammateLocationWithGroupId:self.groupId success:^(ActiveRoadmapTeammateLocationListEntity *entity) {
            DISMISS_HUD;
            [wself.teammateRouteArray setArray:entity.locations];
            [wself updateTeammateAnnotation];
        } failure:^(NSString *errorMsg, StatusCode code) {
            if (wself.teammateRouteArray.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"获取队友位置失败"];
            }
        }];
    }
}

- (void)updateTeammateAnnotation {
    
    // 得到屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    
    int i = 0;
    for (ActiveRoadmapTeammateLocationEntity *entity in self.teammateRouteArray) {
        if (_isFirstAddTeammateAnnotation) {
            CustomPointAnnotation* pointAnnotation = [[CustomPointAnnotation alloc]init];
            pointAnnotation.tag = i;
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(entity.location_info.lat, entity.location_info.lng);
            [_mapView addAnnotation:pointAnnotation];
        }else {
            BMKAnnotationView *view = [_mapView viewForAnnotation:[array objectAtIndex:i]];
            [view.annotation setCoordinate:CLLocationCoordinate2DMake(entity.location_info.lat, entity.location_info.lng)];
        }
        
        i += 1;
    }
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    }
    
    CustomPointAnnotation *customAnnotation = (CustomPointAnnotation *)annotation;
    if (customAnnotation.tag >= 0) {
        ((BMKPinAnnotationView*)annotationView).image = image_with_name(@"img_roadmap_teammate_point");
        
        ActiveRoadmapTeammateLocationEntity *entity = [self.teammateRouteArray objectAtIndex:[(CustomPointAnnotation *)annotation tag]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        circle_view(imageView);
        [imageView sd_setImageWithURL:[NSURL URLWithString:entity.head_img_url] placeholderImage:placeholder_image];
        
        annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:imageView];
    }else {
        if (customAnnotation.tag == -1) {
             ((BMKPinAnnotationView*)annotationView).image = image_with_name(@"img_roadmap_start_point");
        }
        if (customAnnotation.tag == -2) {
             ((BMKPinAnnotationView*)annotationView).image = image_with_name(@"img_roadmap_end_point");
        }
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}

/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    
    //CustomPointAnnotation* annotation = (CustomPointAnnotation *)view.annotation;
    
    
}


- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[CustomOverlay class]])
    {
        CustomOverlayView* cutomView = [[CustomOverlayView alloc] initWithOverlay:overlay];
        
        if (((CustomOverlay *)overlay).isSelf) {
            cutomView.strokeColor = [UIColor colorWithHex:0xff3300];
            cutomView.fillColor = [UIColor blackColor];
        }else {
            cutomView.strokeColor = [UIColor colorWithHex:0x1e89ff];
            cutomView.fillColor = [UIColor blackColor];
        }
        
        cutomView.lineWidth = 3.8;
        
        return cutomView;
    }
    return nil;
}

/**
*在地图View将要启动定位时，会调用此函数
*@param mapView 地图View
*/
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
    [SVProgressHUD showWithStatus:@"正在获取当前位置"];
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [_mapView updateLocationData:userLocation];
    
    
    ActiveRouteEntity *newEntity = [[ActiveRouteEntity alloc] init];
    newEntity.lat = userLocation.location.coordinate.latitude;
    newEntity.lng = userLocation.location.coordinate.longitude;
    
//    ActiveRouteEntity *oldEntity = [self.selfRouteArray lastObject];
//    
//    CLLocationCoordinate2D oldCoor = CLLocationCoordinate2DMake(oldEntity.lat, oldEntity.lng);
//    BMKMapPoint oldPoint = BMKMapPointForCoordinate(oldCoor);
//    BMKMapPoint newPoint = BMKMapPointForCoordinate(userLocation.location.coordinate);
//    
//    CLLocationDistance distance = BMKMetersBetweenMapPoints(oldPoint, newPoint);
    
//    if (distance < 10 || self.selfErrorRouteArray.count >= 10) {
        [self.selfRouteArray addObject:newEntity];
//        [self.selfErrorRouteArray removeAllObjects];
        [self updateSelfRoutes];
//    }else {
//        [self.selfErrorRouteArray addObject:newEntity];
//    }
    if (!self.locationButton.selected) {
        [self.locationButton setSelected:YES];
        [SVProgressHUD showSuccessWithStatus:@"位置获取成功"];
        
        //NSString *curDateString = [NSDate dateString];
        
        //[[NSUserDefaults standardUserDefaults] setObject:curDateString forKey:@"fromDate"];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        
        //log_value(@"from date:%@",curDateString);
        
        [self getTeammateLocation];
        [self.timer fire];
    }
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
    
    [SVProgressHUD showSuccessWithStatus:@"停止定位"];
    [self.locationButton setSelected:NO];
    [self.timer invalidate];
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error %d___%@",error.code,error);
    if (!self.locationButton.selected) {
        [SVProgressHUD showErrorWithStatus:@"位置获取失败，请重试"];
    }
}


@end
