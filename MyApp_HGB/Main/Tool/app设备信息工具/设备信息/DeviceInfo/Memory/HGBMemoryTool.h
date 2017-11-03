//
//  HGBMemoryTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/31.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBMemoryTool : NSObject
#pragma mark Memory
/**
 获取总内存空间

 @return 总内存空间
 */
+ (int64_t)getTotalMemory;
/**
 获取活跃的内存空间

 @return 活跃的内存空间
 */
+ (int64_t)getActiveMemory;
/**
 获取不活跃的内存空间

 @return 不活跃的内存空间
 */
+ (int64_t)getInActiveMemory;
/**
 获取空闲的内存空间

 @return 空闲的内存空间
 */
+ (int64_t)getFreeMemory;
/**
 获取正在使用的内存空间

 @return 正在使用的内存空间
 */
+ (int64_t)getUsedMemory;
/**
 获取存放内核的内存空间

 @return 存放内核的内存空间
 */
+ (int64_t)getWiredMemory;
/**
 获取可释放的内存空间

 @return 可释放的内存空间
 */
+ (int64_t)getPurgableMemory;
@end
