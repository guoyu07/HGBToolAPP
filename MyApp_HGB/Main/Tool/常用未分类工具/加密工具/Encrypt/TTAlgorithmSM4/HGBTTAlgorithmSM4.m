//
//  HGBTTAlgorithmSM4.m
//  测试app
//
//  Created by huangguangbao on 2017/7/6.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBTTAlgorithmSM4.h"
#include "HGBSM4.h"
#include "HGBPading.h"

@interface HGBTTAlgorithmSM4 ()

//加密解密使用的密钥
@property (nonatomic, copy, nonnull) NSString *key;

//加密解密使用的初始化向量
@property (nonatomic, copy, nullable) NSString *iv;

//加密解密模式
@property (nonatomic, assign) TTSM4Type type;

//使用CBC模式时，用该初始化方法
- (nullable instancetype)initWithKey:(nonnull NSString *)secretKey iv:(nonnull NSString *)iv;

//使用ECB模式时，用该初始化方法
- (nullable instancetype)initWithKey:(nonnull NSString *)secretKey;

//使用CBC模式对字符串加密
- (nullable NSString *)encryptionTextWithSM4CBCMode:(nonnull NSString *)encryptionText;

//使用CBC模式对字符串解密
- (nullable NSString *)decryptionTextWithSM4CBCMode:(nonnull NSString *)decryptionText;

//使用ECB模式对字符串加密
- (nullable NSString *)encryptionTextWithSM4ECBMode:(nonnull NSString *)encryptionText;

//使用ECB模式对字符串解密
- (nullable NSString *)decryptionTextWithSM4ECBMode:(nonnull NSString *)decryptionText;

//在CBC模式下，利用给定的密钥，初始化向量，对字符串加密
- (nullable NSString *)encryptionWithSM4Key:(nonnull NSString *)secretKey iv:(nonnull NSString *)iv encryptionText:(nonnull NSString *)encryptiontext;

//在CBC模式下，利用给定的密钥，初始化向量，对字符串解密
- (nullable NSString *)decryptionWithSM4Key:(nonnull NSString *)secretKey iv:(nonnull NSString *)iv decryptionText:(nonnull NSString *)decryptiontext;

//在ECB模式下，利用给定的密钥对字符串加密
- (nullable NSString *)encryptionWithSM4Key:(nonnull NSString *)secretKey encryptionText:(nonnull NSString *)encryptiontext;

//在ECB模式下，利用给定的密钥对字符串解密
- (nullable NSString *)decryptionWithSM4Key:(nonnull NSString *)secretKey decryptionText:(nonnull NSString *)decryptiontext;

@end

@implementation HGBTTAlgorithmSM4

+ (nullable instancetype)cbcSM4WithKey:(nonnull NSString *)secretKey iv:(nonnull NSString *)iv
{
    HGBTTAlgorithmSM4 *cbcSM4 = [[HGBTTAlgorithmSM4 alloc]initWithKey:secretKey iv:iv];
    
    return cbcSM4;
}

+ (nullable instancetype)ecbSM4WithKey:(nonnull NSString *)secretKey
{
    HGBTTAlgorithmSM4 *ecbSM4 = [[HGBTTAlgorithmSM4 alloc]initWithKey:secretKey];
    
    return ecbSM4;
}

- (nullable instancetype)initWithKey:(NSString *)secretKey iv:(NSString *)iv
{
    if (self = [super init])
    {
        _key = secretKey;
        _iv = iv;
        _type = TTSM4TypeCBC;
    }
    
    return self;
}


- (nullable instancetype)initWithKey:(NSString *)secretKey
{
    if (self = [super init])
    {
        _key = secretKey;
        _type = TTSM4TypeECB;
    }
    return self;
}


