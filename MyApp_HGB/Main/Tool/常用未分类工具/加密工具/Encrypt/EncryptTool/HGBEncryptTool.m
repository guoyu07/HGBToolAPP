//
//  HGBEncryptTool.m
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBEncryptTool.h"

#import "HGBBase64.h"
#import "HGBRSAEncrytor.h"
#import "HGBDES3Encryption.h"
#import "HGBAES256Encrytion.h"

#import "HGBMD5Encryption.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CommonCrypto/CommonDigest.h>
#import "HGBTTAlgorithmSM4.h"
#import "HGBHashEncryption.h"
#import "JSRSA.h"
@implementation HGBEncryptTool
#pragma mark 特殊字符编码
/**
 特殊字符编码
 
 @param string 字符串
 @return 编码后字符串
 */
+ (NSString *)specialStringEncodingWithString:(NSString *)string{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return encodedString;
    
}
/**
 特殊字符解码
 
 @param string 字符串
 @return 编码后字符串
 */
+ (NSString *)specialStringDecodingWithString:(NSString *)string{
    NSString *decryptString   = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]"));
    
    decryptString = [decryptString stringByReplacingOccurrencesOfString:@"%2B" withString:@"+"];
    return decryptString;
}
#pragma mark Base64-string
/**
 Base64编码-string
 
 @param string 字符串
 @return 编码后字符串
 */
+(NSString *)encryptStringWithBase64:(NSString *)string{
    NSData *encryptData=[HGBBase64 encodeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *encryptString=[[NSString alloc]initWithData:encryptData encoding:NSUTF8StringEncoding];
    return encryptString;
}

/**
 Base64解码-string
 
 @param string 字符串
 @return 解码后字符串
 */
+(NSString *)decryptStringWithBase64:(NSString *)string{
    NSData *decryptData=[HGBBase64 decodeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *decryptString=[[NSString alloc]initWithData:decryptData encoding:NSUTF8StringEncoding];
    return decryptString;

}
#pragma mark Base64-DataToSting
/**
 Base64编码-DataToSting
 
 @param data 数据
 @return 编码后字符串
 */
+(NSString *)encryptDataToStringWithBase64:(NSData *)data{
    return [HGBBase64 stringByEncodingData:data];
}

/**
 Base64解码-DataToSting
 
 @param string 字符串
 @return 解码后字符串
 */
+(NSData *)decryptStringToDataWithBase64:(NSString *)string{
    return [HGBBase64 decodeString:string];
}
#pragma mark Base64-data
/**
 Base64编码-data
 @param data 数据
 @return 编码后字符串
 */
+(NSData *)encryptDataWithBase64:(NSData *)data{
    return [HGBBase64 encodeData:data];
}

/**
 Base64解码-data
 
 @param data 数据
 @return 解码后字符串
 */
+(NSData *)decryptDataWithBase64:(NSData *)data{
    return [HGBBase64 decodeData:data];
}

#pragma mark RSA-file 公钥加密 私钥解密
/**
 RSA加密－不编码

 @param string 字符串
 @param filePath  '.der'格式的公钥文件路径
 @return 加密后字符串
 */
+(NSString *)encryptStringWithRSA:(NSString *)string andWithPublicKeyPath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0||(![filePath containsString:@"der"])){
        return nil;
    }
    [HGBRSAEncrytor shareInstance].publicKeyPath=filePath;
    NSString *encryptString= [HGBRSAEncrytor publicKeyEncryptString:string];
    return encryptString;
}

/**
 RSA加密－编码

 @param string 字符串
 @param filePath  '.der'格式的公钥文件路径
 @return 加密后字符串
 */
+(NSString *)encryptStringWithRSAEncoding:(NSString *)string andWithPublicKeyPath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0||(![filePath containsString:@"der"])){
        return nil;
    }
    [HGBRSAEncrytor shareInstance].publicKeyPath=filePath;
    NSString *encryptString= [HGBRSAEncrytor publicKeyEncryptString:string];
    return [HGBEncryptTool specialStringEncodingWithString:encryptString];
}


