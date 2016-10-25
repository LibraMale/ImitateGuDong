//
//  LLSportTracking.h
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/21.
//  Copyright © 2016年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSportTrackingLine.h"
/// GPS 信号变化通知
extern NSString *const LLSportGPSSignalChangedNotification;
/// 运动类型枚举
typedef NS_ENUM(NSUInteger, LLSportType) {
    LLSportTypeRun,
    LLSportTypeWalk,
    LLSportTypeBike,
};
/// 运动状态枚举
typedef NS_ENUM(NSUInteger, LLSportState) {
    LLSportStatePause,
    LLSportStateContinue,
    LLSportStateFinish,
};
/// GPS信号枚举
typedef NS_ENUM(NSUInteger, LLSportGPSSignalState) {
    LLSportGPSSignalStateDisconnect,
    LLSportGPSSignalStateBad,
    LLSportGPSSignalStateNormal,
    LLSportGPSSignalStateGood
};

/**
 单次运动轨迹追踪模型
 */
@interface LLSportTracking : NSObject

- (instancetype)initWithType:(LLSportType)type state:(LLSportState)state;

/**
 运动类型
 */
@property (nonatomic, assign, readonly) LLSportType sportType;

/**
 运动的起点
 */
@property (nonatomic, readonly) CLLocation *sportStartLocation;

/**
 运动图像 定位大头针
 */
@property (nonatomic, strong, readonly) UIImage *sportImage;
/**
 运动状态
 */
@property (nonatomic, assign) LLSportState sportState;
/**
 追加用户模型 返回折线模型

 @param location locatio

 */
- (LLSportPolyLine *)appendLocation:(CLLocation *)location;
/**
 平均速度
 */
@property (nonatomic, readonly) double avgSpeed;
/**
 最大速度
 */
@property (nonatomic, readonly) double maxSpeed;
/**
 总时长
 */
@property (nonatomic, readonly) double totalTime;
/**
 总时长 00:00:00 格式的字符串
 */
@property (nonatomic, copy) NSString *totalTimeStr;
/**
 总距离
 */
@property (nonatomic, readonly) double totalDistance;

@end
