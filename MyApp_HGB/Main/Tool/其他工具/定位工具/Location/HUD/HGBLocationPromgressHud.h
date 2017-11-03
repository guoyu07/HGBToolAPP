//
//  HGBLocationPromgressHud.h
//  测试
//
//  Created by huangguangbao on 2017/8/10.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 吐司提示
 */
@interface HGBLocationPromgressHud : NSObject


/**
 单例

 @return 实体
 */
+(instancetype)shareInstance;
#pragma mark 设置
/**
 设置显示时间

 @param dureation 时间
 */
+(void)setShowDuration:(NSInteger )dureation;

/**
 设置显示标题

 @param title 标题
 */
+(void)setShowTitle:(NSString *)title;
#pragma mark 保存

/**
 *  保存
 *
 *  @param view 显示界面
 */
+(void)showHUDSaveToView:(UIView *)view;
/**
 *  隐藏保存
 */
+(void)hideSave;//隐藏保存

#pragma mark 结果
/**
 * //显示结果
 *
 *  @param view 显示界面
 */
+(void)showHUDResult:(NSString *)result ToView:(UIView *)view;

/**
 * 显示结果-无遮挡
 *
 *  @param view 显示界面
 */
+(void)showHUDResult:(NSString *)result WithoutBackToView:(UIView *)view;
@end
