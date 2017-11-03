//
//  HGBTabBar.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/27.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HGBTabBar;

@protocol HGBTabBarDelegate <NSObject>

@optional
- (void)tabBar:(HGBTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface HGBTabBar : UIView


@property (nonatomic, strong) id<HGBTabBarDelegate>delegate;
/**
 角标颜色
 */
@property(strong,nonatomic)UIColor *badgeNormalTextColor;
/**
 角标背景颜色
 */
@property(strong,nonatomic)UIColor *badgeBackColor;
/**
 角标选中颜色
 */
@property(strong,nonatomic)UIColor *badgeSelectTextColor;

/**
 添加角标按钮

 @param item item
 */
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@end
