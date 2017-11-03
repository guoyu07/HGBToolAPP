//
//  HGBHashEncryption.h
//  测试
//
//  Created by huangguangbao on 2017/9/11.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
     //md5 16字节长度小写
    HGBHashEncryptType_MD5_16Lower=1000,
    //md5 16字节长度大写
    HGBHashEncryptType_MD5_16Upper,
    //md5 32字节长度小写
    HGBHashEncryptType_MD5_32Lower,
    //md5 32字节长度大写
    HGBHashEncryptType_MD5_32Upper,
    //md2 16字节长度小写
    HGBHashEncryptType_MD2_16Lower,
    //md2 16字节长度大写
    HGBHashEncryptType_MD2_16Upper,
    //md2 32字节长度小写
    HGBHashEncryptType_MD2_32Lower,
    //md2 32字节长度大写
    HGBHashEncryptType_MD2_32Upper,
    //md4 16字节长度小写
    HGBHashEncryptType_MD4_16Lower,
    //md4 16字节长度大写
    HGBHashEncryptType_MD4_16Upper,
    //md4 32字节长度小写
    HGBHashEncryptType_MD4_32Lower,
    //md4 32字节长度大写
    HGBHashEncryptType_MD4_32Upper,
    //sha1 20字节长度 小写
    HGBHashEncryptType_SHA1_Lower,
    //sha1 20字节长度  大写
    HGBHashEncryptType_SHA1_Upper,
    //SHA224 28字节长度 小写
    HGBHashEncryptType_SHA224_Lower,
    //SHA224 28字节长度 大写
    HGBHashEncryptType_SHA224_Upper,
    //SHA256 32字节长度 小写
    HGBHashEncryptType_SHA256_Lower,
    //SHA256 32字节长度 大写
    HGBHashEncryptType_SHA256_Upper,
    //SHA384 48字节长度 小写
    HGBHashEncryptType_SHA384_Lower,
    //SHA384 48字节长度 大写
    HGBHashEncryptType_SHA384_Upper,
    //SHA512 64字节长度 小写
    HGBHashEncryptType_SHA512_Lower,
    //SHA512 64字节长度 大写
    HGBHashEncryptType_SHA512_Upper
} HGBHashEncryptType;


/**
 hash字符串 默认MD5加密方式
 */
@interface HGBHashEncryption : NSObject

/**
 hash字符串

 @param jsonObject json对象-数组或字典
 @param salt salt字符串为空时不添加
 @return hash字符串
 */
+(NSString *)hashStringFromJsonObject:(id)jsonObject andWithSalt:(NSString *)salt;


#pragma mark 设置

/**
 设置hash字符串加密方式 默认MD5加密方式

 @param type 加密方式
 */
+(void)setHashEncrypType:(HGBHashEncryptType)type;

@end