- (NSString *)decryptionWithSM4Key:(NSString *)secretKey iv:(NSString *)iv decryptionText:(NSString *)decryptiontext
{
    if ([secretKey length] != 16 || [iv length] != 16 || decryptiontext == nil || [decryptiontext length] == 0)
    {
#ifdef DEBUG
        NSLog(@"CBC模式 decryptionWithSM4Key方法入参有问题");
#endif
        return nil;
    }
    
    NSData *keyData = [secretKey dataUsingEncoding:NSUTF8StringEncoding];
    const char *keyChar = [secretKey cStringUsingEncoding:NSUTF8StringEncoding];
    size_t keyLength = [keyData length];
    
    //base64解密
    NSData *msgData = [[NSData alloc]initWithBase64EncodedString:decryptiontext options:NSDataBase64DecodingIgnoreUnknownCharacters];
    size_t msgLength = [msgData length];
    
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    const char *ivChar = [iv cStringUsingEncoding:NSUTF8StringEncoding];
    size_t ivLength = [ivData length];
    
    unsigned char *pKey = (unsigned char*)malloc(sizeof(unsigned char) * (keyLength + 1));
    unsigned char *pfreeKey = pKey;
    memset(pKey, 0, keyLength + 1);
    unsigned char *pMsg = (unsigned char*)malloc(sizeof(unsigned char) * (msgLength + 1));
    memset(pMsg, 0, msgLength + 1);
    unsigned char *pfreeMsg = pMsg;
    unsigned char *pIv = (unsigned char*)malloc(sizeof(unsigned char) * (ivLength + 1));
    memset(pIv, 0, ivLength + 1);
    unsigned char *pfreeIv = pIv;
    unsigned char *output = (unsigned char*)malloc(sizeof(unsigned char) * (msgLength + 1));
    memset(output, 0, msgLength + 1);
    
    
    unsigned char *pKeyChar = (unsigned char *)keyChar;
    unsigned char *pIvChar = (unsigned char *)ivChar;
    unsigned char *currentKey = (unsigned char *)pKey;
    __block unsigned char *currentMsg = (unsigned char *)pMsg;
    unsigned char *currentIv = (unsigned char *)pIv;
    unsigned char *pOutput = output;
    
    while (*pKeyChar)
    {
        *currentKey = *pKeyChar;
        ++pKeyChar;
        ++currentKey;
    }
    pKeyChar = NULL;
    currentKey = NULL;
    
    [msgData enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        for (NSInteger i = 0; i < byteRange.length; i++)
        {
            *currentMsg = *((unsigned char*)bytes + i);
            ++currentMsg;
        }
    }];
    currentMsg = NULL;
    
    while (*pIvChar)
    {
        *currentIv = *pIvChar;
        ++pIvChar;
        ++currentIv;
    }
    pIvChar = NULL;
    currentIv = NULL;
    
    
    sm4_context ctx;
    hgbsm4_setkey_dec(&ctx, pKey);
    hgbsm4_crypt_cbc(&ctx,0,(int)msgLength,(unsigned char *)pIv,(unsigned char *)pMsg,(unsigned char *)pOutput);
    
    unsigned long stringLength = 0;
    hgbunpaddingForDecryption(&output, &stringLength);
    unsigned char *pfreeoutput = output;
    
    NSString *outString = [[NSString alloc]initWithBytes:output length:stringLength encoding:NSUTF8StringEncoding];
    
    free(pfreeKey);
    free(pfreeIv);
    free(pfreeMsg);
    free(pfreeoutput);
    pKey = NULL;
    pIv = NULL;
    pMsg = NULL;
    pOutput = NULL;
    output = NULL;
    pfreeKey = NULL;
    pfreeIv = NULL;
    pfreeMsg = NULL;
    pfreeoutput = NULL;
    
    return outString;
}


