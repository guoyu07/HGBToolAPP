//
//  HGBAlertTool.h
//  测试
//
//  Created by huangguangbao on 2017/8/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ HGBAlertClickBlock)(NSInteger index);

/**
 alert弹窗封装
 */
@interface HGBAlertTool : NSObject
#pragma mark alert单键
/**
 *  单键-提示
 *
 *  @param prompt     提示详情
 *
 *  @param parent 父控件
 */

+(void)alertWithPrompt:(NSString *)prompt InParent:(UIViewController *)parent;

/**
 *  单键－带标题提示
 *
 *  @param title    提示标题
 *  @param prompt     提示详情
 *
 *  @param parent 父控件
 */
+(void)alertPromptWithTitle:(NSString *)title andWithPrompt:(NSString *)prompt  InParent:(UIViewController *)parent;

/**
 *  单键－带标题提示-点击事件
 *
 *  @param title    提示标题
 *  @param prompt     提示详情
 *
 *  @param clickBlock 点击事件
 *  @param parent 父控件
 */
+(void)alertWithTitle:(NSString *)title andWithPrompt:(NSString *)prompt andWithClickBlock:(HGBAlertClickBlock)clickBlock InParent:(UIViewController *)parent;

/**
 *  单键-带标题提示-点击按钮功能及标题
 *
 *  @param title    提示标题
 *  @param prompt     提示详情
 *  @param confirmButtonTitle  按钮标题
 *  @param clickBlock 点击事件
 *  @param parent 父控件
 */
+(void)alertWithTitle:(NSString *)title andWithPrompt:(NSString *)prompt  andWithConfirmButtonTitle:(NSString *)confirmButtonTitle andWithClickBlock:(HGBAlertClickBlock)clickBlock InParent:(UIViewController *)parent;
#pragma mark alert双键
/**
 *  双键-功能－标题提示
 *
 *  @param title    提示标题
 *  @param prompt     提示详情
 *  @param confirmButtonTitle  确认按钮名称
 *  @param cancelButtonTitle   取消按钮名称
 *
 *  @param clickBlock 点击事件
 *  @param parent 父控件
 */
+(void)alertWithTitle:(NSString *)title andWithPrompt:(NSString *)prompt andWithConfirmButtonTitle:(NSString *)confirmButtonTitle andWithCancelButtonTitle:(NSString *)cancelButtonTitle  andWithClickBlock:(HGBAlertClickBlock)clickBlock InParent:(UIViewController *)parent;
#pragma mark alert多键
/**
 *  多键-功能－标题提示
 *
 *  @param title    提示标题
 *  @param prompt     提示详情
 *  @param buttonTitles  按钮名称集合
 *
 *  @param clickBlock 点击事件
 *  @param parent 父控件
 */
+(void)alertWithTitle:(NSString *)title andWithPrompt:(NSString *)prompt andWithButtonTitles:(NSArray<NSString *>*)buttonTitles andWithClickBlock:(HGBAlertClickBlock)clickBlock InParent:(UIViewController *)parent;
#pragma mark sheet
/**
 *  sheet-功能
 *
 *  @param buttonTitles  按钮名称集合
 *
 *  @param clickBlock 点击事件
 *  @param parent 父控件
 */
+(void)sheetWithButtonTitles:(NSArray<NSString *>*)buttonTitles andWithClickBlock:(HGBAlertClickBlock)clickBlock InParent:(UIViewController *)parent;
/**
*  sheet-功能－标题提示
*
*  @param title    提示标题
*  @param prompt     提示详情
*  @param buttonTitles  按钮名称集合
*
*  @param clickBlock 点击事件
*  @param parent 父控件
*/
+(void)sheetWithTitle:(NSString *)title andWithPrompt:(NSString *)prompt andWithButtonTitles:(NSArray<NSString *>*)buttonTitles andWithClickBlock:(HGBAlertClickBlock)clickBlock InParent:(UIViewController *)parent;
#pragma mark 设置
/**
 配置标题颜色

 @param titleColor 标题颜色
 */
+(void)setTitleColor:(UIColor *)titleColor;
/**
 配置标题字体大小

 @param titleFontSize 标题字体大小
 */
+(void)setTitleFontSize:(CGFloat)titleFontSize;

/**
 配置副标题颜色

 @param subTitleColor 副标题颜色
 */
+(void)setSubTitleColor:(UIColor *)subTitleColor;
/**
 配置副标题字体大小

 @param subTitleFontSize 副标题字体大小
 */
+(void)setSubTitleFontSize:(CGFloat)subTitleFontSize;
/**
 配置按钮标题颜色

 @param buttonTitleColor 按钮标题颜色
 */
+(void)setButtonTitleColor:(UIColor *)buttonTitleColor;
/**
 配置按钮标题字体大小

 @param buttonTitleFontSize 按钮标题字体大小
 */
+(void)setButtonTitleFontSize:(CGFloat)buttonTitleFontSize;


@end
