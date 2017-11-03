//
//  HGBDeviceDataTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/31.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 设备基础类型
 */
typedef enum HGBDeviceBasicType
{
    HGBDeviceBasicTypeiPhone,//iPhone
    HGBDeviceBasicTypeiPad,//iPad
    HGBDeviceBasicTypeSmulitor,//Smulitor
    HGBDeviceBasicTypeOther,//TV等其他

}HGBDeviceBasicType;

@interface HGBDeviceDataTool : NSObject
#pragma mark 基本信息
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
/**
 是否可以打电话

 @return 是否可以打电话
 */
+ (BOOL)canMakePhoneCall;
/**
 获取手机基本类型-iphone ipad或smulator

 @return 手机基本类型
 */
+(HGBDeviceBasicType )getPhoneType;
/**
 *  获取手机基本类型
 *
 *  @return 手机基本类型
 */
+ (NSString *)getLocalPhoneModel;
/**
 *  获取手机基本型号
 *
 *  @return 手机基本型号
 */
+ (NSString *)getPhoneModel;
/**
 获取设备型号

 @return 设备型号
 */
+ (NSString *)getDeviceModelName;
#endif
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
@end
