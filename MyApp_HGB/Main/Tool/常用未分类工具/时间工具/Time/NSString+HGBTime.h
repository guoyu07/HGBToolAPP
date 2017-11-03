//
//  NSString+HGBTime.h
//  HGBTimeTool
//
//  Created by huangguangbao on 2017/7/4.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HGBTime)
#pragma mark 获取时间
/**
 获取时间戳-秒级
 
 @return 秒级时间戳
 */
+ (NSString *)getSecondTimeStringSince1970;
/**
 获取时间戳-毫秒级
 
 @return 毫秒级时间戳
 */
+ (NSString *)getMillisecondTimeStringSince1970;
/**
 获取标准时间字符串
 
 @return 标准时间字符串
 */
+ (NSString *)getFormatTimeString;
/**
 获取网络时间
 
 @return 网络时间
 */
+(NSDate *)getInternetDate;

/**
 获取网络时间标准字符串
 
 @return 网络时间字符串
 */
+(NSString *)getInternetDateFormatTimeString;
#pragma mark 时间转换

/**
 将标准时间字符串转换为日期
 
 @return 标准时间字符串时间
 */
-(NSDate *)getDate;
#pragma mark 日期校验

/**
 *  校验日期范围-过去
 *
 *
 *  @return 结果
 */
-(BOOL)IsCorrectPassDateString;
/**
 *  校验日期范围-未来日期
 *
 *  @return 结果
 */
-(BOOL)IsCorrectCommingDateString;
@end
