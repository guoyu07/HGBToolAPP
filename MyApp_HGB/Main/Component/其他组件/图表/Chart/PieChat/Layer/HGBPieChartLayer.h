//
//  HGBPieChartLayer.h
//  测试
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface HGBPieChartLayer : CAShapeLayer
/**
 layer标记
 */
@property (nonatomic, assign) NSInteger index;
/**
 所占百分比
 */
@property (nonatomic, assign) CGFloat percent;
/**
 显示text
 */
@property (nonatomic, strong) NSString *text;

/**
 info
 */
@property (nonatomic, strong) id userInfo;

// 添加动画方法
- (void)addArcAnimationForKeypath:(NSString *)keyPath fromValue:(CGFloat)fromValue  toValue:(CGFloat)toValue duration:(CGFloat)duration delegate:(id)delegate;
@end
