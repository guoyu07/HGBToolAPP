//
//  HGBComponentTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HGBComponentTool : NSObject

#pragma mark 组件复制
/**
 复制view
 */
+ (UIView *)duplicateComponent:(UIView *)view;
#pragma mark 导航栏
/**
 设置当前导航栏显示隐藏

 @param isHidden 是否隐藏
 */
+(void)setNavgationBarIsHidden:(BOOL)isHidden;


/**
 修改当前导航栏的颜色

 @param color 颜色
 */
+(void)changeNavgationBarColor:(UIColor *)color;
/**
 修改所有导航栏的颜色

 @param color 颜色
 */
+(void)changeAllNavgationBarColor:(UIColor *)color;
#pragma mark 状态栏
/**
 设置状态栏是否隐藏-info.plist UIViewControllerBasedStatusBarAppearance NO

 @param isHidden 是否隐藏
 */
+(void)setStatusBarIsHidden:(BOOL)isHidden;

/**
 设置状态栏样式-info.plist UIViewControllerBasedStatusBarAppearance NO

 @param statusBarStyle 状态栏样式
 */
+(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle;
#pragma mark tableBar标记点
/**
 tabBar添加标记点

 @param controller controller
 */
+(void)addPointInController:(UIViewController *)controller;
/**
 设置tabBar提示点颜色

 @param pointColor 角标颜色
 @param controller controller
 */
+(void)setTabBarPointColor:(UIColor *)pointColor inController:(UIViewController *)controller;
/**
 tabBar标记点隐藏

 @param controller controller
 */
+(void)hideTabBarPointInController:(UIViewController *)controller;
#pragma mark 应用角标
/**
 设置应用角标

 @param badge 角标
 */
+(void)setApplicationBadge:(NSInteger)badge;
/**
 应用角标+1
 */
+(void)addApplicationBadge;
/**
 应用角标-1
 */
+(void)reduceApplicationBadge;
/**
 应用角标隐藏

 */
+(void)hideApplicationBadge;
#pragma mark tableBar角标
/**
 设置tabBar角标

 @param badge 角标
 @param controller controller
 */
+(void)setTabBarBadge:(NSString *)badge inController:(UIViewController *)controller;
/**
 tabBar角标+1

 @param controller controller
 */
+(void)addTabBarBadgeInController:(UIViewController *)controller;
/**
 tabBar角标-1

 @param controller controller
 */
+(void)reduceTabBarBadgeInController:(UIViewController *)controller;
/**
 tabBar角标隐藏

 @param controller controller
 */
+(void)hideTabBarBadgeInController:(UIViewController *)controller;
/**
 设置tabBar角标颜色

 @param badgeColor 角标颜色
 @param controller controller
 */
+(void)setTabBarBadgeColor:(UIColor *)badgeColor inController:(UIViewController *)controller;
/**
 设置tabBar角标文字颜色

 @param badgeTextColor 角标文字颜色
 @param controller controller
 */
+(void)setTabBarBadgeTextColor:(UIColor *)badgeTextColor inController:(UIViewController *)controller;
@end
