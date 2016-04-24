//
//  MapViewController.m
//  Gather
//
//  Created by apple on 15/1/29.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "MapViewController.h"
#import "BMapKit.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>  {
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    
}

@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoor;

@end

@implementation MapViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;

    [self addPointAnnotation];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

//添加标注
- (void)addPointAnnotation
{
    BMKPointAnnotation* pointAnnotation;
    if (pointAnnotation == nil) {
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        pointAnnotation.coordinate = self.endCoor;
        pointAnnotation.title = self.endName;
        
        _mapView.centerCoordinate = self.endCoor;
    }
    [_mapView addAnnotation:pointAnnotation];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shouldTranslucentNavigationBar = NO;
    
    _locService = [[BMKLocationService alloc]init];
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.zoomLevel = 15;
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    [self.view addSubview:_mapView];
    [self.view bringSubviewToFront:self.locationButton];
    
    __weak typeof(self) wself = self;
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"导航" clickHandler:^(BlockBarButtonItem *item) {
        [wself nav];
    }]];
}
- (IBAction)locationToSelf:(id)sender {
    [_locService stopUserLocationService];
    [_locService startUserLocationService];
    
    if (self.currentCoor.latitude > 0 || self.currentCoor.longitude > 0) {
        [_mapView setCenterCoordinate:self.currentCoor animated:YES];
    }
}

- (void)nav {
    
    BOOL baiduMapIsInstall = NO;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
        baiduMapIsInstall = YES;
    }
    
    if (!baiduMapIsInstall) {
        [self appleNav];
    }else {
        
        @weakify(self);
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"使用系统自带地图导航",@"使用百度地图导航", nil];
        [action showInView:self.view];
        [[action rac_buttonClickedSignal] subscribeNext:^(id x) {
            @strongify(self);
            NSUInteger index = [x unsignedIntegerValue];
            if (index == 0) {
                [self appleNav];
            }
            if (index == 1) {
                [self baiduNav];
            }
        }];
    }
}

- (void)appleNav {
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.endCoor addressDictionary:nil]];
    toLocation.name = self.endName;
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}

- (void)baiduNav {
    BMKNaviPara *para = [[BMKNaviPara alloc] init];
    para.naviType = BMK_NAVI_TYPE_NATIVE;
    para.appScheme = @"gather://gather.zero2all.com";
    
    BMKPlanNode *startNode = [[BMKPlanNode alloc] init];
    startNode.pt = self.currentCoor;
    para.startPoint = startNode;
    
    BMKPlanNode *endNode = [[BMKPlanNode alloc] init];
    endNode.pt = self.endCoor;
    endNode.name = self.endName;
    para.endPoint = endNode;
    
    [BMKNavigation openBaiduMapNavigation:para];
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
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    ((BMKPinAnnotationView*)annotationView).image = image_with_name(@"img_active_nearby_pin");
    //((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
    
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
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
    if (!(self.currentCoor.latitude > 0 || self.currentCoor.longitude > 0)) {
        [SVProgressHUD showWithStatus:@"正在定位"];
    }
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
    DISMISS_HUD;
    [self setCurrentCoor:userLocation.location.coordinate];
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error %d___%@",error.code,error);
    DISMISS_HUD;
    //[SVProgressHUD showErrorWithStatus:@"当前位置定位失败，请检查定位服务是否开启"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
