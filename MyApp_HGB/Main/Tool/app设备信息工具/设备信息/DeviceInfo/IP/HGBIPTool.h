//
//  HGBIPTool.h
//  获取IP地址
//
//  Created by huangguangbao on 2017/6/7.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBIPTool : NSObject
#pragma mark 获取IP地址
/**
 *  获取IP地址
 *
 *  @return 返回IP地址
 */
+ (NSString *)getIPAddress;
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
#pragma mark 获取mac地址

/**
 *  获取mac地址
 *
 *  @return mac地址  为了保护用户隐私，每次都不一样，苹果官方哄小孩玩的
 */
+(NSString *)getMacAddress;
@end
