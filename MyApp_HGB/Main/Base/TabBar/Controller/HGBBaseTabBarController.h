//
//  HGBBaseTabBarController.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 tablebar 基类
 */
@interface HGBBaseTabBarController : UITabBarController

/**
 导航栏

 @param title 标题
 */
-(void)createNavigationItemWithTitle:(NSString *)title;
/**
 设置tabBar选中项

 @param index 标记
 */
-(void)setTabBarSelectIndex:(NSInteger )index;
/**
 添加子控制器

 @param controller 控制器
 @param title 标题
 @param image 图片
 @param selectImage 已选中图片
 @param navFlag 是否有导航栏
 */
-(void)addSubControler:(UIViewController *)controller withTitle:(NSString *)title andWithImage:(UIImage *)image andWithSelectorImage:(UIImage *)selectImage andWithNavFlag:(BOOL)navFlag;
@end
