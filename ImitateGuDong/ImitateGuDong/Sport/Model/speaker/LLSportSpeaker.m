//
//  LLSportSpeaker.m
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/27.
//  Copyright © 2016年 LL. All rights reserved.
//

#import "LLSportSpeaker.h"

@implementation LLSportSpeaker{
    /// 运动类型字符串
    NSString *_typeString;
    /// 上次播报距离
    double _lastReportDistance;
    /// 声音字典
    NSDictionary *_voiceDictionary;

}

- (instancetype)init{
    self = [super init];
    if (self) {
        _unitDistance = 0.2;
        
        _lastReportDistance = 0;
        
        // 加载josn生成字典
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"voice.json" withExtension:nil subdirectory:@"voice.bundle"];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        _voiceDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    return self;
}

- (void)startSportWithType:(LLSportType)type{
    switch (type) {
        case LLSportTypeBike:
            _typeString = @"骑行";
            break;
        case LLSportTypeRun:
            _typeString = @"跑步";
            break;
        case LLSportTypeWalk:
            _typeString = @"走路";
            break;
    }
    
    NSString *text = [@"开始" stringByAppendingString:_typeString];
    
    [self playVoiceWithText:text];

}

- (void)sportStateChanged:(LLSportState)state{
    NSString *text;
    
    switch (state) {
        case LLSportStatePause:
            text = @"运动已暂停";
            break;
        case LLSportStateContinue:
            text = @"运动已恢复";
            break;
        case LLSportStateFinish:
            text = @"放松一下吧";
            break;
    }
    
    [self playVoiceWithText:text];
    
}

- (void)reportWithDistance:(double)distance time:(NSTimeInterval)time spped:(double)speed{
    
    // 判断总距离和单位距离+末次报告距离之间的关系
    if (distance < _unitDistance + _lastReportDistance) {
        return;
    }
    
    // 记录上次播报的距离
    _lastReportDistance = (NSInteger)(distance / _unitDistance) * _unitDistance;
    
//    NSString *fmt = @"你已经 %@ %@ 公里 用时 %@ 平均速度 %@ 公里每小时 太棒了";
    NSString *text = [NSString stringWithFormat:@"你已经 %@ %f 公里 用时 %f 平均速度 %f 公里每小时 太棒了",_typeString,distance,time,speed];
    
    [self playVoiceWithText:text];
}

#pragma mark - 语音播报方法
- (void)playVoiceWithText:(NSString *)text{
    NSLog(@"%@",text);
}
@end
