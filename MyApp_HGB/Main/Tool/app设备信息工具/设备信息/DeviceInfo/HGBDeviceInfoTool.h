//
//  HGBDeviceInfoTool.h
//  设备相关信息
//
//  Created by huangguangbao on 2017/6/7.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HGBDeviceInfoTool : NSObject
#pragma mark 获取手机唯一标识
/**
 *  获取手机序列号
 *
 *  @return 获取的手机序列号
 */
+ (NSString *)getUniqueIdentifier;
/**
 获取UUID

 @return UUID-Keychain版
 */
+(NSString *)getKeychainUUID;
/**
 获取UUID-Defaults版

 @return UUID
 */
+(NSString *)getDefaultsUUID;
/**
 获取广告标识符

 @return 广告标识符
 */
- (NSString *)getIDFA;
#pragma mark 获取ip
/**
 获取IP地址

 @return IP地址
 */
+(NSString *)getIPAddress;
/**
 *  获取IP地址
 *
 *  @return 返回IP地址
 */
+ (NSString *)getIPAddressWithIpType:(NSString *)type;
/**
 获取所有的IP

 @return IP字典
 */
+ (NSDictionary *)getAllIPAddresses;
/**
 获取mac地址

 @return mac地址
 */
+ (NSString *)getMacAddress;
#pragma mark 获取设备信息
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
/**
 是否可以打电话

 @return 是否可以打电话
 */
+ (BOOL)canMakePhoneCall;
#endif

/**
 *  获取手机别名
 *
 *  @return 获取手机别名
 */
+ (NSString *)getUserPhoneName;
/**
 *  获取系统名称
 *
 *  @return 获取系统名称
 */
+ (NSString *)getSystemName;
/**
 *  获取手机系统版本
 *
 *  @return 手机系统版本
 */
+ (NSString *)getPhoneVersion;

/**
 *  获取手机基本类型
 *
 *  @return 手机基本类型
 */
+ (NSString *)getLocalPhoneModel;
/**
 *  获取手机型号
 *
 *  @return 手机型号
 */
+ (NSString *)getPhoneModel;


/**
 获取设备型号
 
 @return 设备型号
 */
+ (NSString *)getDeviceModelName;
#pragma mark 设备信息2
/**
 获取设备上次重启的时间

 @return 设备上次重启的时间
 */
+ (NSDate *)getSystemUptime;

/**
 获取总线程频率

 @return 总线程频率
 */
+ (NSUInteger)getBusFrequency;
/**
 获取CPU线程频率

 @return CPU线程频率
 */
+ (NSUInteger)getCPUFrequency;

/**
 获取当前设备主存

 @return 当前设备主存
 */
+ (NSUInteger)getRamSize;
#pragma mark CPU
/**
 获取CPU处理器

 @return CPU处理器
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
