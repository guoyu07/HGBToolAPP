//
//  HGBCPUTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/31.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBCPUTool : NSObject
#pragma mark CPU
/**
 获取CPU处理器

 @return cpu处理器
 */
+(NSString *)getCPUProcessor;
/**  */
/**
 获取CPU数量

 @return CPU数量
 */
+ (NSUInteger)getCPUCount;

/**
 获取CPU总的使用百分比

 @return CPU总的使用百分比
 */
+(float)getCPUUsage;

/**
 获取单个CPU使用百分比

 @return  单个CPU使用百分比
 */
+ (NSArray *)getPerCPUUsage;
/**
 获取CPU线程频率

 @return CPU线程频率
 */
+ (NSUInteger)getCPUFrequency;
@end
