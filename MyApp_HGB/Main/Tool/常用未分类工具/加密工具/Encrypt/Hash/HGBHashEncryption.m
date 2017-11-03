//
//  HGBHashEncryption.m
//  测试
//
//  Created by huangguangbao on 2017/9/11.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBHashEncryption.h"
#import <CommonCrypto/CommonDigest.h>


@interface HGBHashEncryption()
@property(assign,nonatomic)HGBHashEncryptType encryptType;
@end
@implementation HGBHashEncryption
static HGBHashEncryption *instance=nil;
#pragma mark init
/**
 单例

 @return 实例
 */
+(instancetype)shareInstance
{

    if (instance==nil) {
        instance=[[HGBHashEncryption alloc]init];
        instance.encryptType=HGBHashEncryptType_MD5_32Lower;
    }
    return instance;
}
#pragma mark  设置
/**
 设置hash字符串加密方式

 @param type 加密方式
 */
+(void)setHashEncrypType:(HGBHashEncryptType)type{
    [HGBHashEncryption shareInstance];
    instance.encryptType=type;
}
#pragma mark hash字符串生成
/**
 hash字符串

 @param jsonObject json对象-数组或字典
 @param salt salt字符串为空时不添加
 @return hash字符串
 */
+(NSString *)hashStringFromJsonObject:(id)jsonObject andWithSalt:(NSString *)salt{
    [HGBHashEncryption shareInstance];
    if(jsonObject==nil){
        return nil;
    }
    NSString *jsonString=[HGBHashEncryption ObjectToJSONString:jsonObject];
    if(jsonString){
        if(salt&&salt.length!=0){
            jsonString=[jsonString stringByAppendingString:salt];
        }
        NSString *string=[HGBHashEncryption hashEncryptWithString:jsonString];
        return string;
    }
    return nil;
}
/**
 hash字符串

 @param data 数据
 @param salt salt字符串为空时不添加
 @return hash数据
 */
+(NSData *)hashDataFromData:(NSData *)data andWithSalt:(NSString *)salt{
    [HGBHashEncryption shareInstance];
    NSString *string=[HGBHashEncryption hashStringFromJsonObject:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] andWithSalt:salt];

    return [string dataUsingEncoding:NSUTF8StringEncoding];

}
/**
 hash字符串加密方法

 @param string 原字符串
 */
