//
//  HGBStringTool.h
//  测试app
//
//  Created by huangguangbao on 2017/6/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+HGBStringCheck.h"
#import "NSString+HGBStringTransForm.h"
#import "NSString+HGBStringTypeCheck.h"
#import "NSString+HGBString.h"



@interface HGBStringTool : NSObject
#pragma mark 字符串处理
/**
 删除字符串两端空格
 
 @param string 字符串
 @return 处理后字符串
 */
+(NSString *)trimWithString:(NSString *)string;
/**
 删除字符串空格
 
 @param string 字符串
 @return 处理后字符串
 */
+(NSString *)deleteSpaceWithString:(NSString *)string;
/**
 汉字转拼音
 
 @param string 汉字字符串
 @return 拼音字符串
 */
+(NSString *) transToPinYinWithString:(NSString *)string;
/**
 *  获取数字字符串
 *
 *  @param string 原str
 *
 *  @return 字符串中的数字字符串
 */
+(NSString *)getNumberStringFromString:(NSString *)string;
/**
 *  url字符处理
 *
 *  @param urlString 原url
 *
 *  @return 新url
 */
+(NSString *)urlFormatString:(NSString *)urlString;
/**
 把Json对象转化成json字符串
 
 @param object 对象
 @return json字符串
 */
+ (NSString *)JSONString:(id)object;
/**
 把Json字符串转化成json对象
 
 @param jsonString json字符串
 @return json对象
 */
+ (id)JSOObject:(NSString *)jsonString;

/**
 字符串编码
 
 @param string 原字符串
 @return 编码后字符串
 */
+ (NSString *)stringEncodingWithString:(NSString *)string
;
#pragma mark  验证字符串类型
/**
 *  验证字符是否是数字
 *
 *  @param string string
 *
 *  @return  结果
 */
+(BOOL)isNumString:(NSString *)string;
/**
 *  验证字符是否是字母
 *
 *  @param string 字符串
 *
 *  @return  结果
 */
+(BOOL)isWordString:(NSString *)string;

/**
 *  验证字符是否是汉字
 *
 *  @param string 字符串
 *
 *  @return  结果
 */
+(BOOL)isChineseString:(NSString *)string;


/**
 *  验证字符是否是数字或字母
 *
 *  @param string 字符串
 *
 *  @return  结果
 */
+(BOOL)isNumOrWordString:(NSString *)string;
#pragma mark 字符串-十六进制字符串转化
/**
 十六进制转换为普通字符串的
 
 @param hexString 16进制字符串
 @return 普通字符串
 */
+ (NSString *)stringFromHexString:(NSString *)hexString;

/**
 普通字符串转换为十六进制的
 
 @param string 普通字符串
 @return 十六进制字符串
 */
+(NSString *)hexStringFromString:(NSString *)string;

#pragma mark 常用校验
/**
 *  校验字符串
 *
 *  @param string 字符串
 *  @param length 字符串长度
 *  @param type 0 数字 1字母 2字母数字 3汉字
 *
 *  @return 是否是纯数字字符串
 */
+(BOOL)checkCodeString:(NSString *)string WithLength:(int)length andWithType:(int)type;
/**
 *  手机号验证－宽松
 *
 *  @param phoneNum 手机号
 *
 *  @return 是否是手机号
 */
+ (BOOL)isMobileNumber:(NSString *)phoneNum;
/**
 *  手机号验证－严谨
 *
 *  @param phoneNum 手机号
 *
 *  @return 是否是手机号
 */
+ (BOOL)isStrictMobileNumber:(NSString *)phoneNum;


/**
 *  身份证验证-宽松
 *
 *  @param IdCardNum 身份证号码
 *
 *  @return 是否正确
 */
+(BOOL)isIDCardNum:(NSString *)IdCardNum;
/**
 *  身份证验证-严格
 *
 *  @param IdCardNum 身份证号码
 *
 *  @return 是否正确
 */
+(BOOL)isStritIDCardNum:(NSString *)IdCardNum;
/**
 *  性别判断
 *
 *  @param idCardNum 身份证号
 *
 *  @return 性别
 */
+(BOOL)isAWomanWithIdCardNum:(NSString *)idCardNum;
/**
 *  邮箱验证
 *
 *  @param email 邮箱
 *
 *  @return 是否正确
 */
+(BOOL)isValidateEmail:(NSString *)email;
/**
 *  邮编验证
 *
 *  @param zipCode 邮编号码
 *
 *  @return 是否正确
 */
+(BOOL)isZipCodeNum:(NSString *)zipCode;
#pragma mark 转换类
/**
 *  身份证号码转生日
 *
 *  @param idCardNum 身份证号码
 *
 *  @return 生日
 */
+(NSString *)idCardNumTransToBirthday:(NSString *)idCardNum;
@end
