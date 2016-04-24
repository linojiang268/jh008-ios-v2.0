//
//  NearbyActiveController.m
//  Gather
//
//  Created by apple on 15/2/10.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "NearbyActiveController.h"
#import "HMSegmentedControl.h"
#import "ActiveDetailViewController.h"
#import "Network+ActiveTagList.h"
#import "BMapKit.h"
#import "CustomPointAnnotation.h"
#import "Network+Active.h"

@interface NearbyActiveController ()<BMKMapViewDelegate, BMKCloudSearchDelegate> {
    BMKCloudSearch* _search;
}

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (nonatomic, strong) HMSegmentedControl *segment;
@property (nonatomic, strong) NSArray *tagArray;
@property (nonatomic, strong) NSMutableArray *infoArray;

@property (nonatomic, assign) BaiduCloudSearchType searchType;
@property (nonatomic, strong) NSString *boundsString;

@end

@implementation NearbyActiveController

- (void)dealloc {
    if (_search != nil) {
        _search = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [((UIView *)self.navigationController.navigationBar.subviews.firstObject).subviews.lastObject setHidden:YES];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [((UIView *)self.navigationController.navigationBar.subviews.firstObject).subviews.lastObject setHidden:NO];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _search.delegate = nil; // 不用时，置nil
    
}

- (void)setupSegmentTitle {
    
    if (self.tagArray && self.tagArray.count > 0) {
        NSMutableArray *tags = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.tagArray.count; i++) {
            
            ActiveTagEntity *tag = self.tagArray[i];
            [tags addObject:tag.name];
        }
        self.segment.sectionTitles = tags;
        [self.segment setSelectedSegmentIndex:0 animated:YES];
        
        if (self.tagArray.count == 1) {
            [self.segment setHidden:YES];
            [self.view.constraints enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLayoutConstraint *layout = obj;
                if (layout.constant == 44) {
                    layout.constant = 0;
                }
            }];
            _mapView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight([[UIScreen mainScreen] bounds]) - 64);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationBarBackgroundStyle = NavigationBarBackgroundStyleWhite;
    
    //初始化云检索服务
    _search = [[BMKCloudSearch alloc]init];
    // 设置地图级别
    [_mapView setZoomLevel:12];
    [_mapView setFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds])-104)];
    _mapView.isSelectedAnnotationViewFront = YES;
    
    self.searchType = BaiduCloudSearchTypeNearby;
    self.infoArray = [[NSMutableArray alloc] init];
    self.segment = [[HMSegmentedControl alloc] initWithSectionTitles:nil];
    self.segment.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 44);
    self.segment.font = [UIFont systemFontOfSize:16];
    self.segment.textColor = color_with_hex(kColor_8e949b);
    self.segment.selectedTextColor = color_with_hex(kColor_ff9933);
    self.segment.selectionIndicatorColor = color_with_hex(kColor_ff9933);
    self.segment.selectionIndicatorHeight = 2;
    self.segment.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [self.segment addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segment];
    
    __weak typeof(self) wself = self;
    [SVProgressHUD showWithStatus:@"正在定位"];
    [Common getCurrentLocationWithNeedReverseGeoCode:NO updateHandler:^(CLLocationCoordinate2D coor, LocationState state) {
        if (state == LocationStateEnd) {
            CustomPointAnnotation* item = [[CustomPointAnnotation alloc]init];
            CLLocationCoordinate2D pt = (CLLocationCoordinate2D){coor.latitude,coor.longitude};
            item.coordinate = pt;
            item.title = @"我";
            item.tag = 0;
            [_mapView addAnnotation:item];
            
            //移到屏幕中央
            _mapView.centerCoordinate = pt;
            
            [wself getTag];
        }
        if (state == LocationStateFailed) {
            [SVProgressHUD showErrorWithStatus:@"定位失败"];
            [wself.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)locationToSelf:(id)sender {
    [_mapView setCenterCoordinate:[Common getCurrentLocationCoordinate2D] animated:YES];
}

- (void)getTag {
    [SVProgressHUD showWithStatus:@"搜索活动中"];
    __weak typeof(self) wself = self;
    [Network getActiveTagListWithPage:1 size:kSize success:^(ActiveTagListEntity *entity) {
        [wself setTagArray:entity.tags];
        [wself setupSegmentTitle];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"搜索失败"];
    }];
}

- (void)segmentControlValueChanged:(HMSegmentedControl *)segment {
    
    ActiveTagEntity *entity = self.tagArray[segment.selectedSegmentIndex];
    [self searchNearbyWithActiveId:entity.id];
}

- (void)searchNearbyWithActiveId:(NSUInteger)activeId {
    CLLocationCoordinate2D coor = [Common getCurrentLocationCoordinate2D];
    NSString *location = [NSString stringWithFormat:@"%f,%f",coor.longitude,coor.latitude];
    NSString *filter = [NSString stringWithFormat:@"act_tag_id:%d,%d|act_city_id:%d,%d",activeId,activeId,[Common getCurrentCityId],[Common getCurrentCityId]];
    
    [SVProgressHUD showWithStatus:@"搜索活动中"];
    __weak typeof(self) wself = self;
    [Network getNearbyActiveWithSearchType:self.searchType location:location bounds:nil filter:filter page:0 size:kSize success:^(NearbyActiveListEntity *entity) {
        DISMISS_HUD;
        [wself.infoArray setArray:entity.contents];
        [wself refreshAnnotations];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"搜索失败"];
    }];
}

- (void)refreshAnnotations {
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    for (int i = 0; i < self.infoArray.count; i++) {
        NearbyActiveEntity *entity = [self.infoArray objectAtIndex:i];
        CustomPointAnnotation* item = [[CustomPointAnnotation alloc]init];
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){entity.lat,entity.lon};
        item.coordinate = pt;
        item.title = entity.title;
        item.tag = entity.act_id;
        [_mapView addAnnotation:item];
    }
    
    CustomPointAnnotation* item = [[CustomPointAnnotation alloc]init];
    CLLocationCoordinate2D pt = [Common getCurrentLocationCoordinate2D];
    item.coordinate = pt;
    item.title = @"我";
    item.tag = 0;
    [_mapView addAnnotation:item];
    
    //移到屏幕中央
    _mapView.centerCoordinate = pt;
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
    
    CustomPointAnnotation *item = (CustomPointAnnotation *)annotation;
    if (item.tag == 0) {
        ((BMKPinAnnotationView*)annotationView).image = image_with_name(@"img_active_nearby_self_pin");
        //((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorPurple;
    }else {
        ((BMKPinAnnotationView*)annotationView).image = image_with_name(@"img_active_nearby_pin");
        //((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
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

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    log_value(@"didAddAnnotationViews");
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}

/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    
    CustomPointAnnotation* annotation = (CustomPointAnnotation *)view.annotation;
    
    if (annotation.tag > 0) {
        ActiveDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ActiveDetail"];
        controller.activeId = annotation.tag;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];

    }
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
}
/**
 *双击地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回双击处坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    //CLLocationCoordinate2D leftBottomCoor = [mapView convertPoint:CGPointMake(0, CGRectGetHeight(mapView.bounds)) toCoordinateFromView:mapView];
    //CLLocationCoordinate2D rightUpCoor = [mapView convertPoint:CGPointMake(CGRectGetWidth(mapView.bounds), 0) toCoordinateFromView:mapView];
    //self.boundsString = [NSString stringWithFormat:@"%f,%f"];
}


@end
