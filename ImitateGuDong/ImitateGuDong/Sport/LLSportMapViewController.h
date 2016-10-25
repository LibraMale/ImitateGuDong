//
//  LLSportMapViewController.h
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/21.
//  Copyright © 2016年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSportTracking.h"

/**
 运动模块的主界面
 */
@interface LLSportMapViewController : UIViewController

@property (nonatomic, strong) LLSportTracking *sportTracking;
/**
 地图视图
 */
@property (nonatomic, weak, readonly) MAMapView *mapView;

@end
