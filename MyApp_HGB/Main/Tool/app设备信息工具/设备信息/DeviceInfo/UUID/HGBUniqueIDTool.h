//
//  HGBUniqueIDTool.h
//  获取唯一标识
//
//  Created by huangguangbao on 2017/6/7.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBUniqueIDTool : NSObject
#pragma mark 获取手机唯一标识
/**
 *  获取手机序列号
 *
 *  @return 获取的手机序列号
 */
+ (NSString *)getUniqueIdentifier;
#pragma mark 获取UUID
/**
 *  获取UUID-Keychain版
 *
 *  @return 获取的UUID的值
 */
+(NSString *)getKeychainUUIDCode;
/**
 *  获取UUID-Defaults版
 *
 *  @return 获取的UUID的值
 */
+(NSString *)getDefaultsUUIDCode;
#pragma mark 获取广告标识
/**
 获取广告标识
 
 @return AdvertisingIdentifier
 */
+(NSString *)getAdvertisingIdentifier;
@end
