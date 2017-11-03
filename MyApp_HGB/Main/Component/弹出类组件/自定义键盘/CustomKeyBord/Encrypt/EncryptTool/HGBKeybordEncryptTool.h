//
//  HGBKeybordEncryptTool.h
//  HelloCordova
//
//  Created by huangguangbao on 2017/8/9.
//
//

#import <Foundation/Foundation.h>
/**
 加密工具
 */
@interface HGBKeybordEncryptTool : NSObject
#pragma mark DES
/**
 DES加密

 @param string 字符串
 @param key  加密密钥
 @return 加密后字符串
 */
+(NSString *)encryptStringWithDES:(NSString *)string andWithKey:(NSString *)key;

/**
 DES解密

 @param string 字符串
 @param key  解密密钥
 @return 解密后字符串
 */
+(NSString *)decryptStringWithDES:(NSString *)string andWithKey:(NSString *)key;


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
#pragma mark 哈希字符串拼接
/**
 哈希字符串拼接

 @param dic 字典
 @return hash字符串
 */
+(NSString *)transDicToHashString:(NSDictionary *)dic andWithSalt:(NSString *)salt;

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
