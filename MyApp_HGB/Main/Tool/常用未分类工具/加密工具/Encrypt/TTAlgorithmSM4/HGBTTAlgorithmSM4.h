//
//  HGBTTAlgorithmSM4.h
//  测试app
//
//  Created by huangguangbao on 2017/7/6.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TTSM4Type)
{
    TTSM4TypeCBC = 0,
    TTSM4TypeECB
};

@interface HGBTTAlgorithmSM4 : NSObject

/**
 *  @author TTwong, 16-03-29 14:03:19
 *
 *  使用密钥和初始化向量生成CBC模式的SM4加解密对象
 *
 *  @param secretKey 密钥
 *  @param iv        初始化向量
 *
 *  @return SM4加解密对象
 */
+ (nullable instancetype)cbcSM4WithKey:(nonnull NSString *)secretKey iv:(nonnull NSString *)iv;

/**
 *  @author TTwong, 16-03-29 15:03:07
 *
 *  使用密钥生成ECB模式的SM4加解密对象
 *
 *  @param secretKey 密钥
 *
 *  @return SM4加解密对象
 */
+ (nullable instancetype)ecbSM4WithKey:(nonnull NSString *)secretKey;

/**
 *  @author TTwong, 16-03-29 15:03:20
 *
 *  加密字符串
 *
 *  @param encryptionText 需要加密的字符串，即明文
 *
 *  @return 加密后的字符串，即密文
 */
- (nullable NSString *)encryption:(nonnull NSString *)encryptionText;

/**
 *  @author TTwong, 16-03-29 15:03:22
 *
 *  解密字符串
 *
 *  @param decryptionText 待解密的字符串，即密文
 *
 *  @return 解密后的字符串，即明文
 */
- (nullable NSString *)decryption:(nonnull NSString *)decryptionText;



@end
