//
//  LLSportCameraMaskView.m
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/30.
//  Copyright © 2016年 LL. All rights reserved.
//

#import "LLSportCameraMaskView.h"
#import "UIColor+LLAddition.h"

@interface LLSportCameraMaskView()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation LLSportCameraMaskView

- (void)drawRect:(CGRect)rect {
    
    // 1. 绘制一个矩形，填充指定的颜色
    {
        [[UIColor LL_colorWithHex:0x24282e] setFill];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        
        [path fill];
    }
    
    // 2. 绘制中间的直线
    {
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        // 区分左右
        if (_imageView.frame.origin.x > 0) {
            // 左侧画线
            [path moveToPoint:CGPointMake(rect.size.width, 0)];
            [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
        } else {
            // 右侧画线
            [path moveToPoint:CGPointMake(0, 0)];
            [path addLineToPoint:CGPointMake(0, rect.size.height)];
        }
        
        [[UIColor LL_colorWithHex:0x1a1a1a] setStroke];
        
        [path stroke];
    }
    
    // 3. 核心绘图的清除区域的函数 - 注意：视图背景颜色需要是 clearColor
    CGContextClearRect(UIGraphicsGetCurrentContext(), CGRectInset(_imageView.frame, 1, 1));
}
@end
