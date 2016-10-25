//
//  LLSportTrackingLine.h
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/22.
//  Copyright © 2016年 LL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "LLSportPolyLine.h"

/**
 轨迹追踪线条模型 记录起始点和结束点
 */
@interface LLSportTrackingLine : NSObject

/**
 使用起始点和结束点,实例化线条模型

 @param startLocation 起始点
 @param endLocation   结束点

 @return 轨迹追踪线条模型
 */
- (instancetype)initWithStartLocation:(CLLocation *)startLocation endLocation:(CLLocation *)endLocation;

/**
 起始点
 */
@property (nonatomic, strong, readonly) CLLocation *startLocation;
/**
 结束点
 */
@property (nonatomic, strong, readonly) CLLocation *endLocation;
/**
 折现模型
 */
@property (nonatomic, readonly) LLSportPolyLine *polyline;
/**
 起始点到结束点的速度
 */
@property (nonatomic, readonly) double speed;
/**
 起始点和结束点之间的时间差值，单位：秒
 */
@property (nonatomic, readonly) NSTimeInterval time;

/**
 起始点和结束点之间的距离，单位：公里
 */
@property (nonatomic, readonly) double distance;

@end
