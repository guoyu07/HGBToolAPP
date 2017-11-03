//
//  UIViewController+HGBPushAndPop.h
//  测试
//
//  Created by huangguangbao on 2017/6/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HGBPushAndPop)
#pragma mark Push
/**
 视图推出
 
 @param controller 控制器
 */
-(void)pushController:(UIViewController *)controller;
#pragma mark Pop
/**
 返回到上一层控制器
 */
-(void)popToParentViewController;
/**
 返回到根层视图控制器
 */
-(void)popToRootViewController;

/**
 返回到指定层控制器
 
 @param controllerName 控制器名称
 */
-(void)popToControllerWithControllerName:(NSString *)controllerName;

/**
 返回指定次数
 
 @param count 返回层数
 */
-(void)popToControllerWithPopCount:(NSInteger)count;
@end
