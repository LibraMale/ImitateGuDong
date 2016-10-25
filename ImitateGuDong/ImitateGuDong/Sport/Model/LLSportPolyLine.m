//
//  LLSportPolyLine.m
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/22.
//  Copyright © 2016年 LL. All rights reserved.
//

#import "LLSportPolyLine.h"

@implementation LLSportPolyLine

+ (instancetype)polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count color:(UIColor *)color{
    
    LLSportPolyLine *polyline = [self polylineWithCoordinates:coords count:count];
    
    polyline.color = color;
    
    return polyline;
}


@end
