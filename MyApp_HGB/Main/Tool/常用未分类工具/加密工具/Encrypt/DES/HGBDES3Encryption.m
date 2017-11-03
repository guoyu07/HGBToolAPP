//
//  HGBDES3Encryption.m
//  测试
//
//  Created by huangguangbao on 2017/9/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBDES3Encryption.h"
#import <CommonCrypto/CommonCryptor.h>
#import "HGBBase64.h"

@interface HGBDES3Encryption()
@property(strong,nonatomic)NSString *key;
@property(strong,nonatomic)NSString *iv;
@end
@implementation HGBDES3Encryption
#pragma mark 初始化
static HGBDES3Encryption *instance=nil;
/**
 单例

 @return 实例
 */
+ (instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBDES3Encryption alloc]init];
    }
    return instance;
}
#pragma mark 设置
/**
 设置秘钥

 @param key 秘钥
 */
+(void)setKey:(NSString *)key{
    [HGBDES3Encryption shareInstance];
    instance.key=key;
}
/**
 设置加密向量

 @param iv 加密向量
 */
+(void)setIv:(NSString *)iv{
    [HGBDES3Encryption shareInstance];
    instance.iv=iv;

}
#pragma mark 加密方法
/**
 加密方法

 @param string 原始字符串
 @param key key
 @return 加密字符串
 */
+ (NSString*)DES3EncryptString:(NSString*)string WithKey:(NSString *)key{
    [HGBDES3Encryption shareInstance];
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];

    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;

    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);

    const void *vkey = (const void *) [instance.key UTF8String];

    if(key&&key.length!=0){
        vkey=[key UTF8String];
    }
    const void *vinitVec = (const void *) [instance.iv UTF8String];

    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);

    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [HGBBase64 stringByEncodingData:myData];
    return result;
}


/**
 解密方法

 @param string  加密字符串
 @param key key
 @return 解密字符串
 */
+ (NSString*)DES3DecryptString:(NSString*)string WithKey:(NSString *)key{
    [HGBDES3Encryption shareInstance];
    NSData *encryptData = [HGBBase64 decodeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];

    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;

    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);

    const void *vkey = (const void *) [instance.key UTF8String];
    if(key&&key.length!=0){
        vkey=[key UTF8String];
    }
    const void *vinitVec = (const void *) [instance.iv UTF8String];

    ccStatus = CCCrypt(kCCDecrypt, kCCAlgorithm3DES,kCCOptionPKCS7Padding,
                       vkey,kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);

    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                     length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    return result;
}
#pragma mark get
-(NSString *)iv{
    if(_iv==nil){
        _iv=@"huangguangbao@lx100$#365#$";
    }
    return _iv;
}
-(NSString *)key{
    if(_key==nil){
        _key=@"01234567";
    }
    return _key;
}
@end

