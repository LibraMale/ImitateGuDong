//
//  LLSportMapModeViewController.h
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/25.
//  Copyright © 2016年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface LLSportMapModeViewController : UIViewController

/**
 选中地图类型
 */
@property (nonatomic, copy) void (^didSelectedMapMode)(MAMapType mapType);
/**
 当前显示地图类型
 */
@property (nonatomic, assign) MAMapType currentType;

@end
