//
//  HGBPieValue.h
//  测试
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface HGBPieValue : NSObject
/**
 index
 */
@property (nonatomic, assign) NSInteger index;
/**
 每个section的值
 */
@property (nonatomic, assign) CGFloat number;

/**
 相应section的颜色
 */
@property (nonatomic, strong) UIColor *color;
/**
 显示text
 */
@property (nonatomic, strong) NSString *text;
/**
 百分比
 */
@property (nonatomic, assign) CGFloat percent;

/**
 赋值

 @param number 数据
 @param color 颜色
 @param text 文字
 @return 模型
 */
+ (HGBPieValue *)getPieValueWithNumber:(CGFloat)number andWithColor:(UIColor *)color andWithText:(NSString *)text;
/**
 赋值

 @param number 数据
 @param color 颜色
 @param text 文字
 @param index 标记
 @return 模型
 */
+ (HGBPieValue *)getPieValueWithNumber:(CGFloat)number andWithColor:(UIColor *)color andWithText:(NSString *)text andWithIndex:(NSInteger)index;
@end
