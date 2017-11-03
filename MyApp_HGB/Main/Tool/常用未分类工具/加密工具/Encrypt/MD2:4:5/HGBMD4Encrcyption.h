//
//  HGBMD4Encrcyption.h
//  测试
//
//  Created by huangguangbao on 2017/9/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 MD4加密
 */
@interface HGBMD4Encrcyption : NSObject
#pragma mark 特殊
/**
 *  MD4加密, 32位 小写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD4ForLower32Bate:(NSString *)string;

/**
 *  MD4加密, 32位 大写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD4ForUpper32Bate:(NSString *)string;

/**
 *  MD4加密, 16位 小写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD4ForLower16Bate:(NSString *)string;

/**
 *  MD4加密, 16位 大写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD4ForUpper16Bate:(NSString *)string;
#pragma mark 通用
/**
 *  MD4加密, 小写
 *
 *  @param string 传入要加密的字符串
 *  @param bate 位数
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD4ForLower:(NSString *)string andWithBate:(NSInteger)bate;

/**
 *  MD4加密,  大写
 *
 *  @param string 传入要加密的字符串
 *  @param bate 位数
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD4ForUpper:(NSString *)string andWithBate:(NSInteger)bate;
@end
