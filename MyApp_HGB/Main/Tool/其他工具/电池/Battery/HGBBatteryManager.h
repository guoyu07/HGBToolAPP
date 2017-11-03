//
//  HGBBatteryManager.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/31.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HGBBatteryManager;
@protocol HGBBatteryManagerDelegate

- (void)batteryStatusDidUpdated:(HGBBatteryManager*)battery ;
@end

@interface HGBBatteryManager : NSObject
@property (nonatomic, weak) id<HGBBatteryManagerDelegate> delegate;

/**
 电池容量
 */
@property (nonatomic, assign) NSUInteger capacity;
/**
 电压
 */
@property (nonatomic, assign) CGFloat voltage;

/**
 剩余电量百分比
 */
@property (nonatomic, assign) NSUInteger levelPercent;
/**
 剩余电量
 */
@property (nonatomic, assign) NSUInteger levelMAH;
/**
 电池状态
 */
@property (nonatomic, copy)   NSString *status;

/**
 单例

 @return 实例
 */
+ (instancetype)sharedManager;

/**
 开始监测电池电量
 */
- (void)startBatteryMonitoring;

/**
 停止监测电池电量
 */
- (void)stopBatteryMonitoring;
@end
