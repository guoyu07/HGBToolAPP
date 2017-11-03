//
//  HGBDESEncryption.h
//  测试
//
//  Created by huangguangbao on 2017/9/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBDESEncryption : NSObject
#pragma mark 加密
/**
 加密方法

 @param string 原始字符串
 @param key key
 @return 加密字符串
 */
+ (NSString*)DESEncryptString:(NSString*)string WithKey:(NSString *)key;


/**
 解密方法

 @param string  加密字符串
 @param key key
 @return 解密字符串
 */
+ (NSString*)DESDecryptString:(NSString*)string WithKey:(NSString *)key;
#pragma mark 设置
/**
 设置秘钥

 @param key 秘钥
 */
+(void)setKey:(NSString *)key;
/**
 设置加密向量

 @param iv 加密向量
 */
+(void)setIv:(NSString *)iv;
@end
