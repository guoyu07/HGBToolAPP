//
//  HGBTabBarButton.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/27.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGBTabBarButton : UIButton
@property (nonatomic, strong) UITabBarItem *item;
/**
 角标颜色
 */
@property(strong,nonatomic)UIColor *badgeNormalTextColor;
/**
 角标选中颜色
 */
@property(strong,nonatomic)UIColor *badgeSelectTextColor;
/**
 角标背景颜色
 */
@property(strong,nonatomic)UIColor *badgeBackColor;
@end
