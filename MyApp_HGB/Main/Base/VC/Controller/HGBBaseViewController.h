//
//  HGBBaseViewController.h
//  测试
//
//  Created by huangguangbao on 2017/6/29.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGBBaseViewController : UIViewController

/**
 导航栏颜色-默认白色
 */
@property(strong,nonatomic)UIColor *navColor;

/**
 导航栏背景图
 */
@property(strong,nonatomic)UIImage *navImage;



/**
 导航栏标题
 */
@property(strong,nonatomic)NSString *navTitle;

/**
 导航栏标题颜色
 */
@property(strong,nonatomic)UIColor *navTitleColor;

/**
 导航栏标题view
 */
@property(strong,nonatomic)UIView *navTitleView;


/**
 导航栏左按钮标题
 */
@property(strong,nonatomic)NSString *leftButtonTitle;

/**
 导航栏左按钮标题颜色
 */
@property(strong,nonatomic)UIColor *leftButtonTitleColor;

/**
 导航栏左按钮标题图片
 */
@property(strong,nonatomic)UIImage *leftButtonImage;

/**
 导航栏左view
 */
@property(strong,nonatomic)UIView *leftView;


/**
 导航栏右按钮标题
 */
@property(strong,nonatomic)NSString *rightButtonTitle;

/**
 导航栏右按钮标题颜色
 */
@property(strong,nonatomic)UIColor *rightButtonTitleColor;

/**
 导航栏右按钮标题图片
 */
@property(strong,nonatomic)UIImage *rightButtonImage;

/**
 导航栏右view
 */
@property(strong,nonatomic)UIView *rightView;


/**
 登录状态
 */
-(void)applicationDidFinishLaunching;
/**
 将进入前台
 */
- (void)applicationWillEnterForeground;
/**
 进入后台
 */
-(void)applicationDidEnterBackground;
/**
 将进入后台
 */
-(void)applicationWillResignActive;
/**
 进入前台
 */
-(void)applicationDidBecomeActive;

/**
 导航栏基础

 @param title 标题
 */
-(void)createNavigationItemWithTitle:(NSString *)title;
/**
 左按钮功能

 @param _b 左按钮
 */
-(void)leftButtonHandle:(UIBarButtonItem *)_b;
/**
 右按钮功能

 @param _b 右按钮
 */
-(void)rightButtonHandle:(UIBarButtonItem *)_b;
@end
