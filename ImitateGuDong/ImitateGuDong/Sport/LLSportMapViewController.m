//
//  LLSportMapViewController.m
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/21.
//  Copyright © 2016年 LL. All rights reserved.
//

#import "LLSportMapViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface LLSportMapViewController () <MAMapViewDelegate>

@end

@implementation LLSportMapViewController{
    /// 起始位置
    CLLocation *_startLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMapView];
}
#pragma mark - MAMapViewDelegate

// 位置或者设备位置更新后 调用此方法

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    // updatingLocation 表示是否是数据更新 YES :location 数据更新 NO:heading数据更新
    if (!updatingLocation) {
        return;
    }
    
    // 判断起始位置是否存在
    if (_startLocation == nil) {
        _startLocation = userLocation.location;
        // 实例化大头针
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc]init];
        annotation.coordinate = userLocation.location.coordinate;
        [mapView addAnnotation:annotation];
    }
}

// 更改定位大头针视图
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    // 判断大头针类型
    if (![annotation isKindOfClass:[MAPointAnnotation class]]) {
        return nil;
    }
    
    // 查询可用大头针视图
    static NSString *annotationId = @"annotationId";
    MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationId];
    // 如果没有
    if (annotationView == nil) {
        annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationId];
    }
    
    UIImage *image = _SportTracking.sportImage;
    annotationView.image = image;
    annotationView.centerOffset = CGPointMake(0, -image.size.height * 0.5);
    
    return annotationView;
}

#pragma mark - 设置界面
- (void)setupMapView{
    
    // 创建地图视图
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mapView];
    
    // 设置属性
    mapView.showsScale = NO; // 隐藏比例尺
    mapView.showsUserLocation = YES; // 显示用户的位置
    mapView.rotateCameraEnabled = NO; // 关闭相机旋转 能耗低
    mapView.userTrackingMode = MAUserTrackingModeFollow; // 跟踪用户
    mapView.allowsBackgroundLocationUpdates = YES; //允许后台定位 - 保证 Background Modes 中的 Location updates 处于选中状态
    mapView.pausesLocationUpdatesAutomatically = NO; // 不允许系统暂停位置更新
    mapView.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
