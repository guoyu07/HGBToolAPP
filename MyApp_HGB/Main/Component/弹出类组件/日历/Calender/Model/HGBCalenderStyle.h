//
//  HGBCalenderStyle.h
//  测试
//
//  Created by huangguangbao on 2017/10/18.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 按钮拖动类型
 */
typedef enum HGBCalenderTitleStyle
{
    HGBCalenderTitleStyleNO,//无标题
    HGBCalenderTitleStyleTitle,//标题
    HGBCalenderTitleStyleTrans//可切换

}HGBCalenderTitleStyle;

/**
 按钮拖动类型
 */
typedef enum HGBCalenderType
{
    HGBCalenderTypeGregorian,//标准日期
    HGBCalenderTypeChinese//农历
}HGBCalenderType;


@interface HGBCalenderStyle : NSObject
/**
 日历类型
 */
@property(assign,nonatomic)HGBCalenderType calenderType;
/**
 有无提示
 */
@property(assign,nonatomic)BOOL isShowPrompt;

/**
 是否以周日开头
 */
@property(assign,nonatomic)BOOL isWeekHead;


/**
 是否显示留白日期
 */
@property(assign,nonatomic)BOOL isShowOver;
#pragma mark 头部
/**
 头部类型
 */
@property(assign,nonatomic)HGBCalenderTitleStyle titleStyle;

#pragma mark 头部提示颜色
/**
 年颜色
 */
@property(strong,nonatomic)UIColor *yearColor;
/**
 年背景颜色
 */
@property(strong,nonatomic)UIColor *yearBackColor;
/**
 月颜色
 */
@property(strong,nonatomic)UIColor *monthColor;
/**
 月背景颜色
 */
@property(strong,nonatomic)UIColor *monthBackColor;
/**
 左减少图片
 */
@property(strong,nonatomic)UIImage *leftImage;
/**
 右增加图片
 */
@property(strong,nonatomic)UIImage *rightImage;

#pragma mark 背景颜色
/**
 背景颜色
 */
@property(strong,nonatomic)UIColor *backgroundColor;
/**
 越界日期背景颜色
 */
@property(strong,nonatomic)UIColor *overBackColor;
/**
 越界日期颜色
 */
@property(strong,nonatomic)UIColor *overColor;
//@property(strong,nonatomic)NSArray *
#pragma mark 标题颜色
/**
 标题颜色
 */
@property(strong,nonatomic)UIColor *titleColor;
/**
 标题背景颜色
 */
@property(strong,nonatomic)UIColor *titleBackColor;
#pragma mark day标题颜色

/**
 日标题边框颜色
 */
@property(strong,nonatomic)UIColor *dayTitleBordorColor;
/**
 日标题颜色
 */
@property(strong,nonatomic)UIColor *dayTitleColor;

/**
 周末标题颜色
 */
@property(strong,nonatomic)UIColor *weekDayTitleColor;
/**
 周末标题背景颜色
 */
@property(strong,nonatomic)UIColor *weekDayTitleBackColor;
/**
 日标题背景颜色
 */
@property(strong,nonatomic)UIColor *dayTitleBackColor;

#pragma mark 日期颜色
/**
 日期边框颜色
 */
@property(strong,nonatomic)UIColor *dayBordorColor;
/**
 周末颜色
 */
@property(strong,nonatomic)UIColor *weekDayColor;
/**
 周末背景颜色
 */
@property(strong,nonatomic)UIColor *weekDayBackColor;

/**
 日期颜色
 */
@property(strong,nonatomic)UIColor *normalDayColor;
/**
 日期背景颜色
 */
@property(strong,nonatomic)UIColor *normalDayBackColor;


/**
 选中日期颜色
 */
@property(strong,nonatomic)UIColor *selectDayColor;
/**
 选中日期背景颜色
 */
@property(strong,nonatomic)UIColor *selectBackColor;
/**
 当前日期颜色
 */
@property(strong,nonatomic)UIColor *currnetDayColor;
/**
 当前日期背景颜色
 */
@property(strong,nonatomic)UIColor *currnetBackColor;

/**
 提示文字颜色
 */
@property(strong,nonatomic)UIColor *normalPromptTextColor;
/**
 选中提示文字颜色
 */
@property(strong,nonatomic)UIColor *selectPromptTextColor;
/**
 当前日期提示文字颜色
 */
@property(strong,nonatomic)UIColor *currnetPromptTextColor;


@end