/**
 RSA解密

 @param string 字符串
 @param filePath      '.p12'格式的私钥文件路径
 @param pass      私钥密码
 @return 解密后字符串
 */
+(NSString *)decryptStringWithRSA:(NSString *)string andWithPrivateKeyPath:(NSString *)filePath andWithPassWord:(NSString *)pass{
    if(filePath==nil||filePath.length==0||(![filePath containsString:@"p12"])){
        return nil;
    }
    [HGBRSAEncrytor shareInstance].privateKeyPath=filePath;
    [HGBRSAEncrytor shareInstance].privateKeyPassword=pass;
    NSString* decryptString = [HGBRSAEncrytor privateKeyDecryptStringString:string];
    if(decryptString==nil||decryptString.length==0){
        decryptString=[HGBEncryptTool specialStringDecodingWithString:string];
        decryptString = [HGBRSAEncrytor privateKeyDecryptStringString:string];
    }
    return decryptString;

}

#pragma mark RSA-file 私钥加密 公钥解密
/**
 RSA加密－不编码

 @param string 字符串
 @param filePath      '.p12'格式的私钥文件路径
 @param pass      私钥密码
 @return 加密后字符串
 */
+(NSString *)encryptStringWithReverseRSA:(NSString *)string andWithPrivateKeyPath:(NSString *)filePath andWithPassWord:(NSString *)pass{
    if(filePath==nil||filePath.length==0||(![filePath containsString:@"p12"])){
        return nil;
    }
//    [HGBRSAEncrytor shareInstance].privateKeyPath=filePath;
//    [HGBRSAEncrytor shareInstance].privateKeyPassword=pass;
//    NSString* encryptString = [HGBRSAEncrytor publicKeyEncryptString:string];
//    return encryptString;


    [JSRSA sharedInstance].privateKey=filePath;
    NSString *encryptString=[[JSRSA sharedInstance]privateEncrypt:string];
    return encryptString;
}

/**
 RSA加密－编码

 @param string 字符串
 @param filePath      '.p12'格式的私钥文件路径
 @param pass      私钥密码
 @return 加密后字符串
 */
+(NSString *)encryptStringWithReverseRSAEncoding:(NSString *)string andWithPrivateKeyPath:(NSString *)filePath andWithPassWord:(NSString *)pass{
    if(filePath==nil||filePath.length==0||(![filePath containsString:@"p12"])){
        return nil;
    }
//    [HGBRSAEncrytor shareInstance].privateKeyPath=filePath;
//    [HGBRSAEncrytor shareInstance].privateKeyPassword=pass;
//    NSString* encryptString = [HGBRSAEncrytor publicKeyEncryptString:string];
//    return [HGBEncryptTool specialStringEncodingWithString:encryptString];
    [JSRSA sharedInstance].privateKey=filePath;
    NSString *encryptString=[[JSRSA sharedInstance]privateEncrypt:string];
    return [HGBEncryptTool specialStringEncodingWithString:encryptString];

}


/**
 RSA解密

 @param string 字符串
 @param filePath  '.der'格式的公钥文件路径
 @return 解密后字符串
 */
+(NSString *)decryptStringWithReverseRSA:(NSString *)string andWithPublicKeyPath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0||(![filePath containsString:@"p12"])){
        return nil;
    }
//    [HGBRSAEncrytor shareInstance].publicKeyPath=filePath;
//    NSString* decryptString = [HGBRSAEncrytor publicKeyDecryptStringString:string];
//    if(decryptString==nil||decryptString.length==0){
//        decryptString=[HGBEncryptTool specialStringDecodingWithString:string];
//        decryptString = [HGBRSAEncrytor publicKeyDecryptStringString:string];
//    }
//    return decryptString;

    [JSRSA sharedInstance].publicKey=filePath;
    NSString *decryptString=[[JSRSA sharedInstance]publicDecrypt:string];
    return decryptString;
}

//

#pragma mark RSA-key 公钥加密 私钥解密
/**
 RSA加密－编码

 @param string 字符串
 @param pulickey  公钥
 @return 加密后字符串
 */
