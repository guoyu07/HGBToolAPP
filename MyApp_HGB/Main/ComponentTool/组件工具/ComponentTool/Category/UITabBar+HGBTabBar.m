//
//  UITabBar+HGBTabBar.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/16.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "UITabBar+HGBTabBar.h"
#define TabbarItemNums  3.0    //tabbar的数量 如果是5个设置为5
@implementation UITabBar (HGBTabBar)
/**
 显示小红点

 @param index 位置
 @param text 显示内容
 @param textColor 内容颜色
 @param backColor 背景颜色
 @param itemsCount 项数
 */
-(void)showBadgeOnItemIndex:(NSInteger)index andWithText:(NSString *)text andWithTextColor:(UIColor *)textColor andWithBackColor:(UIColor *)backColor andWithTabItemsCount:(NSInteger)itemsCount{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];

    //新建小红点
    UILabel *badgeView = [[UILabel alloc]init];
    badgeView.text=text;
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 7.0;//圆形
    badgeView.textAlignment=NSTextAlignmentCenter;
    badgeView.font=[UIFont systemFontOfSize:8];
    if(backColor==nil){
        backColor=[UIColor redColor];
    }
    badgeView.backgroundColor = backColor;
    if(textColor==nil){
        textColor=[UIColor whiteColor];
    }
    badgeView.textColor=textColor;
    CGRect tabFrame = self.frame;

    if(itemsCount==0){
        itemsCount=TabbarItemNums;
    }
    //确定小红点的位置
    CGFloat percentX = (index + 0.6) / itemsCount;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 14.0, 14.0);//圆形大小为14
    badgeView.clipsToBounds = YES;
    [self addSubview:badgeView];
}
/**
 显示小红点

 @param index 位置
 @param color 颜色
 @param itemsCount 项数
 */
-(void)showBadgeOnItemIndex:(NSInteger)index  andWithColor:(UIColor *)color andWithTabItemsCount:(NSInteger)itemsCount{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];

    //新建小红点
    UIView *badgeView = [[UIView alloc]init];

    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 4.0;//圆形

    if(color==nil){
        color=[UIColor redColor];
    }
    badgeView.backgroundColor = color;

    CGRect tabFrame = self.frame;

    if(itemsCount==0){
        itemsCount=TabbarItemNums;
    }
    //确定小红点的位置
    CGFloat percentX = (index + 0.6) / itemsCount;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 8.0, 8.0);//圆形大小为8
    badgeView.clipsToBounds = YES;
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(NSInteger)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(NSInteger)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}
@end
