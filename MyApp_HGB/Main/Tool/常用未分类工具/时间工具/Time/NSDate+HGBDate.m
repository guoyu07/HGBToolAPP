//
//  NSDate+HGBDate.m
//  测试app
//
//  Created by huangguangbao on 2017/6/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "NSDate+HGBDate.h"


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

@implementation NSDate (HGBDate)
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
 @return 标准时间字符串时间
 */
-(NSString *)getFormatDateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [formatter stringFromDate:self];
    return dateString;
}

#pragma mark 日期校验
/**
 *  校验日期范围-过去
 *
 *  @return 结果
 */
-(BOOL)IsCorrectPassDate{
    
    
    NSDateFormatter *f=[[NSDateFormatter alloc]init];
    f.dateFormat=@"yyyyMMdd";
    if([[f stringFromDate:self] compare:[f stringFromDate:[NSDate date]]]<=0){
        
        return YES;
    }
    return NO;
}




/**
 *  校验日期范围-未来日期
 *
 *  @return 结果
 */
-(BOOL)IsCorrectCommingDate{
    NSDateFormatter *f=[[NSDateFormatter alloc]init];
    f.dateFormat=@"yyyyMMdd";
    if([[f stringFromDate:self] compare:[f stringFromDate:[NSDate date]]]>=0){
        
        return YES;
    }
    return NO;
}
@end
