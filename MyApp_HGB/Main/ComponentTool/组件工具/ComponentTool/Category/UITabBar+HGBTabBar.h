//
//  UITabBar+HGBTabBar.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/16.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (HGBTabBar)
/**
 显示提示

 @param index 位置
 @param text 显示内容
 @param textColor 内容颜色
 @param backColor 背景颜色
 @param itemsCount 项数
 */
-(void)showBadgeOnItemIndex:(NSInteger)index andWithText:(NSString *)text andWithTextColor:(UIColor *)textColor andWithBackColor:(UIColor *)backColor andWithTabItemsCount:(NSInteger)itemsCount;



/**
 显示小红点

 @param index 位置
 @param color 颜色
 @param itemsCount 项数
 */
-(void)showBadgeOnItemIndex:(NSInteger)index  andWithColor:(UIColor *)color andWithTabItemsCount:(NSInteger)itemsCount;

/**
 隐藏标记

 @param index index
 */
- (void)hideBadgeOnItemIndex:(NSInteger)index;
@end
