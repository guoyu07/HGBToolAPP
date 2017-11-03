//
//  HGBNotification.h
//  测试
//
//  Created by huangguangbao on 2017/6/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGBNotification;
/**
 通知弹窗代理
 */
@protocol HGBNotificationDelegate <NSObject>

/**
 结果
 
 @param msg 结果
 */
- (void)notification:(HGBNotification *)notification didClickWithMsg:(NSString *)msg;

@end

@interface HGBNotification : UIView
/**
 *  通知
 *
 *  @param title    通知的标题
 *  @param msg      通知的内容
 */
+ (void)hgb_notificationWithTitle:(NSString *)title msg:(NSString *)msg;
/**
 *  dismiss 通知
 */
+ (void)dismiss;
/**
 *  设置代理
 *
 *  @param delegate 代理对象
 */
+ (void)setDelegate:(id<HGBNotificationDelegate>)delegate;

/**
 *  设置通知栏是否显示(容易递归,建议使用默认)
 *
 *  @param enable 默认为不显示
 */
+ (void)setBackgroundNotiEnable:(BOOL)enable;

/**
 *  设置是否播放系统声音
 *
 *  @param enable 默认为播放
 */
+ (void)setPlaySystemSound:(BOOL)enable;
/**
 *  设置消息背景颜色
 *
 *  @param msgBackColor 背景颜色
 */
+ (void)setMsgBackGroundColor:(UIColor*) msgBackColor;
/**
 *  设置标题背景颜色
 *
 *  @param titleBackColor 背景颜色
 */
+ (void)setTitleBackGroundColor:(UIColor*) titleBackColor;
/**
 *  设置时间颜色
 *
 *  @param timeColor 时间颜色
 */
+ (void)setTimeColor:(UIColor*) timeColor;
/**
 *  设置消息颜色
 *
 *  @param msgColor 背景颜色
 */
+ (void)setMsgColor:(UIColor*)msgColor;
/**
 *  设置标题颜色
 *
 *  @param titleColor 标题颜色
 */
+ (void)setTitleColor:(UIColor*) titleColor;
@end
