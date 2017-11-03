//
//  HGBMD5Encryption.m
//  测试
//
//  Created by huangguangbao on 2017/9/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBMD5Encryption.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HGBMD5Encryption
#pragma mark 特殊
/**
 *  MD5加密, 32位 小写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForLower32Bate:(NSString *)string{

    //要进行UTF8的转码
    const char* input = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }

    return digest;
}


/**
 *  MD5加密, 32位 大写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForUpper32Bate:(NSString *)string{

    //要进行UTF8的转码
    const char* input = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }

    return digest;
}

/**
 *  MD5加密, 16位 小写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForUpper16Bate:(NSString *)string{

    NSString *md5Str = [HGBMD5Encryption MD5ForUpper32Bate:string];

    NSString  *string2;
    for (int i=0; i<24; i++) {
        string2=[md5Str substringWithRange:NSMakeRange(0, 16)];
    }
    return string2;
}


/**
 *  MD5加密, 16位 大写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForLower16Bate:(NSString *)string{

    NSString *md5Str = [HGBMD5Encryption MD5ForLower32Bate:string];

    NSString  *string2;
    for (int i=0; i<24; i++) {
        string2=[md5Str substringWithRange:NSMakeRange(0, 16)];
    }
    return string2;
}
#pragma mark 通用
/**
 *  MD5加密, 小写
 *
 *  @param string 传入要加密的字符串
 *  @param bate 位数
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForLower:(NSString *)string andWithBate:(NSInteger)bate{
    NSInteger bates=bate/2+bate%2;
    //要进行UTF8的转码
    const char* input = [string UTF8String];
    unsigned char result[bates];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:bate];
    for (NSInteger i = 0; i < bates; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }

    return digest;
}

/**
 *  MD5加密,  大写
 *
 *  @param string 传入要加密的字符串
 *  @param bate 位数
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForUpper:(NSString *)string andWithBate:(NSInteger)bate{
    NSInteger bates=bate/2+bate%2;
    //要进行UTF8的转码
    const char* input = [string UTF8String];
    unsigned char result[bates];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:bate];
    for (NSInteger i = 0; i < bates; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }

    return digest;
}
@end
