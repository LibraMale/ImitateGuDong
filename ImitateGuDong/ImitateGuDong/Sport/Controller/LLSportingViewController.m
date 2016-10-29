//
//  LLSportingViewController.m
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/21.
//  Copyright © 2016年 LL. All rights reserved.
//

#import "LLSportingViewController.h"
#import "LLSportMapViewController.h"
#import "LLSportCameraViewController.h"
#import "UIColor+LLAddition.h"
#import "LLSportSpeaker.h"

@interface LLSportingViewController () <LLSportMapViewControllerDelegate>

@property (nonatomic, strong) LLSportMapViewController *mapVc;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
/**
 距离标签
 */
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
/**
 时间标签
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 速度标签
 */
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

/**
 暂停按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

/**
 继续按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

/**
 暂停按钮的中心的X约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pauseButtonCenterXCons;
/**
 继续按钮的中心的X约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *continueButtonCenterXCons;
/**
 结束按钮的中心的X约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishButtonCenterXCons;


@end

@implementation LLSportingViewController{
    /// 语音播报器
    LLSportSpeaker *_sportSpeaker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sportSpeaker = [[LLSportSpeaker alloc] init];
    
    [self setupMapViewController];
    [self setupBackgroundLayer];

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
- (IBAction)showCameraController:(id)sender {
    
    LLSportCameraViewController *vc = [[LLSportCameraViewController alloc] init];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)changeSportState:(UIButton *)sender {
    // 修改地图控制器的 运动装填
    LLSportState state = sender.tag;
    
    // 修改地图控制器的运动状态
    _mapVc.sportTracking.sportState = state;
    
    // 根据tag值 决定按钮的偏移量
    CGFloat offset = (state == LLSportStatePause) ? -80 : 80;
    
    // 设置按钮的 约束
    _pauseButtonCenterXCons.constant += offset;
    _continueButtonCenterXCons.constant += offset;
    _finishButtonCenterXCons.constant -= offset;
    
    [UIView animateWithDuration:0.15 animations:^{
        // 隐藏暂停按钮
        _pauseButton.alpha = (sender != _pauseButton);
        
        [self.view layoutIfNeeded];
    }];
    // 播放语音
    [_sportSpeaker sportStateChanged:state];

}

- (void)sportMapViewControllerDidChangedData:(LLSportMapViewController *)vc{
    
    // 获取地图控制器中的轨迹追踪模型
    LLSportTracking *model = vc.sportTracking;
    
    // 更新UI
    _distanceLabel.text = [NSString stringWithFormat:@"%0.2f", model.totalDistance];
    _timeLabel.text = model.totalTimeStr;
    _speedLabel.text = [NSString stringWithFormat:@"%0.2f", model.avgSpeed];
    
    // 根据用户状态 模拟按钮点击
    // 当用户暂停运动，同时暂停按钮可见，模拟点击暂停按钮，隐藏暂停按钮
    if (model.sportState == LLSportStatePause && _pauseButton.alpha == 1) {
        // 点击暂停按钮
        [self changeSportState:_pauseButton];
    }
    // 当用户继续运行，同时暂停按钮不可见，模拟点击继续按钮，显示暂停按钮
    if (model.sportState == LLSportStateContinue && _pauseButton.alpha == 0) {
        [self changeSportState:_continueButton];
    }
    
    // 3. 播放距离提示语音
    [_sportSpeaker reportWithDistance:model.totalDistance time:model.totalTime spped:model.avgSpeed];
    
}

#pragma mark - 设置界面

/**
 设置背景图层
 */
- (void)setupBackgroundLayer{
    
    // 渐变图层
    CAGradientLayer *layer = [CAGradientLayer layer];
    
    layer.bounds = self.view.bounds;
    layer.position = self.view.center;
    
    // 设置渐变颜色数组
    CGColorRef color1 = [UIColor LL_colorWithHex:0x0e1428].CGColor;
    CGColorRef color2 = [UIColor LL_colorWithHex:0x406479].CGColor;
    CGColorRef color3 = [UIColor LL_colorWithHex:0x406578].CGColor;
    
    layer.colors = @[(__bridge UIColor *)color1,(__bridge UIColor *)color2,(__bridge UIColor *)color3];
    
    // 设置颜色的位置数组
    layer.locations = @[@0,@0.6,@1];
    
    [self.view.layer insertSublayer:layer atIndex:0];

}
/**
 设置地图视图控制器
 */
- (void)setupMapViewController{
    
    // 获取地图控制器
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LLSportSporting" bundle:nil];
    _mapVc = [sb instantiateViewControllerWithIdentifier:@"sportMapViewController"];
    
    _mapVc.sportTracking = [[LLSportTracking alloc]initWithType:_type state:LLSportStateContinue];
    
    _mapVc.delegate = self;
    
    // 语音播报
    [_sportSpeaker startSportWithType:_type];
}

@end
