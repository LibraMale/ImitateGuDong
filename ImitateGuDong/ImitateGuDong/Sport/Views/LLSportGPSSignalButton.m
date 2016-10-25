//
//  LLSportGPSSignalButton.m
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/26.
//  Copyright © 2016年 LL. All rights reserved.
//

#import "LLSportGPSSignalButton.h"
#import "LLSportTracking.h"

@implementation LLSportGPSSignalButton

- (void)awakeFromNib{
    [super awakeFromNib];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gpsChanged:) name:LLSportGPSSignalChangedNotification object:nil];
}

- (void)gpsChanged:(NSNotification *)notification{
    
    LLSportGPSSignalState state = [notification.object integerValue];
    NSString *imageName = (_isMapButton) ? @"ic_sport_gps_map_" : @"ic_sport_gps_";
    NSString *title;
    
    switch (state) {
        case LLSportGPSSignalStateDisconnect:
            title = @"  GPS已经断开  ";
            imageName = [imageName stringByAppendingString:@"disconnect"];
            break;
        case LLSportGPSSignalStateBad:
            title = @"  请绕开高楼大厦  ";
            imageName = [imageName stringByAppendingString:@"connect_1"];
            break;
        case LLSportGPSSignalStateNormal:
            imageName = [imageName stringByAppendingString:@"connect_2"];
            break;
        case LLSportGPSSignalStateGood:
            imageName = [imageName stringByAppendingString:@"connect_3"];
            break;
    }
    
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];

    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
