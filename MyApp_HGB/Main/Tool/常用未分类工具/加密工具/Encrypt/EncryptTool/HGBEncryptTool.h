//
//  HGBEncryptTool.h
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 加密工具
 */
@interface HGBEncryptTool : NSObject
#pragma mark 特殊字符
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
 @param filePath  '.der'格式的公钥文件路径
 @return 加密后字符串
 */
+(NSString *)encryptStringWithRSA:(NSString *)string andWithPublicKeyPath:(NSString *)filePath;

/**
 RSA加密－编码
 
 @param string 字符串
 @param filePath  '.der'格式的公钥文件路径
 @return 加密后字符串
 */
+(NSString *)encryptStringWithRSAEncoding:(NSString *)string andWithPublicKeyPath:(NSString *)filePath;


/**
 RSA解密
 
 @param string 字符串
 @param filePath      '.p12'格式的私钥文件路径
 @param pass      私钥密码
 @return 解密后字符串
 */
+(NSString *)decryptStringWithRSA:(NSString *)string andWithPrivateKeyPath:(NSString *)filePath andWithPassWord:(NSString *)pass;

#pragma mark RSA-file 私钥加密 公钥解密
/**
 RSA加密－不编码

 @param string 字符串
 @param filePath      '.p12'格式的私钥文件路径
 @param pass      私钥密码
 @return 加密后字符串
 */
+(NSString *)encryptStringWithReverseRSA:(NSString *)string andWithPrivateKeyPath:(NSString *)filePath andWithPassWord:(NSString *)pass;

/**
 RSA加密－编码

 @param string 字符串
 @param filePath      '.p12'格式的私钥文件路径
 @param pass      私钥密码
 @return 加密后字符串
 */
+(NSString *)encryptStringWithReverseRSAEncoding:(NSString *)string andWithPrivateKeyPath:(NSString *)filePath andWithPassWord:(NSString *)pass;


/**
 RSA解密

 @param string 字符串
 @param filePath  '.der'格式的公钥文件路径
 @return 解密后字符串
 */
+(NSString *)decryptStringWithReverseRSA:(NSString *)string andWithPublicKeyPath:(NSString *)filePath;

//

#pragma mark RSA-key 公钥加密 私钥解密
/**
 RSA加密－编码
 
 @param string 字符串
 @param pulickey  公钥
 @return 加密后字符串
 */
+(NSString *)encryptStringWithRSAEncoding:(NSString *)string andWithPulicKey:(NSString *)pulickey;

/**
 RSA加密－不编码
 
 @param string 字符串
 @param pulickey  公钥
 @return 加密后字符串
 */
+(NSString *)encryptStringWithRSA:(NSString *)string andWithPulicKey:(NSString *)pulickey;
/**
 RSA解密
 
 @param string 字符串
 @param privateKey  私钥
 @return 解密后字符串
 */
+(NSString *)decryptStringWithRSA:(NSString *)string andWithPrivateKey:(NSString *)privateKey;

#pragma mark RSA-key 私钥加密 公钥解密
/**
 RSA加密－编码

 @param string 字符串
 @param privateKey  私钥
 @return 加密后字符串
 */
+(NSString *)encryptStringWithReverseRSAEncoding:(NSString *)string andWithPrivateKey:(NSString *)privateKey;

/**
 RSA加密－不编码

 @param string 字符串
 @param privateKey  私钥
 @return 加密后字符串
 */
+(NSString *)encryptStringWithReverseRSA:(NSString *)string andWithPrivateKey:(NSString *)privateKey;
/**
 RSA解密

 @param string 字符串
 @param pulickey  公钥
 @return 解密后字符串
 */
+(NSString *)decryptStringWithReverseRSA:(NSString *)string andWithPulicKey:(NSString *)pulickey;

#pragma mark DES3
/**
 DES3加密
 
 @param string 字符串
 @param key  加密密钥
 @return 加密后字符串
 */
+(NSString *)encryptStringWithDES3:(NSString *)string andWithKey:(NSString *)key;

/**
 DES解密
 
 @param string 字符串
 @param key  解密密钥
 @return 解密后字符串
 */
+(NSString *)decryptStringWithDES3:(NSString *)string andWithKey:(NSString *)key;


#pragma mark AES256-string
/**
 AES256加密
 
 @param string 字符串
 @param key  加密密钥
 @return 加密后字符串
 */
+(NSString *)encryptStringWithAES256:(NSString *)string andWithKey:(NSString *)key;
/**
 AES256解密
 
 @param string 字符串
 @param key  解密密钥
 @return 解密后字符串
 */
+(NSString *)decryptStringWithAES256:(NSString *)string
 andWithKey:(NSString *)key;


#pragma mark AES256-data
/**
 AES256加密
 
 @param data 数据
 @param key  加密密钥
 @return 加密后数据
 */
+(NSData *)encryptDataWithAES256:(NSData *)data andWithKey:(NSString *)key;

/**
 AES256解密
 
 @param data 数据
 @param key  解密密钥
 @return 解密后数据
 */
+(NSData *)decryptDataWithAES256:(NSData *)data andWithKey:(NSString *)key;


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
 @param salt salt
 @return hash字符串
 */
+(NSString *)hashStringFromJsonObject:(id )object andWithSalt:(NSString *)salt;

#pragma mark SM4国密算法-CBC

/**
 *  TTAlgorithmSM4-CBC加密
 *
 *  @param key   要存的对象的key值-16位
 *  @param string 要保存的value值
 *  @param iv 初始化向量-16位
 *  @return 获取的对象
 */
+ (NSString *)encryptStringWithTTAlgorithmSM4_CBC:(NSString *)string andWithKey:(NSString *)key andWithIV:(NSString *)iv;
/**
 *  TTAlgorithmSM4-CBC解密
 *
 *  @param key 对象的key值-16位
 *  @param string 初始化向量-16位
 *  @param iv 初始化向量
 *  @return 获取的对象
 */

+(NSString *)decryptStringWithTTAlgorithmSM4_CBC:(NSString *)string andWithKey:(NSString *)key andWithIV:(NSString *)iv;
#pragma mark SM4国密算法-ECB
/**
 *  TTAlgorithmSM4-ECB加密
 *
 *  @param key   要存的对象的key值-16位
 *  @param string 要保存的value值
 *  @return 获取的对象
 */
+ (NSString *)encryptStringWithTTAlgorithmSM4_ECB:(NSString *)string andWithKey:(NSString *)key;
/**
 *  TTAlgorithmSM4-ECB解密
 *
 *  @param key 对象的key值-16位
 *  @param string 初始化向量
 *  @return 获取的对象
 */

+(NSString *)decryptStringWithTTAlgorithmSM4_ECB:(NSString *)string andWithKey:(NSString *)key;


@end
