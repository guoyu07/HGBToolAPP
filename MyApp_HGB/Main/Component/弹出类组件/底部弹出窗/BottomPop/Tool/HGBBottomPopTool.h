//
//  HGBBottomPopTool.h
//  测试
//
//  Created by huangguangbao on 2017/8/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HGBBottomPopTool : NSObject
#pragma mark 获取字符串宽高
/**
 @method 获取指定宽度情况下，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (CGFloat)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;
/**
 @method 获取指定高度情况下，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param height 限制字符串显示区域的高度
 @result float 返回的宽度
 */
+ (CGFloat)widthForString:(NSString *)value fontSize:(float)fontSize andheight:(float)height;
@end