- (NSString *)encryptionWithSM4Key:(NSString *)secretKey iv:(NSString *)iv encryptionText:(NSString *)encryptiontext
{
    if ([secretKey length] != 16 || [iv length] != 16 || encryptiontext == nil || [encryptiontext length] == 0)
    {
#ifdef DEBUG
        NSLog(@"CBC模式 encryptionWithSM4Key方法入参有问题");
#endif
        return nil;
    }
    
    NSData *keyData = [secretKey dataUsingEncoding:NSUTF8StringEncoding];
    const char *keyChar = [secretKey cStringUsingEncoding:NSUTF8StringEncoding];
    size_t keyLength = [keyData length];
    
    NSData *msgData = [encryptiontext dataUsingEncoding:NSUTF8StringEncoding];
    const char *msgChar = [encryptiontext cStringUsingEncoding:NSUTF8StringEncoding];
    size_t msgLength = [msgData length];
    
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    const char *ivChar = [iv cStringUsingEncoding:NSUTF8StringEncoding];
    size_t ivLength = [ivData length];
    
    int paddingLength = 16 - (int)msgLength % 16 + (int)msgLength;
    
    unsigned char *pKey = (unsigned char*)malloc(sizeof(unsigned char) * (keyLength + 1));
    memset(pKey, 0, keyLength + 1);
    unsigned char *pfreeKey = pKey;
    unsigned char *pMsg = (unsigned char*)malloc(sizeof(unsigned char) * (msgLength + 1));
    memset(pMsg, 0, msgLength + 1);
    
    unsigned char *pIv = (unsigned char*)malloc(sizeof(unsigned char) * (ivLength + 1));
    memset(pIv, 0, ivLength + 1);
    unsigned char *pfreeIv = pIv;
    unsigned char *output = (unsigned char*)malloc(sizeof(unsigned char) * (paddingLength + 1));
    memset(output, 0, paddingLength + 1);
    unsigned char *pfreeoutput = output;
    
    unsigned char *pKeyChar = (unsigned char *)keyChar;
    unsigned char *pMsgChar = (unsigned char *)msgChar;
    unsigned char *pIvChar = (unsigned char *)ivChar;
    unsigned char *currentKey = (unsigned char *)pKey;
    unsigned char *currentMsg = (unsigned char *)pMsg;
    unsigned char *currentIv = (unsigned char *)pIv;
    unsigned char *pOutput = output;
    
    while (*pKeyChar)
    {
        *currentKey = *pKeyChar;
        ++pKeyChar;
        ++currentKey;
    }
    pKeyChar = NULL;
    currentKey = NULL;
    
    while (*pMsgChar)
    {
        *currentMsg = *pMsgChar;
        ++pMsgChar;
        ++currentMsg;
    }
    pMsgChar = NULL;
    currentMsg = NULL;
    
    while (*pIvChar)
    {
        *currentIv = *pIvChar;
        ++pIvChar;
        ++currentIv;
    }
    pIvChar = NULL;
    currentIv = NULL;
    
    hgbpaddingForEncryption(&pMsg, msgLength);
    unsigned char *pfreeMsg = pMsg;
    
    sm4_context ctx;
    hgbsm4_setkey_enc(&ctx, pKey);
    hgbsm4_crypt_cbc(&ctx,1,paddingLength,(unsigned char *)pIv,(unsigned char *)pMsg,(unsigned char *)output);
    
    //base64加密
    NSData *outdata = [NSData dataWithBytes:pOutput length:paddingLength];
    NSString *base64string = [outdata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    free(pfreeKey);
    free(pfreeIv);
    free(pfreeMsg);
    free(pfreeoutput);
    pKey = NULL;
    pIv = NULL;
    pMsg = NULL;
    pOutput = NULL;
    pfreeoutput = NULL;
    pfreeMsg = NULL;
    pfreeIv = NULL;
    pfreeKey = NULL;
    
    return base64string;
}


- (nullable NSString *)encryptionWithSM4Key:(nonnull NSString *)secretKey encryptionText:(nonnull NSString *)encryptiontext
{
    if ([secretKey length] != 16 || encryptiontext == nil || [encryptiontext length] == 0)
    {
#ifdef DEBUG
        NSLog(@"ECB模式 encryptionWithSM4Key方法入参有问题");
#endif
        return nil;
    }
    
    NSData *keyData = [secretKey dataUsingEncoding:NSUTF8StringEncoding];
    const char *keyChar = [secretKey cStringUsingEncoding:NSUTF8StringEncoding];
    size_t keyLength = [keyData length];
    
    NSData *msgData = [encryptiontext dataUsingEncoding:NSUTF8StringEncoding];
    const char *msgChar = [encryptiontext cStringUsingEncoding:NSUTF8StringEncoding];
    size_t msgLength = [msgData length];
    
    
    int paddingLength = 16 - (int)msgLength % 16 + (int)msgLength;
    
    unsigned char *pKey = (unsigned char*)malloc(sizeof(unsigned char) * (keyLength + 1));
    memset(pKey, 0, keyLength + 1);
    unsigned char *pfreeKey = pKey;
    
    unsigned char *pMsg = (unsigned char*)malloc(sizeof(unsigned char) * (msgLength + 1));
    memset(pMsg, 0, msgLength + 1);
    
    unsigned char *output = (unsigned char*)malloc(sizeof(unsigned char) * (paddingLength + 1));
    memset(output, 0, paddingLength + 1);
    unsigned char *pfreeoutput = output;
    
    unsigned char *pKeyChar = (unsigned char *)keyChar;
    unsigned char *pMsgChar = (unsigned char *)msgChar;
    unsigned char *currentKey = (unsigned char *)pKey;
    unsigned char *currentMsg = (unsigned char *)pMsg;
    unsigned char *pOutput = output;
    
    while (*pKeyChar)
    {
        *currentKey = *pKeyChar;
        ++pKeyChar;
        ++currentKey;
    }
    
    while (*pMsgChar)
    {
        *currentMsg = *pMsgChar;
        ++pMsgChar;
        ++currentMsg;
    }
    
    
    hgbpaddingForEncryption(&pMsg, msgLength);
    unsigned char *pfreeMsg = pMsg;
    
    sm4_context ctx;
    hgbsm4_setkey_enc(&ctx, pKey);
    hgbsm4_crypt_ecb(&ctx,1,paddingLength,(unsigned char *)pMsg,(unsigned char *)output);
    
    //base64加密
    NSData *outdata = [NSData dataWithBytes:pOutput length:paddingLength];
    NSString *base64string = [outdata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    free(pfreeKey);
    free(pfreeMsg);
    free(pfreeoutput);
    pKey = NULL;
    pMsg = NULL;
    pOutput = NULL;
    output = NULL;
    pfreeoutput = NULL;
    pfreeMsg = NULL;
    pfreeKey = NULL;
    
    return base64string;
}


- (nullable NSString *)decryptionWithSM4Key:(nonnull NSString *)secretKey decryptionText:(nonnull NSString *)decryptiontext
{
    if ([secretKey length] != 16 || decryptiontext == nil || [decryptiontext length] == 0)
    {
#ifdef DEBUG
        NSLog(@"ECB模式 decryptionWithSM4Key方法入参有问题");
#endif
        return nil;
    }
    
    NSData *keyData = [secretKey dataUsingEncoding:NSUTF8StringEncoding];
    const char *keyChar = [secretKey cStringUsingEncoding:NSUTF8StringEncoding];
    size_t keyLength = [keyData length];
    
    //base64解密
    NSData *msgData = [[NSData alloc]initWithBase64EncodedString:decryptiontext options:NSDataBase64DecodingIgnoreUnknownCharacters];
    size_t msgLength = [msgData length];
    
    
    unsigned char *pKey = (unsigned char*)malloc(sizeof(unsigned char) * (keyLength + 1));
    memset(pKey, 0, keyLength + 1);
    unsigned char *pfreeKey = pKey;
    
    unsigned char *pMsg = (unsigned char*)malloc(sizeof(unsigned char) * (msgLength + 1));
    memset(pMsg, 0, msgLength + 1);
    unsigned char *pfreeMsg = pMsg;
    
    unsigned char *output = (unsigned char*)malloc(sizeof(unsigned char) * (msgLength + 1));
    memset(output, 0, msgLength + 1);
    
    unsigned char *pKeyChar = (unsigned char *)keyChar;
    unsigned char *currentKey = (unsigned char *)pKey;
    __block unsigned char *currentMsg = (unsigned char *)pMsg;
    unsigned char *pOutput = output;
    
    while (*pKeyChar)
    {
        *currentKey = *pKeyChar;
        ++pKeyChar;
        ++currentKey;
    }
    
    [msgData enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        for (NSInteger i = 0; i < byteRange.length; i++)
        {
            *currentMsg = *((unsigned char*)bytes + i);
            ++currentMsg;
        }
    }];
    
    
    sm4_context ctx;
    hgbsm4_setkey_dec(&ctx, pKey);
    hgbsm4_crypt_ecb(&ctx,0,(int)msgLength,(unsigned char *)pMsg,(unsigned char *)output);
    
    unsigned long stringLength = 0;
    hgbunpaddingForDecryption(&pOutput, &stringLength);
    unsigned char *pfreeoutput = pOutput;
    
    NSString *outString = [[NSString alloc]initWithBytes:pOutput length:stringLength encoding:NSUTF8StringEncoding];
    
    free(pfreeKey);
    free(pfreeoutput);
    free(pfreeMsg);
    pKey = NULL;
    pMsg = NULL;
    pOutput = NULL;
    output = NULL;
    pfreeMsg = NULL;
    pfreeoutput = NULL;
    pfreeKey = NULL;
    
    return outString;
}


- (nullable NSString *)encryptionTextWithSM4CBCMode:(NSString *)encryptionText
{
    return [self encryptionWithSM4Key:self.key iv:self.iv encryptionText:encryptionText];
}


- (nullable NSString *)decryptionTextWithSM4CBCMode:(NSString *)decryptionText
{
    return [self decryptionWithSM4Key:self.key iv:self.iv decryptionText:decryptionText];
}


- (nullable NSString *)encryptionTextWithSM4ECBMode:(nonnull NSString *)encryptionText
{
    return [self encryptionWithSM4Key:self.key encryptionText:encryptionText];
}


- (nullable NSString *)decryptionTextWithSM4ECBMode:(nonnull NSString *)decryptionText
{
    return [self decryptionWithSM4Key:self.key decryptionText:decryptionText];
}


- (nullable NSString *)encryption:(NSString *)encryptionText
{
    switch (_type)
    {
        case TTSM4TypeCBC:
            return [self encryptionTextWithSM4CBCMode:encryptionText];
            break;
            
        case TTSM4TypeECB:
            return [self encryptionTextWithSM4ECBMode:encryptionText];
            break;
            
        default:
            break;
    }
    
    return nil;
}


- (nullable NSString *)decryption:(NSString *)decryptionText
{
    switch (_type)
    {
        case TTSM4TypeCBC:
            return [self decryptionTextWithSM4CBCMode:decryptionText];
            break;
            
        case TTSM4TypeECB:
            return [self decryptionTextWithSM4ECBMode:decryptionText];
            break;
            
        default:
            break;
    }
    
    return nil;
}
@end
