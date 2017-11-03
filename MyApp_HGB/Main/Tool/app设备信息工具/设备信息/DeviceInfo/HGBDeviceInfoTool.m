//
//  HGBDeviceInfoTool.m
//  设备相关信息
//
//  Created by huangguangbao on 2017/6/7.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBDeviceInfoTool.h"
#import "HGBUniqueIDTool.h"
#import "HGBIPTool.h"
#import "HGBCPUTool.h"
#import "HGBMemoryTool.h"
#import "HGBDiskTool.h"
#import "HGBDeviceDataTool.h"



#import <UIKit/UIKit.h>
#import <sys/utsname.h>
// 下面是获取mac地址需要导入的头文件
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>

#import <sys/sockio.h>
#import <sys/ioctl.h>

#include <mach/mach.h> // 获取CPU信息所需要引入的头文件

@implementation HGBDeviceInfoTool
#pragma mark 获取手机唯一标识
/**
 *  获取手机序列号
 *
 *  @return 获取的手机序列号
 */
+ (NSString *)getUniqueIdentifier{
    return [HGBUniqueIDTool getUniqueIdentifier];
}


/**
 获取UUID

 @return UUID-Keychain版
 */
+(NSString *)getKeychainUUID{
    return [HGBUniqueIDTool getKeychainUUIDCode];
}
/**
 获取UUID-Defaults版

 @return UUID
 */
+(NSString *)getDefaultsUUID{
    return [HGBUniqueIDTool getDefaultsUUIDCode];
}

- (NSString *)getIDFA {
    return [HGBUniqueIDTool getAdvertisingIdentifier];
}
#pragma mark 获取ip
/**
 获取IP地址

 @return IP地址
 */
+(NSString *)getIPAddress{
    return [HGBIPTool getIPAddress];
}
/**
 *  获取IP地址
 *
 *  @return 返回IP地址
 */
+ (NSString *)getIPAddressWithIpType:(NSString *)type{
    return [HGBIPTool getIPAddressWithIpType:type];

}
/**
 获取所有的IP

 @return IP字典
 */
+ (NSDictionary *)getAllIPAddresses{
    return  [HGBIPTool getAllIPAddresses];
}
/**
 获取mac地址

 @return mac地址
 */
+ (NSString *)getMacAddress{
    return [HGBIPTool getMacAddress];
}
#pragma mark 获取手机设备信息
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
/**
 是否可以打电话

 @return 是否可以打电话
 */
+ (BOOL)canMakePhoneCall {
    return [HGBDeviceDataTool canMakePhoneCall];
}
#endif
/**
 *  获取手机别名
 *
 *  @return 获取手机别名
 */
+ (NSString *)getUserPhoneName{
    NSString* userPhoneName = [[UIDevice currentDevice] name];;
    return userPhoneName;
}
/**
 *  获取系统名称
 *
 *  @return 获取系统名称
 */
+ (NSString *)getSystemName{
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    return deviceName;
}

/**
 *  获取手机系统版本
 *
 *  @return 手机系统版本
 */
+ (NSString *)getPhoneVersion{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    return phoneVersion;
}


/**
 *  获取手机基本类型
 *
 *  @return 手机基本类型
 */
+ (NSString *)getLocalPhoneModel{
    //手机型号
    return [HGBDeviceDataTool getLocalPhoneModel];
}
/**
 *  获取手机型号
 *
 *  @return 手机型号
 */
+ (NSString *)getPhoneModel{
    //手机型号
    return [HGBDeviceDataTool getPhoneModel];
}


/**
 获取设备型号
 
 @return 设备型号
 */
+ (NSString *)getDeviceModelName {
    return [HGBDeviceDataTool getDeviceModelName];
}
#pragma mark 设备信息2
/**
 获取设备上次重启的时间

 @return 设备上次重启的时间
 */
+(NSDate *)getSystemUptime{
    return [HGBDeviceDataTool getSystemUptime];
}

/**
 获取总线程频率

 @return 总线程频率
 */
+ (NSUInteger)getBusFrequency{
    return [HGBDeviceDataTool getBusFrequency];
}
/**
 获取CPU线程频率

 @return CPU线程频率
 */
+ (NSUInteger)getCPUFrequency{
    return [HGBDeviceDataTool getCPUFrequency];
}

/**
 获取当前设备主存

 @return 当前设备主存
 */
+ (NSUInteger)getRamSize{
     return [HGBDeviceDataTool getRamSize];
}
#pragma mark CPU
/**
 获取CPU处理器

 @return CPU处理器
 */
+(NSString *)getCPUProcessor{
    return [HGBCPUTool getCPUProcessor];
}
/**  */
/**
 获取CPU数量

 @return CPU数量
 */
+ (NSUInteger)getCPUCount{
    return [HGBCPUTool getCPUCount];
}

/**
 获取CPU总的使用百分比

 @return CPU总的使用百分比
 */
+(float)getCPUUsage{
    return [HGBCPUTool getCPUUsage];
}

/**
 获取单个CPU使用百分比

 @return  单个CPU使用百分比
 */
+ (NSArray *)getPerCPUUsage{
    return [HGBCPUTool getPerCPUUsage];
}
#pragma mark - Disk
/**
 获取本 App 所占磁盘空间

 @return App 所占磁盘空间
 */
+(NSString *)getApplicationSize {
    return [HGBDiskTool getApplicationSize];
}
/**
 获取磁盘总空间

 @return 磁盘总空间
 */
+ (int64_t)getTotalDiskSpace {
   return [HGBDiskTool getTotalDiskSpace];
}
/**
 获取未使用的磁盘空间

 @return 未使用的磁盘空间
 */
+ (int64_t)getFreeDiskSpace {
   return [HGBDiskTool getFreeDiskSpace];
}
/**
 获取已使用的磁盘空间

 @return 已使用的磁盘空间
 */
+ (int64_t)getUsedDiskSpace {
    return [HGBDiskTool getUsedDiskSpace];
}
#pragma mark Memory

/**
 获取总内存空间

 @return 总内存空间
 */
+ (int64_t)getTotalMemory {

    return [HGBMemoryTool getTotalMemory];
}
/**
 获取活跃的内存空间

 @return 活跃的内存空间
 */
+ (int64_t)getActiveMemory {
   return [HGBMemoryTool getActiveMemory];
}
/**
 获取不活跃的内存空间

 @return 不活跃的内存空间
 */
+ (int64_t)getInActiveMemory {
    return [HGBMemoryTool getInActiveMemory];
}
/**
 获取空闲的内存空间

 @return 空闲的内存空间
 */
+(int64_t)getFreeMemory {
    return [HGBMemoryTool getFreeMemory];
}
/**
 获取正在使用的内存空间

 @return 正在使用的内存空间
 */
+ (int64_t)getUsedMemory {
     return [HGBMemoryTool getUsedMemory];
}
/**
 获取存放内核的内存空间

 @return 存放内核的内存空间
 */
+ (int64_t)getWiredMemory {
    return [HGBMemoryTool getWiredMemory];
}
/**
 获取可释放的内存空间

 @return 可释放的内存空间
 */
+ (int64_t)getPurgableMemory {
   return [HGBMemoryTool getPurgableMemory];
}

@end
