//
//  HGBBrokenLineValue.m
//  测试
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBrokenLineValue.h"

@implementation HGBBrokenLineValue
/**
 赋值

 @param x 横坐标
 @param y 纵坐标
 @return 模型
 */
+ (HGBBrokenLineValue *)getBrokenLineValueWithX:(CGFloat)x andWithY:(CGFloat)y{
    HGBBrokenLineValue *value = [[HGBBrokenLineValue alloc] init];
    value.x = x;
    value.y = y;
    return value;
}
/**
 赋值

 @param x 横坐标
 @param y 纵坐标
 @param color 颜色
 @return 模型
 */
+ (HGBBrokenLineValue *)getBrokenLineValueWithX:(CGFloat)x andWithY:(CGFloat)y andWithColor:(UIColor *)color{
    HGBBrokenLineValue *value = [HGBBrokenLineValue getBrokenLineValueWithX:x andWithY:y];
    value.color = color;
    return value;
}
/**
 赋值

 @param x 横坐标
 @param y 纵坐标
 @param index 标记
 @return 模型
 */
+ (HGBBrokenLineValue *)getBrokenLineValueWithX:(CGFloat)x andWithY:(CGFloat)y andWithIndex:(NSInteger)index{
    HGBBrokenLineValue *value = [HGBBrokenLineValue getBrokenLineValueWithX:x andWithY:y];;
    value.index = index;
    return value;
}
/**
 赋值

 @param x 横坐标
 @param y 纵坐标
 @param color 颜色
 @param index 标记
 @return 模型
 */
+ (HGBBrokenLineValue *)getBrokenLineValueWithX:(CGFloat)x andWithY:(CGFloat)y andWithColor:(UIColor *)color andWithIndex:(NSInteger)index{
    HGBBrokenLineValue *value = [HGBBrokenLineValue getBrokenLineValueWithX:x andWithY:y];;
    value.index = index;
    value.color=color;
    return value;
}
- (UIColor *)color {
    return _color ? _color : [UIColor clearColor];
}
@end
