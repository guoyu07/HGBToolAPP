//
//  HGBCalenderTool.m
//  测试
//
//  Created by huangguangbao on 2017/10/23.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCalenderTool.h"
#ifndef SYSTEM_VERSION
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
#endif

#ifndef KiOS6Later
#define KiOS6Later (SYSTEM_VERSION >= 6)
#endif

#ifndef KiOS7Later
#define KiOS7Later (SYSTEM_VERSION >= 7)
#endif

#ifndef KiOS8Later
#define KiOS8Later (SYSTEM_VERSION >= 8)
#endif

#ifndef KiOS9Later
#define KiOS9Later (SYSTEM_VERSION >= 9)
#endif

#ifndef KiOS10Later
#define KiOS10Later (SYSTEM_VERSION >= 10)
#endif

@implementation HGBCalenderTool

#pragma mark 判断天数
/**
 获取某年天数

 @param year 年
 @return 天数
 */
+(NSInteger)daysForYear:(NSInteger)year{
    if((year%4==0)&&(year%400!=0)){
        return 366;
    }
    return 365;
}

/**
 获取某年某月天数

 @param year 年
 @param month 月
 @return 天数
 */
+(NSInteger)daysForYear:(NSInteger)year andWithMonth:(NSInteger )month{
    if(month<1||month>12){
        return 0;
    }
    NSArray *days=@[@"31",@"28",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31"];
    if((year%4==0)&&(year%400!=0)){
        days=@[@"31",@"29",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31"];;
    }

    NSString *daysStr=days[month-1];
    return daysStr.integerValue;
}
#pragma mark - 获取星期
/**
 一年第一天星期

 @param year 年
 @return 星期  1-7 周日-周六
 */
+(NSInteger )weekForFirstDayInYear:(NSInteger )year{
    NSString *dateString=[NSString stringWithFormat:@"%0.4ld0101",year];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=@"yyyyMMdd";
    NSDate *date=[dateFormatter dateFromString:dateString];

    return [HGBCalenderTool weekForDate:date];
}
/**
 某月第一天星期

 @param year 年
 @param month 月
 @return 星期  1-7 周日-周六
 */
+(NSInteger )weekForFirstDayInYear:(NSInteger )year andMonth:(NSInteger)month{
    NSString *dateString=[NSString stringWithFormat:@"%0.4ld%0.2ld01",year,month];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=@"yyyyMMdd";
    NSDate *date=[dateFormatter dateFromString:dateString];

    return [HGBCalenderTool weekForDate:date];
}
/**
 某一天星期

 @param year 年
 @param month 月
 @param day 日
 @return 星期  1-7 周日-周六
 */
+(NSInteger )weekForYear:(NSInteger )year andMonth:(NSInteger)month andDay:(NSInteger )day{
    NSString *dateString=[NSString stringWithFormat:@"%0.4ld%0.2ld%0.2ld",year,month,day];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=@"yyyyMMdd";
    NSDate *date=[dateFormatter dateFromString:dateString];

    return [HGBCalenderTool weekForDate:date];
}

/**
 获取星期

 @param date 日期
 @return 星期  1 2 3 4 5 6 7 星期日-星期六
 */
+(NSInteger )weekForDate:(NSDate *)date
{
    if(date==nil){
        return 0;
    }
    NSCalendar *calendar;
    NSInteger unitFlags ;
#ifdef KiOS8Later
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
#else
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
#endif
    // 添加日期
    NSDateComponents *comps = [[NSDateComponents alloc] init];

    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    comps = [calendar components:unitFlags fromDate:date];

    return [comps weekday];
}
/**
 星期几转字符串

 @param week 星期index
 @return 星期字符串
 */
+(NSString *)week:(NSInteger)week
{
    NSString *weekStr=nil;
    if(week==1)
    {
        weekStr=@"星期天";
    }else if(week==2){
        weekStr=@"星期一";

    }else if(week==3){
        weekStr=@"星期二";

    }else if(week==4){
        weekStr=@"星期三";

    }else if(week==5){
        weekStr=@"星期四";

    }else if(week==6){
        weekStr=@"星期五";

    }else if(week==7){
        weekStr=@"星期六";

    }
    return weekStr;
}
#pragma mark 农历
/**
 获取某年某月农历年

 @param date 日期
 @return 农历年
 */
+(NSString *)chineseYearForDate:(NSDate *)date{
    if(date==nil){
        return nil;
    }
    NSArray *chineseYears = [NSArray arrayWithObjects:@"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",@"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",@"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",@"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑", @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",@"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",@"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];

    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;


    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];

    NSString *yearString = [chineseYears objectAtIndex:localeComp.year-1];
    return yearString;
}
/**
 获取某年某月农历年

 @param year 年
 @param month 月
 @param day 日
 @return 农历年
 */
+(NSString* )chineseYearForFirstDayForYear:(NSInteger )year andMonth:(NSInteger)month andDay:(NSInteger )day{
    NSString *dateString=[NSString stringWithFormat:@"%0.4ld%0.2ld%0.2ld",year,month,day];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=@"yyyyMMdd";
    NSDate *date=[dateFormatter dateFromString:dateString];
    return [HGBCalenderTool chineseYearForDate:date];
}

/**
 获取某年某月农历月份

 @param date 日期
 @return 农历月份
 */
+(NSString *)chineseMonthForDate:(NSDate *)date{
    if(date==nil){
        return nil;
    }
    NSArray * monthArr = [NSArray arrayWithObjects:
                          @"正月", @"二月", @"三月", @"四月", @"五月",@"六月", @"七月", @"八月", @"九月", @"十月", @"冬月", @"腊月", nil];

    unsigned unitFlags =  NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];

    NSString *monthString = [monthArr objectAtIndex:localeComp.month-1];

    return monthString;


}
/**
 获取某年某月农历月份

 @param year 年
 @param month 月
 @param day 日
 @return 农历月份
 */
