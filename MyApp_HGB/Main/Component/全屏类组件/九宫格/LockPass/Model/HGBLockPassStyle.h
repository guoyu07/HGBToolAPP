//
//  HGBLockPassStyle.h
//  测试app
//
//  Created by huangguangbao on 2017/7/4.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HGBLockPassStyle : NSObject
/**
 背景图片
 */
@property(strong,nonatomic)UIImage *backgrondImage;

/**
 按钮未选中图片
 */
@property(strong,nonatomic)UIImage *buttonUnSelectImage;
/**
 按钮选中图片
 */
@property(strong,nonatomic)UIImage *buttonSelectImage;

/**
 按钮可点击状态颜色
 */
@property(strong,nonatomic)UIColor *buttonEnableBackColor;
/**
 按钮可点击状态字体颜色
 */
@property(strong,nonatomic)UIColor *buttonEnableForeColor;


/**
 按钮可点击状态颜色
 */
@property(strong,nonatomic)UIColor *buttonUnableBackColor;
/**
 按钮可点击状态字体颜色
 */
@property(strong,nonatomic)UIColor *buttonUnableForeColor;

/**
 导航栏颜色
 */
@property(strong,nonatomic)UIColor *navColor;


/**
 导航栏文字颜色
 */
@property(strong,nonatomic)UIColor *navTextColor;

/**
 界面提示文字颜色
 */
@property(strong,nonatomic)UIColor *promptTextColor;


/**
 连线颜色
 */
@property(strong,nonatomic)UIColor *pathColor;
@end
