//
//  HGBControllerTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/16.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIViewController+HGBUntil.h"


/**
 导航栏元素位置
 */
typedef enum HGBNavigationItem
{
    HGBNavigationItemTitle,//标题
    HGBNavigationItemLeft,//左按钮
    HGBNavigationItemRight//右侧按钮
}HGBNavigationItem;

@interface HGBControllerTool : NSObject
#pragma mark 导航栏整体
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
#pragma mark 导航栏创建
/**
 快捷创建导航栏-仅有标题和左按钮

 @param title 标题
 @param target 目标
 @param action 左按钮事件
 @param controller 控制器
 */
+(void)createNavigationItemWithTitle:(NSString *)title andWithTarget:(id)target andWithLeftAction:(SEL)action inController:(UIViewController *)controller;

/**
 创建导航栏-标题按钮多个采用segment

 @param type  导航栏类型
 @param titles 标题集合
 @param target 目标
 @param action 事件
 @param controller 控制器
 */
+(void)createNavigationItem:(HGBNavigationItem )type andWithTitles:(NSArray <NSString *>*)titles andWithTarget:(id)target andWithAction:(SEL)action inController:(UIViewController *)controller;
/**
 创建导航栏-标题按钮多个采用segment

 @param titles 标题集合 R L T
 @param target 目标
 @param action 事件
 @param controller 控制器
 */
+(void)createNavigationItemWithTitles:(NSDictionary *)titles andWithTarget:(id)target andWithAction:(SEL )action inController:(UIViewController *)controller;

#pragma mark 获取当前控制器
/**
 获取当前控制器

 @return 当前控制器
 */
+ (UIViewController *)currentViewController;
#pragma mark Present-Dismiss 模态
/**
 模态视图推出-有导航栏

 @param controller 控制器
 */
+(void)presentControllerWithNavgation:(UIViewController *)controller;


/**
 模态视图推出-无导航栏

 @param controller 控制器
 */
+(void)presentController:(UIViewController *)controller;



/**
 返回到上一级控制器
 */
+(void)dismissToParentViewController;
/**
 返回到根视图控制器
 */
+(void)dismissToRootViewController;

/**
 返回到指定控制器

 @param controllerName 控制器名称
 */
+(void)dismissToControllerWithControllerName:(NSString *)controllerName;

/**
 返回指定次数

 @param count 返回层数
 */
+(void)dismissToControllerWithDismissCount:(NSInteger)count;

#pragma mark Push-Pop
/**
 视图推出

 @param controller 控制器
 */
+(void)pushController:(UIViewController *)controller;
/**
 返回到上一层控制器
 */
+(void)popToParentViewController;
/**
 返回到根层视图控制器
 */
+(void)popToRootViewController;

/**
 返回到指定层控制器

 @param controllerName 控制器名称
 */
+(void)popToControllerWithControllerName:(NSString *)controllerName;

/**
 返回指定次数

 @param count 返回层数
 */
+(void)popToControllerWithPopCount:(NSInteger)count;
@end
