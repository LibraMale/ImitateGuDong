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

@end

@implementation LLSportingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setupMapViewController];
}

/**
 设置地图视图控制器
 */
- (void)setupMapViewController{
    
    LLSportMapViewController *mapVc = [[LLSportMapViewController alloc]init];
    
    [self addChildViewController:mapVc];
    
    [self.view addSubview:mapVc.view];
    mapVc.view.frame = self.view.bounds;
    
    // 设置运动轨迹模型
    mapVc.SportTracking = [[LLSportTracking alloc] initWithType:_type];
    
    // -------(APPLE推荐写法)--------
    // 完成控制器的添加
    [mapVc didMoveToParentViewController:self];
}

@end
