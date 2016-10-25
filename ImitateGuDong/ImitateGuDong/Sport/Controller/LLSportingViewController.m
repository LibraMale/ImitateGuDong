//
//  LLSportingViewController.m
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/21.
//  Copyright © 2016年 LL. All rights reserved.
//

#import "LLSportingViewController.h"
#import "LLSportMapViewController.h"

@interface LLSportingViewController ()

@property (nonatomic, strong) LLSportMapViewController *mapVc;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;

@end

@implementation LLSportingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupMapViewController];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    // 设置罗盘位置
    CGFloat x = _mapButton.center.x - _mapVc.mapView.compassSize.width * 0.5;
    CGFloat y = _mapButton.center.y - _mapVc.mapView.compassSize.height * 0.5;
    
    _mapVc.mapView.compassOrigin = CGPointMake(x, y);

}

- (IBAction)showMapViewController:(id)sender {
    
    [self presentViewController:_mapVc animated:YES completion:nil];
}

- (IBAction)changeSportState:(UIButton *)sender {
    // 修改地图控制器的 运动装填
    _mapVc.sportTracking.sportState = sender.tag;
}

/**
 设置地图视图控制器
 */
- (void)setupMapViewController{
    
    // 获取地图控制器
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LLSportSporting" bundle:nil];
    _mapVc = [sb instantiateViewControllerWithIdentifier:@"sportMapViewController"];
    
    _mapVc.sportTracking = [[LLSportTracking alloc]initWithType:_type state:LLSportStateContinue];
//    LLSportMapViewController *mapVc = [[LLSportMapViewController alloc]init];
//    
//    [self addChildViewController:mapVc];
//    
//    [self.view addSubview:mapVc.view];
//    mapVc.view.frame = self.view.bounds;
//    
//    // 设置运动轨迹模型
//    mapVc.SportTracking = [[LLSportTracking alloc] initWithType:_type];
//    
//    // -------(APPLE推荐写法)--------
//    // 完成控制器的添加
//    [mapVc didMoveToParentViewController:self];
}

@end