+(NSString *)encryptStringWithRSAEncoding:(NSString *)string andWithPulicKey:(NSString *)pulickey{
    pulickey=[HGBEncryptTool trim:pulickey];
    if(string==nil){
        return nil;
    }
    if(pulickey==nil||pulickey.length==0){
        return nil;
    }
    [HGBRSAEncrytor shareInstance].publicKey=pulickey;
    [HGBRSAEncrytor shareInstance].useStringKey=YES;
    NSString *encryptString= [HGBRSAEncrytor publicKeyEncryptString:string];
    return [HGBEncryptTool specialStringEncodingWithString:encryptString];
}

/**
 RSA加密－不编码

 @param string 字符串
 @param pulickey  公钥
 @return 加密后字符串
 */
+(NSString *)encryptStringWithRSA:(NSString *)string andWithPulicKey:(NSString *)pulickey{
    pulickey=[HGBEncryptTool trim:pulickey];
    if(string==nil){
        return nil;
    }
    if(pulickey==nil||pulickey.length==0){
        return nil;
    }
    [HGBRSAEncrytor shareInstance].publicKey=pulickey;
    [HGBRSAEncrytor shareInstance].useStringKey=YES;
    NSString *encryptString= [HGBRSAEncrytor publicKeyEncryptString:string];
    return encryptString;
}
/**
 RSA解密

 @param string 字符串
 @param privateKey  私钥
 @return 解密后字符串
 */
+(NSString *)decryptStringWithRSA:(NSString *)string andWithPrivateKey:(NSString *)privateKey{
    if(string==nil){
        return nil;
    }
    if(privateKey==nil||privateKey.length==0){
        return nil;
    }
    [HGBRSAEncrytor shareInstance].privateKey=privateKey;
    [HGBRSAEncrytor shareInstance].useStringKey=YES;
    NSString *decryptString= [HGBRSAEncrytor privateKeyDecryptStringString:string];
    if(decryptString==nil||decryptString.length==0){
        decryptString=[HGBEncryptTool specialStringDecodingWithString:string];
        decryptString= [HGBRSAEncrytor privateKeyDecryptStringString:string];
    }
    return decryptString;
}

#pragma mark RSA-key 私钥加密 公钥解密
/**
 RSA加密－编码

 @param string 字符串
 @param privateKey  私钥
 @return 加密后字符串
 */
+(NSString *)encryptStringWithReverseRSAEncoding:(NSString *)string andWithPrivateKey:(NSString *)privateKey{
    if(string==nil){
        return nil;
    }
    if(privateKey==nil||privateKey.length==0){
        return nil;
    }
    [HGBRSAEncrytor shareInstance].privateKey=privateKey;
    [HGBRSAEncrytor shareInstance].useStringKey=YES;
    NSString *encryptString= [HGBRSAEncrytor privateKeyEncryptString:string];
    return [HGBEncryptTool specialStringEncodingWithString:encryptString];
}

/**
 RSA加密－不编码

 @param string 字符串
 @param privateKey  私钥
 @return 加密后字符串
 */
+(NSString *)encryptStringWithReverseRSA:(NSString *)string andWithPrivateKey:(NSString *)privateKey{
    if(string==nil){
        return nil;
    }
    if(privateKey==nil||privateKey.length==0){
        return nil;
    }
    [HGBRSAEncrytor shareInstance].privateKey=privateKey;
    [HGBRSAEncrytor shareInstance].useStringKey=YES;
    NSString *encryptString= [HGBRSAEncrytor privateKeyEncryptString:string];
    return encryptString;
}
/**
 RSA解密

 @param string 字符串
 @param pulickey  公钥
 @return 解密后字符串
 */
