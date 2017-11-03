//
//  HGBBarValue.h
//  测试
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HGBBarValue : NSObject
/**
 标记
 */
@property(nonatomic,assign)NSInteger index;
/**
 横坐标
 */
@property (nonatomic, assign) CGFloat x;

/**
 纵坐标
 */
@property (nonatomic, assign) CGFloat y;

/**
 颜色
 */
@property (nonatomic, strong) UIColor *color;

/**
 赋值

 @param x 横坐标
 @param y 纵坐标
 @return 模型
 */
+ (HGBBarValue *)getBarValueWithX:(CGFloat)x andWithY:(CGFloat)y;
/**
 赋值

 @param x 横坐标
 @param y 纵坐标
 @param color 颜色
 @return 模型
 */
+ (HGBBarValue *)getBarValueWithX:(CGFloat)x andWithY:(CGFloat)y andWithColor:(UIColor *)color;
/**
 赋值

 @param x 横坐标
 @param y 纵坐标
 @param index 标记
 @return 模型
 */
+ (HGBBarValue *)getBarValueWithX:(CGFloat)x andWithY:(CGFloat)y andWithIndex:(NSInteger)index;
/**
 赋值

 @param x 横坐标
 @param y 纵坐标
 @param color 颜色
 @param index 标记
 @return 模型
 */
+ (HGBBarValue *)getBarValueWithX:(CGFloat)x andWithY:(CGFloat)y andWithColor:(UIColor *)color andWithIndex:(NSInteger)index;
@end
