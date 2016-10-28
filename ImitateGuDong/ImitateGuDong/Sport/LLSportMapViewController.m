//
//  LLSportMapViewController.m
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/21.
//  Copyright © 2016年 LL. All rights reserved.
//

#import "LLSportMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "LLSportTracking.h"
#import "LLSportPolyLine.h"
#import "LLCircleAnimator.h"
#import "LLSportMapModeViewController.h"

@interface LLSportMapViewController () <MAMapViewDelegate, UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation LLSportMapViewController{
    /// 是否设置了起始大头针
    BOOL _hasSetStartLocation;
    /// 同心圆转场动画器
    LLCircleAnimator *_circleAnimator;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        _circleAnimator = [LLCircleAnimator new];
        self.transitioningDelegate = _circleAnimator;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupMapView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)closeMapView {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - popover
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender{
    // 1. 判断跳转控制器的类型
    if (![segue.destinationViewController isKindOfClass:[LLSportMapModeViewController class]]) {
        return;
    }
    
    LLSportMapModeViewController *vc = (LLSportMapModeViewController *)segue.destinationViewController;
    
    // 2. 验证 popover 和传统模态之间的区别，如果要自定义 popover 的样式，就可以通过 popoverPresentationController
//    NSLog(@"%@", vc.popoverPresentationController);
    
    // 3. 设置代理
    vc.popoverPresentationController.delegate = self;
    
    // 4. 设置喜欢的大小，如果 width 设置为 0，宽度交给系统设置！
    vc.preferredContentSize = CGSizeMake(0, 120);
    
    // 5. 设置地图视图的显示模式
    [vc setDidSelectedMapMode:^(MAMapType type) {
        self.mapView.mapType = type;
    }];
    
    // 6. 设置 vc 的当前显示模式
    vc.currentType = _mapView.mapType;
}

#pragma mark - UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    // 不让系统自适应
    return UIModalPresentationNone;
}
#pragma mark - MAMapViewDelegate

// 位置或者设备位置更新后 调用此方法

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    // updatingLocation 表示是否是数据更新 YES :location 数据更新 NO:heading数据更新
    if (!updatingLocation) {
        return;
    }
    // 判断运动状态 , 只有 '继续' 才继续绘制
    if (_sportTracking.sportState != LLSportStateContinue) {
        return;
    }
    // 将用户位置设置在地图视图的中心点
    [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
//    NSLog(@"%@ ", userLocation.location);
    // 判断起始位置是否存在
    if (!_hasSetStartLocation && _sportTracking.sportStartLocation != nil) {
        _hasSetStartLocation = YES;
        // 实例化大头针
        MAPointAnnotation *annotation = [MAPointAnnotation new];
        
        annotation.coordinate = _sportTracking.sportStartLocation.coordinate;
        
        [mapView addAnnotation:annotation];
        
    }
    // 开始画线
    // 建立结构体数组
    [mapView addOverlay:[_sportTracking appendLocation:userLocation.location]];

    [self updateUIDisplay];
    
    [_delegate sportMapViewControllerDidChangedData:self];
}

/**
 数据改变更新 UI
 */
- (void)updateUIDisplay{
    
    // 距离
    _distanceLabel.text = [NSString stringWithFormat:@"%.02f",_sportTracking.totalDistance];
    
    // 时间
    _timeLabel.text = _sportTracking.totalTimeStr;
}


//
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    
    // 判断overlay 的类型
    if (![overlay isKindOfClass:[MAPolyline class]]) {
        return nil;
    }
    // 实例化折线渲染器
    LLSportPolyLine *polyLine = (LLSportPolyLine *)overlay;
    MAPolylineRenderer *renderer = [[MAPolylineRenderer alloc]initWithPolyline:polyLine];
    
    // 设置显示属性
    renderer.lineWidth = 5;
    renderer.strokeColor = polyLine.color;
//    renderer.fillColor = [UIColor greenColor];
    
    return renderer;
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
    
    UIImage *image = _sportTracking.sportImage;
    annotationView.image = image;
    annotationView.centerOffset = CGPointMake(0, -image.size.height * 0.5);
    
    return annotationView;
}

#pragma mark - 设置界面
- (void)setupMapView{
    
    // 创建地图视图
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:mapView atIndex:0];
    
    // 设置属性
    mapView.showsScale = NO; // 隐藏比例尺
    mapView.showsUserLocation = YES; // 显示用户的位置
    mapView.rotateCameraEnabled = NO; // 关闭相机旋转 能耗低
    mapView.userTrackingMode = MAUserTrackingModeFollow; // 跟踪用户
    mapView.allowsBackgroundLocationUpdates = YES; //允许后台定位 - 保证 Background Modes 中的 Location updates 处于选中状态
    mapView.pausesLocationUpdatesAutomatically = NO; // 不允许系统暂停位置更新
    mapView.delegate = self;
    
    _mapView = mapView;
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
