//
//  LLSportTracking.h
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/21.
//  Copyright © 2016年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LLSportType) {
    LLSportTypeRun,
    LLSportTypeWalk,
    LLSportTypeBike,
};

/**
 单次运动轨迹追踪模型
 */
@interface LLSportTracking : NSObject

- (instancetype)initWithType:(LLSportType)type;

/**
 运动类型
 */
@property (nonatomic, assign, readonly) LLSportType sportType;

/**
 运动图像 定位大头针
 */
@property (nonatomic, strong, readonly) UIImage *sportImage;

@end
