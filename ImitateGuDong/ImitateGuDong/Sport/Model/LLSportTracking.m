//
//  LLSportTracking.m
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/21.
//  Copyright © 2016年 LL. All rights reserved.
//

#import "LLSportTracking.h"

@implementation LLSportTracking

- (instancetype)initWithType:(LLSportType)type{
    self = [super init];
    if (self) {
        _sportType = type;
    }
    return self;
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
@end
