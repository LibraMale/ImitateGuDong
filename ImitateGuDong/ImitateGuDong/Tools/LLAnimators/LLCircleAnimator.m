//
//  LLCircleAnimator.m
//  01-animator
//
//  Created by LibraLiu on 16/10/24.
//  Copyright © 2016年 LL. All rights reserved.
//

#import "LLCircleAnimator.h"

@interface LLCircleAnimator() <UIViewControllerAnimatedTransitioning,CAAnimationDelegate>

@end
@implementation LLCircleAnimator{
    /// 是否展现标记
    BOOL _isPresented;
    /// 转场上下文
    __weak id <UIViewControllerContextTransitioning> _transitionContext;
}

/// 告诉控制器谁来控制展现转场动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    _isPresented = YES;
    
    return self;
}

/// 告诉控制器谁来提供解除专场动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    _isPresented = NO;
    
    return self;
}
#pragma mark - UIViewControllerAnimatedTransitioning
/// 返回动画时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    // 容器视图
    UIView *containerView = [transitionContext containerView];
    
    // 获取目标视图
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *view = _isPresented ? toView : fromView;
    
    if (_isPresented) {
        [containerView addSubview:view];
    }
    // 执行动画
    [self circleAnimatedWithView:view];
    
    _transitionContext = transitionContext;
}

#pragma mark - CAAnimationDelegate
/// 监听动画完成
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [_transitionContext completeTransition:YES];
}
#pragma mark - 动画方法
- (void)circleAnimatedWithView:(UIView *)view{
    // 实例化图层
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    // 路径
    CGFloat radius = 30;
    CGFloat rightMargin = 16;
    CGFloat topMargin = 28;
    CGFloat width = view.bounds.size.width;
    CGFloat height = view.bounds.size.height;
    
    // 初始位置
    CGRect rect = CGRectMake(width - radius - rightMargin, topMargin, radius, radius);
    // 贝塞尔路径
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    layer.path = beginPath.CGPath;
    
    // 计算对角线
    CGFloat maxRadius = sqrt(width * width + height * height);
    
    // 结束位置
    CGRect endRect = CGRectInset(rect, -maxRadius, -maxRadius);
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    // 设置罩层
    view.layer.mask = layer;
    
    // 实例化动画对象
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    
    animation.duration = [self transitionDuration:_transitionContext];
    
    // 判断是否是展现
    if (_isPresented) {
        animation.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
        animation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    }else{
        animation.fromValue = (__bridge id _Nullable)(endPath.CGPath);
        animation.toValue = (__bridge id _Nullable)(beginPath.CGPath);
    }
    // 填充模式
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    animation.delegate = self;
    [layer addAnimation:animation forKey:nil];

}


@end