+(NSString *)hashEncryptWithString:(NSString *)string{
    if(!string){
        return nil;
    }
    if(instance.encryptType==HGBHashEncryptType_MD2_16Lower){
        string=[HGBHashEncryption MD2ForLower16Bate:string];
    }else if (instance.encryptType==HGBHashEncryptType_MD2_16Upper){
        string=[HGBHashEncryption MD2ForUpper16Bate:string];
    }else if (instance.encryptType==HGBHashEncryptType_MD2_32Lower){
        string=[HGBHashEncryption MD2ForLower32Bate:string];

    }else if (instance.encryptType==HGBHashEncryptType_MD2_32Upper){
        string=[HGBHashEncryption MD2ForUpper32Bate:string];
    }else if(instance.encryptType==HGBHashEncryptType_MD4_16Lower){
        string=[HGBHashEncryption MD4ForLower16Bate:string];
    }else if (instance.encryptType==HGBHashEncryptType_MD4_16Upper){
         string=[HGBHashEncryption MD4ForUpper16Bate:string];
    }else if (instance.encryptType==HGBHashEncryptType_MD4_32Lower){
        string=[HGBHashEncryption MD4ForLower32Bate:string];
    }else if (instance.encryptType==HGBHashEncryptType_MD4_32Upper){
         string=[HGBHashEncryption MD4ForUpper32Bate:string];
    }else if(instance.encryptType==HGBHashEncryptType_MD5_16Lower){
        string=[HGBHashEncryption MD5ForLower16Bate:string];
    }else if (instance.encryptType==HGBHashEncryptType_MD5_16Upper){
        string=[HGBHashEncryption MD5ForUpper16Bate:string];
    }else if (instance.encryptType==HGBHashEncryptType_MD5_32Lower){
         string=[HGBHashEncryption MD5ForLower32Bate:string];
    }else if (instance.encryptType==HGBHashEncryptType_MD5_32Upper){
         string=[HGBHashEncryption MD5ForUpper32Bate:string];
    }else if(instance.encryptType==HGBHashEncryptType_SHA1_Lower){
        string=[HGBHashEncryption sha1LowerEncryptString:string];
    }else if(instance.encryptType==HGBHashEncryptType_SHA1_Upper){
        string=[HGBHashEncryption sha1UpperEncryptString:string];
    }else if (instance.encryptType==HGBHashEncryptType_SHA224_Lower){
        string=[HGBHashEncryption sha224LowerEncryptString:string];
    }else if (instance.encryptType==HGBHashEncryptType_SHA224_Upper){
        string=[HGBHashEncryption sha224UpperEncryptString:string];
    }else if (instance.encryptType==HGBHashEncryptType_SHA256_Lower){
        string=[HGBHashEncryption sha256LowerEncryptString:string];
    }else if (instance.encryptType==HGBHashEncryptType_SHA256_Upper){
        string=[HGBHashEncryption sha256UpperEncryptString:string];
    }else if (instance.encryptType==HGBHashEncryptType_SHA384_Lower){
        string=[HGBHashEncryption sha384LowerEncryptString:string];
        
    }else if (instance.encryptType==HGBHashEncryptType_SHA384_Upper){
        string=[HGBHashEncryption sha384UpperEncryptString:string];
    }else if (instance.encryptType==HGBHashEncryptType_SHA512_Lower){
        string=[HGBHashEncryption sha512LowerEncryptString:string];
    }else if (instance.encryptType==HGBHashEncryptType_SHA512_Upper){
        string=[HGBHashEncryption sha512UpperEncryptString:string];
    }

    return string;
}

#pragma mark  JSON
/**
 把Json对象转化成json字符串

 @param object json对象
 @return json字符串
 */
+ (NSString *)ObjectToJSONString:(id)object
{
    if(!([object isKindOfClass:[NSDictionary class]]||[object isKindOfClass:[NSArray class]]||[object isKindOfClass:[NSString class]])){
        return nil;
    }
    if([object isKindOfClass:[NSString class]]){
        return object;
    }
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return myString;
}
/**
 把Json字符串转化成json对象

 @param jsonString json字符串
 @return json字符串
 */
