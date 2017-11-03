//
//  HGBDateTool.m
//  测试app
//
//  Created by huangguangbao on 2017/6/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBDateTool.h"


#ifndef HVersion
#define HVersion [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
#endif

#ifndef KiOS6Later
#define KiOS6Later (HVersion >= 6)
#endif

#ifndef KiOS7Later
#define KiOS7Later (HVersion >= 7)
#endif

#ifndef KiOS8Later
#define KiOS8Later (HVersion >= 8)
#endif

#ifndef KiOS9Later
#define KiOS9Later (HVersion >= 9)
#endif

#ifndef KiOS10Later
#define KiOS10Later (HVersion >= 10)
#endif

#ifndef KiOS11Later
#define KiOS11Later (HVersion >= 11)
#endif

@implementation HGBDateTool
#pragma mark 获取时间
/**
 获取时间戳-秒级
 
 @return 秒级时间戳
 */
+ (NSString *)getSecondTimeStringSince1970
{
    NSDate* date = [NSDate date];
    NSTimeInterval interval=[date timeIntervalSince1970];  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%f", interval]; //转为字符型
    NSString *timeStr = [NSString stringWithFormat:@"%lf",[timeString doubleValue]*1000000];
    
    if(timeStr.length>=16){
        return [timeStr substringToIndex:16];
    }else{
        return timeStr;
    }
}
/**
 获取时间戳-毫秒级
 
 @return 毫秒级时间戳
 */
+ (NSString *)getMillisecondTimeStringSince1970
{
    NSDate* date = [NSDate date];
    NSTimeInterval interval=[date timeIntervalSince1970]*1000;  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%f", interval]; //转为字符型
    NSString *timeStr = [NSString stringWithFormat:@"%lf",[timeString doubleValue]*1000000];
    
    if(timeStr.length>=16){
        return [timeStr substringToIndex:16];
    }else{
        return timeStr;
    }
}

/**
 获取标准时间字符串
 
 @return 标准时间字符串
 */
+ (NSString *)getFormatTimeString
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [formatter stringFromDate:nowDate];
    return dateString;
}
/**
 获取网络时间
 
 @return 网络时间
 */
+(NSDate *)getInternetDate
{
    NSString *urlString = @"https://m.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    // 实例化NSMutableURLRequest，并进行参数配置
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString: urlString]];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    [request setTimeoutInterval: 2];
    
    [request setHTTPShouldHandleCookies:FALSE];
    
    [request setHTTPMethod:@"GET"];
    
    
    
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    // 处理返回的数据
    
    //    NSString *strReturn = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    
    
//    NSLog(@"response is %@",response);
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length]-4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];
    
    return netDate;
}
/**
 获取网络时间标准字符串
 
 @return 网络时间字符串
 */
+(NSString *)getInternetDateFormatTimeString{
    NSString *urlString = @"https://m.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    // 实例化NSMutableURLRequest，并进行参数配置
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString: urlString]];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    [request setTimeoutInterval: 2];
    
    [request setHTTPShouldHandleCookies:FALSE];
    
    [request setHTTPMethod:@"GET"];
    
    
    
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    // 处理返回的数据
    
    //    NSString *strReturn = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    
    
//    NSLog(@"response is %@",response);
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length]-4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [formatter stringFromDate:netDate];
    return dateString;
}
#pragma mark 时间转换
/**
 将日期转换为标准时间字符串
 
 @param date 时间
 @return 标准时间字符串
 */
+(NSString *)getFormatDateStringFromDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

/**
 将标准时间字符串转换为日期
 
 @param dateString 时间字符串
 @return 标准时间
 */
