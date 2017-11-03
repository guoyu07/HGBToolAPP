//
//  HGBBrokenLineLayer.m
//  测试
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBrokenLineLayer.h"

@implementation HGBBrokenLineLayer
// 添加动画方法
- (void)addAnimationForKeypath:(NSString *)keyPath fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration delegate:(id)delegate {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = @(fromValue);
    animation.toValue = @(toValue);
    animation.duration = duration;
    animation.delegate = delegate;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    [self addAnimation:animation forKey:keyPath];
}
- (NSString *)text {
    if (_text) { return _text; } else { return @""; }
}
@end
