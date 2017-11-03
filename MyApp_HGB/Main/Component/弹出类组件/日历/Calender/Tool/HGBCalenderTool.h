//
//  HGBCalenderTool.h
//  测试
//
//  Created by huangguangbao on 2017/10/23.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBCalenderTool : NSObject


#pragma mark 判断天数
/**
 获取某年天数

 @param year 年
 @return 天数
 */
+(NSInteger)daysForYear:(NSInteger)year;

/**
 获取某年某月天数

 @param year 年
 @param month 月
 @return 天数
 */
+(NSInteger)daysForYear:(NSInteger)year andWithMonth:(NSInteger )month;

#pragma mark - 获取星期
/**
 一年第一天星期

 @param year 年
 @return 星期  1-7 周日-周六
 */
+(NSInteger )weekForFirstDayInYear:(NSInteger )year;
/**
 某月第一天星期

 @param year 年
 @param month 月
 @return 星期  1-7 周日-周六
 */
+(NSInteger )weekForFirstDayInYear:(NSInteger )year andMonth:(NSInteger)month;

/**
 某一天星期

 @param year 年
 @param month 月
 @param day 日
 @return 星期  1-7 周日-周六
 */
+(NSInteger )weekForYear:(NSInteger )year andMonth:(NSInteger)month andDay:(NSInteger )day;
/**

 获取星期

 @param date 日期
 @return 星期  1 2 3 4 5 6 7 星期日-星期六
 */
+ (NSInteger )weekForDate:(NSDate *)date;

/**
 星期几转字符串

 @param week 星期index
 @return 星期字符串
 */
+(NSString *)week:(NSInteger)week;

#pragma mark 农历
/**
 获取某年某月农历年

 @param date 日期
 @return 农历年
 */
+(NSString *)chineseYearForDate:(NSDate *)date;
/**
 获取某年某月农历年

 @param year 年
 @param month 月
 @param day 日
 @return 农历年
 */
+(NSString* )chineseYearForFirstDayForYear:(NSInteger )year andMonth:(NSInteger)month andDay:(NSInteger )day;

/**
 获取某年某月农历月份

 @param date 日期
 @return 农历月份
 */
+(NSString *)chineseMonthForDate:(NSDate *)date;
/**
 获取某年某月农历月份

 @param year 年
 @param month 月
 @param day 日
 @return 农历月份
 */
+(NSString *)chineseMonthForYear:(NSInteger )year andMonth:(NSInteger)month andDay:(NSInteger )day;

/**
 获取某年某月农历日

 @param date 日期
 @return 农历日
 */
+(NSString *)chineseDayForDate:(NSDate *)date;
/**
获取某年某月农历日

 @param year 年
 @param month 月
 @param day 日
 @return 农历日
 */
+(NSString* )chineseDayForYear:(NSInteger )year andMonth:(NSInteger)month andDay:(NSInteger )day;

#pragma mark 日期计算
/**
 获取上月的年

 @param year 当前年
 @param month 当前月
 @return 上月的年份
 */
+(NSInteger)getYearForBeforeMonthInYear:(NSInteger)year andMonth:(NSInteger)month;
/**
 获取下月的年

 @param year 当前年
 @param month 当前月
 @return 下月的年份
 */
+(NSInteger)getYearForNextMonthInYear:(NSInteger)year andMonth:(NSInteger)month;
/**
 获取上月的月份

 @param year 当前年
 @param month 当前月
 @return 上月的月份
 */
+(NSInteger)getMonthForBeforeMonthInYear:(NSInteger)year andMonth:(NSInteger)month;
/**
 获取下月的月份

 @param year 当前年
 @param month 当前月
 @return 下月的月份
 */
+(NSInteger)getMonthForNextMonthInYear:(NSInteger)year andMonth:(NSInteger)month;


/**
 获取上一日的年

 @param year 当前年
 @param month 当前月
 @param day 当前日
 @return 上一个日的年份
 */
+(NSInteger)getYearForBeforeDayInYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day;
/**
 获取下一日的年

 @param year 当前年
 @param month 当前月
 @param day 当前日
 @return 下一日的年份
 */
+(NSInteger)getYearForNextDayInYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day;
/**
 获取上一日的月份

 @param year 当前年
 @param month 当前月
 @param day 当前日
 @return 上一日的月份
 */
+(NSInteger)getMonthForBeforeDayInYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day;
/**
 获取下一日的月份

 @param year 当前年
 @param month 当前月
 @param day 当前日
 @return 下一日的月份
 */
+(NSInteger)getMonthForNextDayInYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day;
/**
 获取上一日的日

 @param year 当前年
 @param month 当前月
 @param day 当前日
 @return 上一日的日
 */
+(NSInteger)getDayForBeforeDayInYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day;
/**
 获取下一日的日

 @param year 当前年
 @param month 当前月
 @param day 当前日
 @return 下一日的日
 */
+(NSInteger)getDayForNextDayInYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day;
@end