+(NSString *)decryptStringWithReverseRSA:(NSString *)string andWithPulicKey:(NSString *)pulickey{
    pulickey=[HGBEncryptTool trim:pulickey];
    if(string==nil){
        return nil;
    }
    if(pulickey==nil||pulickey.length==0){
        return nil;
    }
    [HGBRSAEncrytor shareInstance].publicKey=pulickey;
    [HGBRSAEncrytor shareInstance].useStringKey=YES;
    NSString *decryptString= [HGBRSAEncrytor publicKeyDecryptStringString:string];
    if(decryptString==nil||decryptString.length==0){
        decryptString=[HGBEncryptTool specialStringDecodingWithString:string];
        decryptString= [HGBRSAEncrytor publicKeyDecryptStringString:string];
    }
    return decryptString;
}

#pragma mark DES3
/**
 DES3加密
 
 @param string 字符串
 @param key  加密密钥
 @return 加密后字符串
 */
+(NSString *)encryptStringWithDES3:(NSString *)string andWithKey:(NSString *)key{
    
    NSString *encryptString= [HGBDES3Encryption DES3EncryptString:string WithKey:key];
    return encryptString;
}
/**
 DES3解密
 
 @param string 字符串
 @param key  解密密钥
 @return 解密后字符串
 */
+(NSString *)decryptStringWithDES3:(NSString *)string andWithKey:(NSString *)key{
    NSString *decryptString= [HGBDES3Encryption DES3DecryptString:string WithKey:key];
    return decryptString;
}
#pragma mark AES256-string
/**
 AES256加密
 
 @param string 字符串
 @param key  加密密钥
 @return 加密后字符串
 */
+(NSString *)encryptStringWithAES256:(NSString *)string andWithKey:(NSString *)key{
    if(key==nil||key.length==0){
        return nil;
    }
    if(string==nil){
        return nil;
    }
    NSString *encryptString= [HGBAES256Encrytion AES256EncryptString:string WithKey:key];
    return encryptString;
}
/**
 AES256解密
 
 @param string 字符串
 @param key  解密密钥
 @return 解密后字符串
 */
+(NSString *)decryptStringWithAES256:(NSString *)string
                     andWithKey:(NSString *)key{
    if(key==nil||key.length==0){
        return nil;
    }
    if(string==nil){
        return nil;
    }
    NSString *decryptString= [HGBAES256Encrytion AES256DecryptString:string WithKey:key];
    return decryptString;
}
#pragma mark AES-data
/**
 AES256加密
 
 @param data 数据
 @param key  加密密钥
 @return 加密后数据
 */
+(NSData *)encryptDataWithAES256:(NSData *)data andWithKey:(NSString *)key{
    if(key==nil||key.length==0){
        return nil;
    }
    NSData *encryptData= [HGBAES256Encrytion AES256EncryptData:data WithKey:key];
    return encryptData;
}
/**
 AES256解密
 
 @param data 数据
 @param key  解密密钥
 @return 解密后数据
 */
+(NSData *)decryptDataWithAES256:(NSData *)data andWithKey:(NSString *)key{
    if(key==nil||key.length==0){
        return nil;
    }
    NSData *decryptData= [HGBAES256Encrytion AES256DecryptData:data WithKey:key];
    return decryptData;
}

#pragma mark  MD5-32
/**
 MD5加密-32小写
 
 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithMD5_32LOW:(NSString *)string{
    
    NSString *encryptString= [HGBMD5Encryption MD5ForLower32Bate:string];
    return encryptString;
}
/**
 MD5加密-32大写
 
 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithMD5_32UP:(NSString *)string{
    NSString *encryptString= [HGBMD5Encryption MD5ForUpper32Bate:string];
    return encryptString;
}
#pragma mark  MD5-16
/**
 MD5加密-16小写
 
 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithMD5_16LOW:(NSString *)string{
    NSString *encryptString= [HGBMD5Encryption MD5ForLower16Bate:string];
    return encryptString;
}
/**
 MD5加密-16大写
 
 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithMD5_16UP:(NSString *)string{
    NSString *encryptString= [HGBMD5Encryption MD5ForUpper16Bate:string];
    return encryptString;
}
#pragma mark sha1加密
/**
 *  sha1加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)encryptStringWithsha1:(NSString*)string
{
    if(string==nil){
        return nil;
    }
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}
#pragma mark 哈希字符串拼接
/**
 哈希字符串拼接

 @param object 对象
 @param salt salt
 @return hash字符串
 */
