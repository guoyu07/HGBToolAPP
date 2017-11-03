//
//  HGBTabBar.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/27.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBTabBar.h"
#import "HGBTabBarButton.h"
@interface HGBTabBar()
@property (nonatomic, weak) HGBTabBarButton *selectedButton;
@end
@implementation HGBTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {


    }
    return self;
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    // 1.创建按钮
    HGBTabBarButton *button = [[HGBTabBarButton alloc] init];
    [self addSubview:button];

    // 2.设置数据
    button.item = item;
    button.badgeSelectTextColor=self.badgeSelectTextColor;
    button.badgeNormalTextColor=self.badgeNormalTextColor;
    button.badgeBackColor=self.badgeBackColor;


    // 3.监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];

    // 4.默认选中第0个按钮
    if (self.subviews.count == 1) {
        [self buttonClick:button];
    }
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(HGBTabBarButton *)button
{
    // 1.通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:button.tag];
    }

    // 2.设置按钮的状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    // 按钮的frame数据
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonW = self.frame.size.width / self.subviews.count;
    CGFloat buttonY = 0;

    for (int index = 0; index<self.subviews.count; index++) {
        // 1.取出按钮
        HGBTabBarButton *button = self.subviews[index];

        // 2.设置按钮的frame
        CGFloat buttonX = index * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);

        // 3.绑定tag
        button.tag = index;
    }
}
#pragma mark get
-(UIColor *)badgeNormalTextColor{
    if(_badgeNormalTextColor==nil){
        _badgeNormalTextColor=[UIColor whiteColor];
    }
    return _badgeNormalTextColor;
}
-(UIColor *)badgeBackColor{
    if(_badgeBackColor==nil){
        _badgeBackColor=[UIColor redColor];
    }
    return _badgeBackColor;
}
-(UIColor *)badgeSelectTextColor{
    if(_badgeSelectTextColor==nil){
        _badgeSelectTextColor=[UIColor whiteColor];
    }
    return _badgeSelectTextColor;
}
@end
