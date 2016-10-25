//
//  LLSportPolyLine.h
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/22.
//  Copyright © 2016年 LL. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface LLSportPolyLine : MAPolyline

+ (instancetype) polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count color:(UIColor *)color;

@property (nonatomic, strong) UIColor *color;
@end
