//
//  HGBCustomEncryptTool.h
//  VirtualCard
//
//  Created by huangguangbao on 2017/6/7.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 加密工具
 */
@interface HGBCustomEncryptTool : NSObject
#pragma mark 特殊字符编码
/**
 特殊字符编码
 
 @param string 字符串
 @return 编码后字符串
 */
+ (NSString *)specialStringEncodingWithString:(NSString *)string;

/**
 特殊字符解码
 
 @param string 字符串
 @return 编码后字符串
 */
+ (NSString *)specialStringDecodingWithString:(NSString *)string;
#pragma mark Base64-string
/**
 Base64编码-string
 
 @param string 字符串
 @return 编码后字符串
 */
+(NSString *)encryptStringWithBase64:(NSString *)string;

/**
 Base64解码-string
 
 @param string 字符串
 @return 解码后字符串
 */
+(NSString *)decryptStringWithBase64:(NSString *)string;
#pragma mark Base64-DataToSting
/**
 Base64编码-DataToSting
 @param data 数据
 @return 编码后字符串
 */
+(NSString *)encryptDataToStringWithBase64:(NSData *)data;

/**
 Base64解码-DataToSting
 
 @param string 字符串
 @return 解码后字符串
 */
+(NSData *)decryptStringToDataWithBase64:(NSString *)string;

#pragma mark Base64-data
/**
 Base64编码-data
 @param data 数据
 @return 编码后字符串
 */
+(NSData *)encryptDataWithBase64:(NSData *)data;

/**
 Base64解码-data
 
 @param data 数据
 @return 解码后字符串
 */
+(NSData *)decryptDataWithBase64:(NSData *)data;

#pragma mark RSA-file 公钥加密 私钥解密
/**
 RSA加密－不编码
 
 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithFileRSA:(NSString *)string;

/**
 RSA加密－编码
 
 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithFileRSAEncoding:(NSString *)string;
/**
 RSA解密
 
 @param string 字符串
 @return 解密后字符串
 */
+(NSString *)decryptStringWithFileRSA:(NSString *)string;
#pragma mark RSA-file 私钥加密 公钥解密
/**
 RSA加密－不编码

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithFileReverseRSA:(NSString *)string;

/**
 RSA加密－编码

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithFileReverseRSAEncoding:(NSString *)string;
/**
 RSA解密

 @param string 字符串
 @return 解密后字符串
 */
+(NSString *)decryptStringWithFileReverseRSA:(NSString *)string;
#pragma mark RSA-key 公钥加密 私钥解密
/**
 RSA加密－编码
 
 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithKeyRSAEncoding:(NSString *)string;

/**
 RSA加密－不编码
 
 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithKeyRSA:(NSString *)string;
/**
 RSA解密
 
 @param string 字符串
 @return 解密后字符串
 */
+(NSString *)decryptStringWithKeyRSA:(NSString *)string;
#pragma mark RSA-key 私钥加密 公钥解密
/**
 RSA加密－编码

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithKeyReverseRSAEncoding:(NSString *)string;

/**
 RSA加密－不编码

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithKeyReverseRSA:(NSString *)string;
/**
 RSA解密

 @param string 字符串
 @return 解密后字符串
 */
+(NSString *)decryptStringWithKeyReverseRSA:(NSString *)string;
#pragma mark DES3
/**
 DES3加密
 
 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithDES3:(NSString *)string;
/**
 DES3解密
 
 @param string 字符串
 @return 解密后字符串
 */
+(NSString *)decryptStringWithDES3:(NSString *)string;
#pragma mark AES256-string
/**
 AES256加密
 
 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithAES256:(NSString *)string;
/**
 AES256解密
 
 @param string 字符串
 @return 解密后字符串
 */
+(NSString *)decryptStringWithAES256:(NSString *)string;

#pragma mark AES256-data
/**
 AES256加密
 
 @param data 数据
 @return 加密后数据
 */
+(NSData *)encryptDataWithAES256:(NSData *)data;
/**
 AES256解密
 
 @param data 数据
 @return 解密后数据
 */
+(NSData *)decryptDataWithAES256:(NSData *)data;
#pragma mark  MD5-32
/**
 MD5加密-32小写
 
 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithMD5_32LOW:(NSString *)string;
/**
 MD5加密-32大写
 
 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithMD5_32UP:(NSString *)string;

#pragma mark  MD5-16
/**
 MD5加密-16小写
 
 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithMD5_16LOW:(NSString *)string;
/**
 MD5加密-16大写
 
 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithMD5_16UP:(NSString *)string;
#pragma mark sha1加密
/**
 *  sha1加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)encryptStringWithsha1:(NSString*)string;

#pragma mark 哈希字符串拼接
/**
 哈希字符串拼接

 @param object 对象
 @return hash字符串
 */
+(NSString *)hashStringFromJsonObject:(id )object andWithSalt:(NSString *)salt;

#pragma mark 国密算法-CBC

/**
 *  TTAlgorithmSM4-CBC加密
 *
 *  @param string 要保存的value值
 */
+ (NSString *)encryptStringWithTTAlgorithmSM4_CBC:(NSString *)string;
/**
 *  TTAlgorithmSM4-CBC解密
 *
 *  @return 获取的对象
 */

+(NSString *)decryptStringWithTTAlgorithmSM4_CBC:(NSString *)string;
#pragma mark 国密算法-ECB

/**
 *  TTAlgorithmSM4-ECB加密
 *
 *  @param string 要保存的value值
 */
+ (NSString *)encryptStringWithTTAlgorithmSM4_ECB:(NSString *)string;
/**
 *  TTAlgorithmSM4-ECB解密
 *
 *  @return 获取的对象
 */

+(NSString *)decryptStringWithTTAlgorithmSM4_ECB:(NSString *)string;
@end
