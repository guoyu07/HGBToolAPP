//
//  HGBSHAEncryption.h
//  测试
//
//  Created by huangguangbao on 2017/9/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBSHAEncryption : NSObject
#pragma mark sha1加密
/**
 *  sha1加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha1UpperEncryptString:(NSString*)string;
/**
 *  sha1加密-小写
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha1LowerEncryptString:(NSString*)string;
#pragma mark sha224加密
/**
 *  sha224加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha224UpperEncryptString:(NSString*)string;
/**
 *  sha224加密-小写
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha224LowerEncryptString:(NSString*)string;
#pragma mark sha256加密
/**
 *  sha256加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha256UpperEncryptString:(NSString*)string;
/**
 *  sha256加密-小写
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha256LowerEncryptString:(NSString*)string;
#pragma mark sha384加密
/**
 *  sha384加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha384UpperEncryptString:(NSString*)string;
/**
 *  sha384加密-小写
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha384LowerEncryptString:(NSString*)string;
#pragma mark sha512加密
/**
 *  sha512加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha512UpperEncryptString:(NSString*)string;
/**
 *  sha512加密-小写
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha512LowerEncryptString:(NSString*)string;
@end