+ (id)JSONStringToObject:(NSString *)jsonString{
    if(![jsonString isKindOfClass:[NSString class]]){
        return nil;
    }
    jsonString=[HGBHashEncryption jsonStringHandle:jsonString];
    //    NSLog(@"%@",jsonString);
    NSError *error = nil;
    NSData  *data=[jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if(jsonString.length>0&&[[jsonString substringToIndex:1] isEqualToString:@"{"]){
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if(error){
            NSLog(@"%@",error);
            return jsonString;
        }else{
            return dic;
        }
    }else if(jsonString.length>0&&[[jsonString substringToIndex:1] isEqualToString:@"["]){
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if(error){
            NSLog(@"%@",error);
            return jsonString;
        }else{
            return array;
        }
    }else{
        return jsonString;
    }


}
/**
 json字符串处理

 @param jsonString 字符串处理
 @return 处理后字符串
 */
+(NSString *)jsonStringHandle:(NSString *)jsonString{
    NSString *string=jsonString;
    //大括号

    //中括号
    while ([string containsString:@"【"]) {
        string=[string stringByReplacingOccurrencesOfString:@"【" withString:@"]"];
    }
    while ([string containsString:@"】"]) {
        string=[string stringByReplacingOccurrencesOfString:@"】" withString:@"]"];
    }

    //小括弧
    while ([string containsString:@"（"]) {
        string=[string stringByReplacingOccurrencesOfString:@"（" withString:@"("];
    }

    while ([string containsString:@"）"]) {
        string=[string stringByReplacingOccurrencesOfString:@"）" withString:@")"];
    }


    while ([string containsString:@"("]) {
        string=[string stringByReplacingOccurrencesOfString:@"(" withString:@"["];
    }

    while ([string containsString:@")"]) {
        string=[string stringByReplacingOccurrencesOfString:@")" withString:@"]"];
    }


    //逗号
    while ([string containsString:@"，"]) {
        string=[string stringByReplacingOccurrencesOfString:@"，" withString:@","];
    }
    while ([string containsString:@";"]) {
        string=[string stringByReplacingOccurrencesOfString:@";" withString:@","];
    }
    while ([string containsString:@"；"]) {
        string=[string stringByReplacingOccurrencesOfString:@"；" withString:@","];
    }
    //引号
    while ([string containsString:@"“"]) {
        string=[string stringByReplacingOccurrencesOfString:@"“" withString:@"\""];
    }
    while ([string containsString:@"”"]) {
        string=[string stringByReplacingOccurrencesOfString:@"”" withString:@"\""];
    }
    while ([string containsString:@"‘"]) {
        string=[string stringByReplacingOccurrencesOfString:@"‘" withString:@"\""];
    }
    while ([string containsString:@"'"]) {
        string=[string stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    }
    //冒号
    while ([string containsString:@"："]) {
        string=[string stringByReplacingOccurrencesOfString:@"：" withString:@":"];
    }
    //等号
    while ([string containsString:@"="]) {
        string=[string stringByReplacingOccurrencesOfString:@"=" withString:@":"];
    }
    while ([string containsString:@"="]) {
        string=[string stringByReplacingOccurrencesOfString:@"=" withString:@":"];
    }
    return string;
    
}
#pragma mark sha1加密
/**
 *  sha1加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha1UpperEncryptString:(NSString*)string
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
        [output appendFormat:@"%02X", digest[i]];

    return output;

}
/**
 *  sha1加密-小写
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha1LowerEncryptString:(NSString*)string
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
#pragma mark sha224加密
/**
 *  sha224加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha224UpperEncryptString:(NSString*)string
{
    if(string==nil){
        return nil;
    }
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];

    uint8_t digest[CC_SHA224_DIGEST_LENGTH];

    CC_SHA224(data.bytes, (int)data.length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];

    return output;

}
/**
 *  sha224加密-小写
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha224LowerEncryptString:(NSString*)string
{
    if(string==nil){
        return nil;
    }
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];

    uint8_t digest[CC_SHA224_DIGEST_LENGTH];

    CC_SHA224(data.bytes, (int)data.length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;

}
#pragma mark sha256加密
/**
 *  sha256加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha256UpperEncryptString:(NSString*)string
{
    if(string==nil){
        return nil;
    }
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];

    uint8_t digest[CC_SHA256_DIGEST_LENGTH];

    CC_SHA256(data.bytes, (int)data.length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];

    return output;

}
/**
 *  sha256加密-小写
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha256LowerEncryptString:(NSString*)string
{
    if(string==nil){
        return nil;
    }
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];

    uint8_t digest[CC_SHA256_DIGEST_LENGTH];

    CC_SHA256(data.bytes, (int)data.length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;

}
#pragma mark sha384加密
/**
 *  sha384加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha384UpperEncryptString:(NSString*)string
{
    if(string==nil){
        return nil;
    }
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];

    uint8_t digest[CC_SHA384_DIGEST_LENGTH];

    CC_SHA384(data.bytes, (int)data.length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];

    return output;

}
/**
 *  sha384加密-小写
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha384LowerEncryptString:(NSString*)string
{
    if(string==nil){
        return nil;
    }
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];

    uint8_t digest[CC_SHA384_DIGEST_LENGTH];

    CC_SHA384(data.bytes, (int)data.length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    return output;

}
#pragma mark sha512加密
/**
 *  sha512加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha512UpperEncryptString:(NSString*)string
{
    if(string==nil){
        return nil;
    }
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];

    uint8_t digest[CC_SHA512_DIGEST_LENGTH];

    CC_SHA512(data.bytes, (int)data.length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];

    return output;

}
/**
 *  sha512加密-小写
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)sha512LowerEncryptString:(NSString*)string
{
    if(string==nil){
        return nil;
    }
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];

    uint8_t digest[CC_SHA512_DIGEST_LENGTH];

    CC_SHA512(data.bytes, (int)data.length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}
#pragma mark MD2
/**
 *  MD2加密, 32位 小写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD2ForLower32Bate:(NSString *)string{

    //要进行UTF8的转码
    const char* input = [string UTF8String];
    unsigned char result[CC_MD2_DIGEST_LENGTH];
    CC_MD2(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD2_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD2_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }

    return digest;
}


/**
 *  MD2加密, 32位 大写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD2ForUpper32Bate:(NSString *)string{

    //要进行UTF8的转码
    const char* input = [string UTF8String];
    unsigned char result[CC_MD2_DIGEST_LENGTH];
    CC_MD2(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD2_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD2_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }

    return digest;
}

/**
 *  MD2加密, 16位 小写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD2ForUpper16Bate:(NSString *)string{

    NSString *md5Str = [HGBHashEncryption MD2ForUpper32Bate:string];

    NSString  *string2;
    for (int i=0; i<24; i++) {
        string2=[md5Str substringWithRange:NSMakeRange(0, 16)];
    }
    return string2;
}


/**
 *  MD2加密, 16位 大写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD2ForLower16Bate:(NSString *)string{

    NSString *md5Str = [HGBHashEncryption MD2ForLower32Bate:string];

    NSString  *string2;
    for (int i=0; i<24; i++) {
        string2=[md5Str substringWithRange:NSMakeRange(0, 16)];
    }
    return string2;
}
#pragma mark MD4
/**
 *  MD4加密, 32位 小写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD4ForLower32Bate:(NSString *)string{

    //要进行UTF8的转码
    const char* input = [string UTF8String];
    unsigned char result[CC_MD4_DIGEST_LENGTH];
    CC_MD4(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD4_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD4_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }

    return digest;
}


/**
 *  MD4加密, 32位 大写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD4ForUpper32Bate:(NSString *)string{

    //要进行UTF8的转码
    const char* input = [string UTF8String];
    unsigned char result[CC_MD4_DIGEST_LENGTH];
    CC_MD4(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD4_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD4_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }

    return digest;
}

/**
 *  MD4加密, 16位 小写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD4ForUpper16Bate:(NSString *)string{

    NSString *md5Str = [HGBHashEncryption MD4ForUpper32Bate:string];

    NSString  *string2;
    for (int i=0; i<24; i++) {
        string2=[md5Str substringWithRange:NSMakeRange(0, 16)];
    }
    return string2;
}


/**
 *  MD4加密, 16位 大写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD4ForLower16Bate:(NSString *)string{

    NSString *md5Str = [HGBHashEncryption MD4ForLower32Bate:string];

    NSString  *string2;
    for (int i=0; i<24; i++) {
        string2=[md5Str substringWithRange:NSMakeRange(0, 16)];
    }
    return string2;
}
#pragma mark MD5
/**
 *  MD5加密, 32位 小写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForLower32Bate:(NSString *)string{

    //要进行UTF8的转码
    const char* input = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }

    return digest;
}


/**
 *  MD5加密, 32位 大写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForUpper32Bate:(NSString *)string{

    //要进行UTF8的转码
    const char* input = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }

    return digest;
}

/**
 *  MD5加密, 16位 小写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForUpper16Bate:(NSString *)string{

    NSString *md5Str = [HGBHashEncryption MD5ForUpper32Bate:string];

    NSString  *string2;
    for (int i=0; i<24; i++) {
        string2=[md5Str substringWithRange:NSMakeRange(0, 16)];
    }
    return string2;
}


/**
 *  MD5加密, 16位 大写
 *
 *  @param string 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForLower16Bate:(NSString *)string{

    NSString *md5Str = [HGBHashEncryption MD5ForLower32Bate:string];

    NSString  *string2;
    for (int i=0; i<24; i++) {
        string2=[md5Str substringWithRange:NSMakeRange(0, 16)];
    }
    return string2;
}
@end
