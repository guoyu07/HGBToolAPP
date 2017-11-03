//
//  HGBDiskTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/31.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBDiskTool : NSObject
#pragma mark Disk

/**
 获取本 App 所占磁盘空间

 @return App 所占磁盘空间
 */
+ (NSString *)getApplicationSize;
/**
 获取磁盘总空间

 @return 磁盘总空间
 */
+ (int64_t)getTotalDiskSpace;
/**
 获取未使用的磁盘空间

 @return 未使用的磁盘空间
 */
+ (int64_t)getFreeDiskSpace;
/**
 获取已使用的磁盘空间

 @return 已使用的磁盘空间
 */
+ (int64_t)getUsedDiskSpace;
@end
