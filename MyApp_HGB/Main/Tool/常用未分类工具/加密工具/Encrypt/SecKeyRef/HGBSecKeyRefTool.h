//
//  HGBSecKeyRefTool.h
//  测试
//
//  Created by huangguangbao on 2017/9/11.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/SecBase.h>

//密钥生成类型
typedef enum : NSUInteger {
    HGBEncryptKeyTypeRSA,//RSA密钥
    HGBEncryptKeyTypeDSA,//DSA密钥
    HGBEncryptKeyTypeAES,//AES密钥
    HGBEncryptKeyTypeDES,//DES密钥
    HGBEncryptKeyType3DES,//3DES密钥
    HGBEncryptKeyTypeRC2,//RC2密钥
    HGBEncryptKeyTypeRC4//RC4密钥
}HGBEncryptKeyType;



/**
 从文件中载入公钥和密钥，把密钥以文件形式放在手机里是不安全的；视业务场景定吧
 */
@interface HGBSecKeyRefTool : NSObject
#pragma mark 加密密钥生成-公钥私钥
/**
 加密密钥生成

 @param keySize 密钥大小
 @param reslut 结果
 */
+(void)generateEncryptKeyWithKeySize:(NSInteger)keySize andWithReslut:(void(^)(SecKeyRef publicKey,SecKeyRef privateKey,NSString *stringPublicKey,NSString *stringprivateKey))reslut;

#pragma mark 从cer  p12文件中读取公钥匙钥

/**
 从x509 cer证书中读取公钥

 @param cerFilePath der证书路径
 @return 密钥
 */
+ (SecKeyRef )publicKeyFromCerFile:(NSString *)cerFilePath;

/**
 从 p12 文件中读取私钥，一般p12都有密码

 @param p12FilePath p12文件路径
 @param password 密码
 @return 密钥
 */
+ (SecKeyRef )privateKeyFromP12File:(NSString *)p12FilePath password:(NSString *)password;

#pragma mark 从pem文件中读取公钥匙钥
/**
 iOS 10 上可用如下接口SecKeyCreateWithData 从pem文件中读取私钥或公钥
 */
/**
 从pem文件中读取公钥

 @param pemFilePath pem文件路径
 @param keySize 密钥大小
 @return 密钥
 */
+ (SecKeyRef )publicKeyFromPemFile:(NSString *)pemFilePath keySize:(size_t )keySize;

/**
 从pem文件中读取私钥
 @param pemFilePath pem文件路径
 @param keySize 密钥大小
 @return 密钥
 */
+ (SecKeyRef )privaKeyFromPemFile:(NSString *)pemFilePath keySize:(size_t )keySize;


@end
