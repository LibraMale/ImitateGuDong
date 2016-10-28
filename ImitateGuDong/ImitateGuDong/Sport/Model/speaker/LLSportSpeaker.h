//
//  LLSportSpeaker.h
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/27.
//  Copyright © 2016年 LL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLSportTracking.h"

/**
 运动语音播报
 */
@interface LLSportSpeaker : NSObject

/**
 指定运动类型

 @param type 运动类型
 */
- (void)startSportWithType:(LLSportType)type;
/**
 指定运动状态

 @param state 运动状态
 */
- (void)sportStateChanged:(LLSportState)state;
/**
 单位距离
 */
@property (nonatomic, assign) double unitDistance;

/**
 整单位距离播报

 @param distance 距离
 @param time     时间
 @param speed    速度
 */
- (void)reportWithDistance:(double)distance time:(NSTimeInterval)time spped:(double)speed;
@end
