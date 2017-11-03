
//
//  HGBPieValue.m
//  测试
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBPieValue.h"

@implementation HGBPieValue
/**
 赋值

 @param number 数据
 @param color 颜色
 @param text 文字
 @return 模型
 */
+ (HGBPieValue *)getPieValueWithNumber:(CGFloat)number andWithColor:(UIColor *)color andWithText:(NSString *)text{
    HGBPieValue *pie = [[HGBPieValue alloc] init];
    pie.number = number;
    pie.color = color ? color : [UIColor clearColor];
    pie.text = text;
    return pie;
}
/**
 赋值

 @param number 数据
 @param color 颜色
 @param text 文字
 @param index 标记
 @return 模型
 */
+ (HGBPieValue *)getPieValueWithNumber:(CGFloat)number andWithColor:(UIColor *)color andWithText:(NSString *)text andWithIndex:(NSInteger)index{
    HGBPieValue *pie = [[HGBPieValue alloc] init];
    pie.number = number;
    pie.color = color ? color : [UIColor clearColor];
    pie.text = text;
    pie.index=index;
    return pie;
}

- (NSString *)text {
    if (_text) { return _text; } else { return @""; }
}

@end