+(NSString *)hashStringFromJsonObject:(id )object andWithSalt:(NSString *)salt{
    if(salt==nil||salt.length==0){
        return nil;
    }
    [HGBHashEncryption setHashEncrypType:HGBHashEncryptType_MD4_32Lower];
    NSString *reslut= [HGBHashEncryption hashStringFromJsonObject:object andWithSalt:salt];
    return reslut;
}
#pragma mark SM4国密算法-CBC

/**
 *  TTAlgorithmSM4-CBC加密
 *
 *  @param key   要存的对象的key值-16位
 *  @param string 要保存的value值
 *  @param iv 初始化向量-16位
 *  @return 获取的对象
 */
+ (NSString *)encryptStringWithTTAlgorithmSM4_CBC:(NSString *)string andWithKey:(NSString *)key andWithIV:(NSString *)iv{
    if(key==nil||key.length!=16||iv==nil||iv.length!=16){
        return nil;
    }
    
    NSData *encryptData=[string dataUsingEncoding:NSUTF8StringEncoding];
    string=[[NSString alloc]initWithData:encryptData encoding:NSUTF8StringEncoding];
    
    HGBTTAlgorithmSM4 *sm4 = [HGBTTAlgorithmSM4 cbcSM4WithKey:key iv:iv];
    NSString *encryptionString = [sm4 encryption:string];
    return encryptionString;
}
/**
 *  TTAlgorithmSM4-CBC解密
 *
 *  @param key 对象的key值-16位
 *  @param string 初始化向量
 *  @param iv 初始化向量-16位
 *  @return 获取的对象
 */

+(NSString *)decryptStringWithTTAlgorithmSM4_CBC:(NSString *)string andWithKey:(NSString *)key andWithIV:(NSString *)iv{
    if(key==nil||key.length!=16||iv==nil||iv.length!=16){
        return nil;
    }
    
    HGBTTAlgorithmSM4 *sm4 = [HGBTTAlgorithmSM4 cbcSM4WithKey:key iv:iv];
    NSString *decryptionString = [sm4 decryption:string];
    return decryptionString;

}
#pragma mark SM4国密算法-ECB
/**
 *  TTAlgorithmSM4-ECB加密
 *
 *  @param key   要存的对象的key值-16位
 *  @param string 要保存的value值
 *  @return 获取的对象
 */
+ (NSString *)encryptStringWithTTAlgorithmSM4_ECB:(NSString *)string andWithKey:(NSString *)key{
    if(key==nil||key.length!=16){
        return nil;
    }
    
    NSData *encryptData=[string dataUsingEncoding:NSUTF8StringEncoding];
    string=[[NSString alloc]initWithData:encryptData encoding:NSUTF8StringEncoding];
    
    HGBTTAlgorithmSM4 *sm4 = [HGBTTAlgorithmSM4 ecbSM4WithKey:key];
    NSString *encryptionString = [sm4 encryption:string];
    return encryptionString;
}
/**
 *  TTAlgorithmSM4-ECB解密
 *
 *  @param key 对象的key值-16位
 *  @param string 初始化向量
 *  @return 获取的对象
 */

+(NSString *)decryptStringWithTTAlgorithmSM4_ECB:(NSString *)string andWithKey:(NSString *)key{
    if(key==nil||key.length!=16){
        return nil;
    }
    HGBTTAlgorithmSM4
    *sm4 = [HGBTTAlgorithmSM4 ecbSM4WithKey:key];
    NSString *decryptionString = [sm4 decryption:string];
    return decryptionString;
}

#pragma mark 判断文件是否存在
/**
 *  判断文件是否存在
 *
 *  @param path 文件路径
 *
 *  @return 是否存在
 */
+ (BOOL)isExistWithFilePath:(NSString *)path
{
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isExit=[filemanage fileExistsAtPath:path];
    return isExit;
}
#pragma mark 删除两端空格
+(NSString *)trim:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
