 //
//  LLSportTracking.m
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/21.
//  Copyright © 2016年 LL. All rights reserved.
//

#import "LLSportTracking.h"

@implementation LLSportTracking{
    /// 起始点位置
    CLLocation *_startLocation;
    /// 所有运动模型数组
    NSMutableArray <LLSportTrackingLine *> *_trackingLines;
}

- (instancetype)initWithType:(LLSportType)type state:(LLSportState)state{
    self = [super init];
    if (self) {
        _sportState = state;
        _sportType = type;
        _trackingLines = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 设置数据
- (void)setSportState:(LLSportState)sportState{
    _sportState = sportState;
    // 如果不是继续状态 清空起始点
    if (_sportState != LLSportStateContinue) {
        _startLocation = nil;
    }
}
- (CLLocation *)sportStartLocation {
    // 返回运动轨迹线条数组中，第一个线条的起点
    return _trackingLines.firstObject.startLocation;
}

- (UIImage *)sportImage{
    UIImage *image;
    switch (_sportType) {
        case LLSportTypeRun:
            image = [UIImage imageNamed:@"map_annotation_run"];
            break;
        case LLSportTypeWalk:
            image = [UIImage imageNamed:@"map_annotation_walk"];
            break;
        case LLSportTypeBike:
            image = [UIImage imageNamed:@"map_annotation_bike"];
        default:
            break;
    }
    return image;
}

- (LLSportPolyLine *)appendLocation:(CLLocation *)location{
    NSLog(@"speed = %f,",location.speed);
    // 判断速度是否发生变化
    if (location.speed <= 0) {

        return nil;
    }
    // 判断定位的时间差值，暂时定义一个时间差值因子 - 性能优化（避免室内出现杂线）
    CGFloat factor = 2;
    if ([[NSDate date] timeIntervalSinceDate:location.timestamp] > factor) {
        // 如果超过时间差值，就认为定位的精度不够
        return nil;
    }

    // 判断是否存在起点 暂停时避免出现直线
    if (_startLocation == nil) {
        
        _startLocation = location;
        
        return nil;
    }
    
    // 创建追踪线条模型
    LLSportTrackingLine *trackingLine = [[LLSportTrackingLine alloc] initWithStartLocation:_startLocation endLocation:location];
    
    [_trackingLines addObject:trackingLine];
    
    // 将当前位置设置为下一次的起始点
    _startLocation = location;
    NSLog(@"%@",_startLocation);
    return trackingLine.polyline;
}
- (double)avgSpeed {
    return [[_trackingLines valueForKeyPath:@"@avg.speed"] doubleValue];
}

- (double)maxSpeed {
    return [[_trackingLines valueForKeyPath:@"@max.speed"] doubleValue];
}

- (double)totalTime {
    return [[_trackingLines valueForKeyPath:@"@sum.time"] doubleValue];
}

- (double)totalDistance {
    return [[_trackingLines valueForKeyPath:@"@sum.distance"] doubleValue];
}

@end
