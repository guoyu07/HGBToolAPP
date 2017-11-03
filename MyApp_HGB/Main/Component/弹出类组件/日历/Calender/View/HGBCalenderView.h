//
//  HGBCalenderView.h
//  测试
//
//  Created by huangguangbao on 2017/10/18.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBCalenderStyle.h"


@class HGBCalenderView;
/**
 日历代理
 */
@protocol HGBCalenderViewDelegate <NSObject>
/**
 返回日历点击的结果

 @param date 选中日期
 */
-(void)calenderView:(HGBCalenderView *)calender didFinishWithDate:(NSDate *)date;
@optional
/**
 返回日历点击周的结果
 
 @param week 选中周
 */
-(void)calenderView:(HGBCalenderView *)calender didClickWeek:(NSInteger )week;
/**
 返回日历点击的结果

 @param year 选中年
 @param month 选中月
 @param day 选中日
 @param week 选中周
 */
-(void)calenderView:(HGBCalenderView *)calender didFinishWithYear:(NSInteger )year andWithMonth:(NSInteger )month andWithDay:(NSInteger )day andWithWeek:(NSInteger )week;
@end
@interface HGBCalenderView : UIView
/**
 代理
 */
@property(strong,nonatomic)id<HGBCalenderViewDelegate>delegate;
/**
 样式
 */
@property(strong,nonatomic)HGBCalenderStyle *style;
/**
 显示的日期
 */
@property(strong,nonatomic)NSDate *showDate;
/**
 选中日期-不设置没有选中
 */
@property(strong,nonatomic)NSDate *selectDate;
/**
 提示显示 1-29 30 31 对应
 */
@property(strong,nonatomic)NSMutableDictionary *promptDic;
@end