+(NSDate *)getDateFromFormatDateString:(NSString *)dateString{
    if(dateString==nil||dateString.length==0){
        return nil;
    }
    dateString=[HGBDateTool getNumberFromString:dateString];

    if(dateString.length<8){
        return nil;
    }
       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if(dateString.length==14){
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
    }else if(dateString.length==8){
        [formatter setDateFormat:@"yyyyMMdd"];
    }else if (dateString.length==10){
        [formatter setDateFormat:@"yyyyMMddHH"];
    }else {
        [formatter setDateFormat:@"yyyyMMddHHmm"];
    }
    
    NSDate *date= [formatter dateFromString:dateString];
    return date;
}
/**
 时间组件转时间

 @param dateComponents 时间组件
 @return 时间
 */
+(NSDate *)dateFromDateComponents:(NSDateComponents *)dateComponents{
    if(dateComponents==nil){
        return nil;
    }
    NSCalendar *gregorian;
#ifdef KiOS8Later
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    uint flags;
#ifdef KiOS8Later
    flags= NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
#else
    flags= NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
#endif

    NSDate *date = [gregorian dateFromComponents:dateComponents];
    return date;
}
/**
 时间转时间组件

 @param date 时间
 @return 时间组件
 */
+(NSDateComponents *)dateComponentsFromDate:(NSDate *)date{
    if(date==nil){
        return nil;
    }
    NSCalendar *gregorian;
#ifdef KiOS8Later
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    NSDateComponents *components = [[NSDateComponents alloc] init];

    NSString *year,*month,*day,*hour,*minute,*seconed;
    NSDateFormatter *f=[[NSDateFormatter alloc]init];
    f.dateFormat=@"yyyy";
    year=[f stringFromDate:date];
    f.dateFormat=@"MM";
    month=[f stringFromDate:date];
    f.dateFormat=@"dd";
    day=[f stringFromDate:date];
    f.dateFormat=@"HH";
    hour=[f stringFromDate:date];
    f.dateFormat=@"mm";
    minute=[f stringFromDate:date];
    f.dateFormat=@"ss";
    seconed=[f stringFromDate:date];

     [components setYear:year.integerValue];
    [components setMonth:month.integerValue];
     [components setDay:day.integerValue];
     [components setHour:hour.integerValue];
     [components setMinute:minute.integerValue];
     [components setSecond:seconed.integerValue];

    return components;
}
/**
 时间组件转时间标准字符串

 @param dateComponents 时间组件
 @return 时间标准字符串
 */
+(NSString *)dateFormatStringFromDateComponents:(NSDateComponents *)dateComponents{
    if(dateComponents==nil){
        return nil;
    }
    NSCalendar *gregorian;
#ifdef KiOS8Later
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#endif

    NSDate *date = [gregorian dateFromComponents:dateComponents];
    return [HGBDateTool getFormatDateStringFromDate:date];
}
/**
 时间标准转时间组件

 @param dateString 时间标准
 @return 时间组件
 */
+(NSDateComponents *)dateComponentsFromDateFormatString:(NSString *)dateString{
    NSDate *date=[HGBDateTool getDateFromFormatDateString:dateString];
    if(date==nil){
        return nil;
    }
    NSCalendar *gregorian;
#ifdef KiOS8Later
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    NSDateComponents *components = [[NSDateComponents alloc] init];

    NSString *year,*month,*day,*hour,*minute,*seconed;
    NSDateFormatter *f=[[NSDateFormatter alloc]init];
    f.dateFormat=@"yyyy";
    year=[f stringFromDate:date];
    f.dateFormat=@"MM";
    month=[f stringFromDate:date];
    f.dateFormat=@"dd";
    day=[f stringFromDate:date];
    f.dateFormat=@"HH";
    hour=[f stringFromDate:date];
    f.dateFormat=@"mm";
    minute=[f stringFromDate:date];
    f.dateFormat=@"ss";
    seconed=[f stringFromDate:date];

    [components setYear:year.integerValue];
    [components setMonth:month.integerValue];
    [components setDay:day.integerValue];
    [components setHour:hour.integerValue];
    [components setMinute:minute.integerValue];
    [components setSecond:seconed.integerValue];

    return components;
}

#pragma mark 日期校验

/**
 *  校验日期范围-过去
 *
 *  @param dateString 日期字符串
 *
 *  @return 结果
 */
