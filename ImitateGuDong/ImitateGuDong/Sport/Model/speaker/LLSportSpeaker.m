//
//  LLSportSpeaker.m
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/27.
//  Copyright © 2016年 LL. All rights reserved.
//

#import "LLSportSpeaker.h"
#import "NSObject+LLNumberConvert.h"
#import <AVFoundation/AVFoundation.h>

@implementation LLSportSpeaker{
    /// 运动类型字符串
    NSString *_typeString;
    /// 上次播报距离
    double _lastReportDistance;
    /// 声音字典
    NSDictionary *_voiceDictionary;
    /// 语音键值数组
    NSMutableArray *_voiceArray;
    /// 语音播放器
    AVPlayer *_voicePlayer;

}

- (instancetype)init{
    self = [super init];
    if (self) {
        _unitDistance = 1;
        
        _lastReportDistance = 0;
        
        // 加载josn生成字典
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"voice.json" withExtension:nil subdirectory:@"voice.bundle"];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        _voiceDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        // 实例化播放器
        _voicePlayer = [AVPlayer new];
        
        // 注册通知 监听语音条目播放完成
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playItemDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        // 允许多个应用程序的音乐同时播放！- 一旦应用程序退出到后台，应该同样能够播放音乐！
        // 音乐会话分类 - 专门解决多个音乐播放设置的，而且代码相对固定！
        // 因为在 iOS 中，默认的音乐播放是`独占`的！
        // AVAudioSessionCategoryOptionMixWithOthers - 允许和其他的音乐一起播放，但是音量相同
        // AVAudioSessionCategoryOptionDuckOthers - 允许和其他音乐一起播放，会降低其他音乐的音量，但是，无法恢复音量
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
        // 激活声音会话
        [[AVAudioSession sharedInstance] setActive:YES error:nil];

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
    // 记录上次播报距离
    _lastReportDistance = (NSInteger)(distance / _unitDistance) * _unitDistance;
    
    NSString *fmt = @"你已经 %@ %@ 公里 用时 %@ 平均速度 %@ 公里每小时 太棒了";
    
    NSString *distanceStr = [NSString ll_numberStringWithNumber:distance hasDotNumber:YES];
    NSString *timeStr = [NSString ll_timeStringWithTimeValue:time];
    NSString *speedStr = [NSString ll_numberStringWithNumber:speed hasDotNumber:YES];
    
   
    NSString *text = [NSString stringWithFormat:fmt, _typeString, distanceStr, timeStr, speedStr];
    
    [self playVoiceWithText:text];
}

#pragma mark - 语音播报方法
- (void)playVoiceWithText:(NSString *)text{

    // 拆分字符串
    NSArray *array = [text componentsSeparatedByString:@" "];
    
    _voiceArray = [NSMutableArray arrayWithArray:array];
    
    // 激活音乐回话
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [self playFirstVoice];
}
- (void)playFirstVoice{
    
    // 判断数组中是否有内容
    if (_voiceArray.count == 0) {
        
        // 禁用音乐会话 恢复其他音乐音量
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
        
        return;
    }
    
    // 获取数组中的第一项
    NSString *key = _voiceArray.firstObject;
    
    // 移除数组中的第一项
    [_voiceArray removeObjectAtIndex:0];
    
    NSString *mp3 = _voiceDictionary[key];
    
    // url
    NSURL *url = [[NSBundle mainBundle] URLForResource:mp3 withExtension:nil subdirectory:@"voice.bundle"];
    
    if (url == nil) {
        [self playFirstVoice];
        
        return;
    }
    
    // 语音播放条目
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    
    [_voicePlayer replaceCurrentItemWithPlayerItem:item];
    
    [_voicePlayer play];
}

/// 播放条目结束的监听方法
- (void)playItemDidEnd:(NSNotification *)noti{
    
    [self playFirstVoice];
}

/// 移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
