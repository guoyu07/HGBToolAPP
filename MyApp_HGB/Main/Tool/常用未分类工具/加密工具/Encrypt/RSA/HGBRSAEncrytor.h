//
//  HGBRSAEncrytor.h
//  测试app
//
//  Created by huangguangbao on 2017/7/6.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 RSA加密
 */

@interface HGBRSAEncrytor : NSObject
/**
 是否使用字符串密钥 默认文件密钥
 */
@property(assign,nonatomic)BOOL useStringKey;

/**
 私钥密码
 */
@property(strong,nonatomic)NSString *privateKeyPassword;
#pragma mark 文件密钥
/**
 公钥路径
 */
@property(strong,nonatomic)NSString *publicKeyPath;
/**
 私钥路径
 */
@property(strong,nonatomic)NSString *privateKeyPath;
#pragma mark 字符串密钥

/*
 *公钥
 */
@property (nonatomic) NSString *publicKey;

/*
 *私钥
 */
@property (nonatomic) NSString *privateKey;

#pragma mark init
/**
 单例

 @return 实体
 */
+(instancetype)shareInstance;
#pragma mark 加密解密方法
/**
 公钥加密

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)publicKeyEncryptString:(NSString *)string;

/**
 私钥解密

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)privateKeyDecryptStringString:(NSString *)string;
/**
 私钥加密

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)privateKeyEncryptString:(NSString *)string;

/**
 公钥解密

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)publicKeyDecryptStringString:(NSString *)string;

///**
// *  加密方法
// *
// *  @param str   需要加密的字符串
// *  @param path  '.der'格式的公钥文件路径
// */
//+ (NSString *)encryptString:(NSString *)str publicKeyWithContentsOfFile:(NSString *)path;
//
///**
// *  解密方法
// *
// *  @param str       需要解密的字符串
// *  @param path      '.p12'格式的私钥文件路径
// *  @param password  私钥文件密码
// */
//+ (NSString *)decryptString:(NSString *)str privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password;

//#pragma mark 字符串密钥
//
///**
// *  加密方法
// *
// *  @param str    需要加密的字符串
// *  @param pubKey 公钥字符串
// */
//+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
//
///**
// *  解密方法
// *
// *  @param str     需要解密的字符串
// *  @param privKey 私钥字符串
// */
//+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
@end
