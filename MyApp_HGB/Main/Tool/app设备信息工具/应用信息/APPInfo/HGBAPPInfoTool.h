//
//  HGBAPPInfoTool.h
//  设备相关信息
//
//  Created by huangguangbao on 2017/6/7.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HGBAPPInfoTool : NSObject

/**
 获取app版本号
 
 @return app版本号
 */
+(NSString*) getLocalAppVersion;
/**
 获取build版本号
 
 @return app版本号
 */
+(NSString*) getLocalAppBuildVersion;

/**
 获取BundleID
 
 @return BundleID
 */
+(NSString*) getBundleID;

/**
 获取app的名字
 
 @return app的名字
 */
+(NSString*) getAppName;

/**
 获取app图标

 @return app图标
 */
+(UIImage *)getAppImage;

/**
 获取app启动页图片
 
 @return 启动页图片
 */
+(UIImage *)getLanuchImage;

/**
 获取app的infoPlist内容
 
 @return 内容
 */
+(NSDictionary *)getInfoPlist;
@end