+(BOOL)IsCorrectPassDateString:(NSString *)dateString{
    if(dateString.length<8){
        return NO;
    }
    dateString=[HGBDateTool getNumberFromString:dateString];
    NSDateFormatter *f=[[NSDateFormatter alloc]init];
    if(dateString.length==14){
        [f setDateFormat:@"yyyyMMddHHmmss"];
    }else if(dateString.length==8){
        [f setDateFormat:@"yyyyMMdd"];
    }else if (dateString.length==10){
        [f setDateFormat:@"yyyyMMddHH"];
    }else {
        [f setDateFormat:@"yyyyMMddHHmm"];
    }
    
    if([dateString compare:[f stringFromDate:[NSDate date]]]<=0){
        
        return YES;
    }
    return NO;
}




/**
 *  校验日期范围-未来日期
 *
 *  @param dateString 日期字符串
 *
 *  @return 结果
 */
+(BOOL)IsCorrectCommingDateString:(NSString *)dateString{
    if(dateString.length<8){
        return NO;
    }
    dateString=[HGBDateTool getNumberFromString:dateString];
    NSDateFormatter *f=[[NSDateFormatter alloc]init];
    if(dateString.length==14){
        [f setDateFormat:@"yyyyMMddHHmmss"];
    }else if(dateString.length==8){
        [f setDateFormat:@"yyyyMMdd"];
    }else if (dateString.length==10){
        [f setDateFormat:@"yyyyMMddHH"];
    }else {
        [f setDateFormat:@"yyyyMMddHHmm"];
    }
    if([dateString compare:[f stringFromDate:[NSDate date]]]>=0){
        
        return YES;
    }
    return NO;
}

/**
 *  校验日期范围-过去
 *
 *  @param date 日期
 *
 *  @return 结果
 */
+(BOOL)IsCorrectPassDate:(NSDate *)date{
    
   
    NSDateFormatter *f=[[NSDateFormatter alloc]init];
    f.dateFormat=@"yyyyMMdd";
    if([[f stringFromDate:date] compare:[f stringFromDate:[NSDate date]]]<=0){
        
        return YES;
    }
    return NO;
}




/**
 *  校验日期范围-未来日期
 *
 *  @param date 日期
 *
 *  @return 结果
 */
+(BOOL)IsCorrectCommingDate:(NSDate *)date{
    NSDateFormatter *f=[[NSDateFormatter alloc]init];
    f.dateFormat=@"yyyyMMdd";
    if([[f stringFromDate:date] compare:[f stringFromDate:[NSDate date]]]>=0){
        
        return YES;
    }
    return NO;
}

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

    return [HGBDateTool weekForDate:date];
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

    return [HGBDateTool weekForDate:date];
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

    return [HGBDateTool weekForDate:date];
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
    return [HGBDateTool chineseYearForDate:date];
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
    return [HGBDateTool chineseMonthForDate:date];
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
    return [HGBDateTool chineseDayForDate:date];
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
    if(day==[HGBDateTool daysForYear:year andWithMonth:month]){
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
            return [HGBDateTool daysForYear:year andWithMonth:month-1];
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
    if(day==[HGBDateTool daysForYear:year andWithMonth:month]){
        return 1;
    }else{
        return day+1;
    }
}
#pragma mark 其他
/**
 *  获取数字字符串
 *
 *  @param string 原str
 *
 *  @return 字符串中的数字字符串
 */
+(NSString *)getNumberFromString:(NSString *)string{
    NSString *numStr=string;
    NSArray *numArr=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSRange r;
    for(int i=0;i<string.length;i++){
        (void)(r.length=1),r.location=i;
        NSString *sub=[string substringWithRange:r];
        if(![numArr containsObject:sub]){
            numStr=[numStr stringByReplacingCharactersInRange:r withString:@"-"];
        }
    }
    while ([numStr containsString:@"-"]) {
        numStr=[numStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    return numStr;
}
@end