+(NSString *)chineseMonthForYear:(NSInteger )year andMonth:(NSInteger)month andDay:(NSInteger )day{
    NSString *dateString=[NSString stringWithFormat:@"%0.4ld%0.2ld%0.2ld",year,month,day];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=@"yyyyMMdd";
    NSDate *date=[dateFormatter dateFromString:dateString];
    return [HGBCalenderTool chineseMonthForDate:date];
}
/**
 获取某年某月农历日

 @param date 日期
 @return 农历日
 */
+(NSString *)chineseDayForDate:(NSDate *)date{
    if(date==nil){
        return nil;
    }
    NSArray *  dayArr = [NSArray arrayWithObjects:
                         @"初一", @"初二", @"初三", @"初四",@"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",@"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    unsigned unitFlags =  NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];

    NSString *dayString = [dayArr objectAtIndex:localeComp.day-1];
    return dayString;
}
/**
 获取某年某月农历日

 @param year 年
 @param month 月
 @param day 日
 @return 农历日
 */
+(NSString* )chineseDayForYear:(NSInteger )year andMonth:(NSInteger)month andDay:(NSInteger )day{
    NSString *dateString=[NSString stringWithFormat:@"%0.4ld%0.2ld%0.2ld",year,month,day];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=@"yyyyMMdd";
    NSDate *date=[dateFormatter dateFromString:dateString];
    return [HGBCalenderTool chineseDayForDate:date];
}
#pragma mark 日期计算
/**
 获取上一个月的年

 @param month 月份
 @param year 年
 @return 上一个月的年份
 */
+(NSInteger)getYearForBeforeMonthInYear:(NSInteger)year andMonth:(NSInteger)month{
    if(month==1){
        return year-1;
    }else {
        return year;
    }
}
/**
 获取下一个月的年

 @param month 月份
 @param year 年
 @return 下一个月的年份
 */
+(NSInteger)getYearForNextMonthInYear:(NSInteger)year andMonth:(NSInteger)month{
    if(month==12){
        return year+1;
    }else {
        return year;
    }
}
/**
 获取上一个月的月份

 @param month 月份
 @param year 年
 @return 上一个月的月份
 */
+(NSInteger)getMonthForBeforeMonthInYear:(NSInteger)year andMonth:(NSInteger)month{
    if(month==1){
        return 12;
    }else {
        return month-1;
    }
}
/**
 获取下一个月的月份

 @param month 月份
 @param year 年
 @return 下一个月的月份
 */
+(NSInteger)getMonthForNextMonthInYear:(NSInteger)year andMonth:(NSInteger)month{
    if(month==12){
        return 1;
    }else {
        return month+1;
    }
}
/**
 获取上一日的年

 @param year 当前年
 @param month 当前月
 @param day 当前日
 @return 上一个日的年份
 */
+(NSInteger)getYearForBeforeDayInYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day{
    if(month==1&&day==1){
        return year-1;
    }else{
        return year;
    }
}
/**
 获取下一日的年

 @param year 当前年
 @param month 当前月
 @param day 当前日
 @return 下一日的年份
 */
+(NSInteger)getYearForNextDayInYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day{
    if(month==12&&day==31){
        return year-1;
    }else{
        return year;
    }
}
/**
 获取上一日的月份

 @param year 当前年
 @param month 当前月
 @param day 当前日
 @return 上一日的月份
 */
+(NSInteger)getMonthForBeforeDayInYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day{
    if(day==1){
        if(month==1){
            return 12;

        }else{
            return month-1;

        }
    }else{
        return month;
    }
}
/**
 获取下一日的月份

 @param year 当前年
 @param month 当前月
 @param day 当前日
 @return 下一日的月份
 */
+(NSInteger)getMonthForNextDayInYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day{
    if(day==[HGBCalenderTool daysForYear:year andWithMonth:month]){
        if(month==12){
            return 1;

        }else{
            return month+1;

        }
    }else{
        return month;
    }
}
/**
 获取上一日的日

 @param year 当前年
 @param month 当前月
 @param day 当前日
 @return 上一日的日
 */
+(NSInteger)getDayForBeforeDayInYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day{
    if(day==1){
        if(month==1){
            return 31;
        }else{
            return [HGBCalenderTool daysForYear:year andWithMonth:month-1];
        }
    }else{
        return day-1;
    }
}
/**
 获取下一日的日

 @param year 当前年
 @param month 当前月
 @param day 当前日
 @return 下一日的日
 */
+(NSInteger)getDayForNextDayInYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day{
    if(day==[HGBCalenderTool daysForYear:year andWithMonth:month]){
        return 1;
    }else{
        return day+1;
    }
}
@end
