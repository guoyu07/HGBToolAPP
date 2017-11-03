//
//  UIViewController+HGBPresentAndDismiss.h
//  测试
//
//  Created by huangguangbao on 2017/6/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HGBPresentAndDismiss)
#pragma mark Present
/**
 模态视图推出-有导航栏
 
 @param controller 控制器
 */
-(void)presentControllerWithNavgation:(UIViewController *)controller;


/**
 模态视图推出-无导航栏
 
 @param controller 控制器
 */
-(void)presentController:(UIViewController *)controller;


#pragma mark Dismiss

/**
 返回到上一级控制器
 */
-(void)dismissToParentViewController;
/**
 返回到根视图控制器
 */
-(void)dismissToRootViewController;

/**
 返回到指定控制器
 
 @param controllerName 控制器名称
 */
-(void)dismissToControllerWithControllerName:(NSString *)controllerName;

/**
 返回指定次数
 
 @param count 返回层数
 */
-(void)dismissToControllerWithDismissCount:(NSInteger)count;

@end
