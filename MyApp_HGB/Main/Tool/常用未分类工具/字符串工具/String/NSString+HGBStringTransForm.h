//
//  NSString+HGBStringTransForm.h
//  测试app
//
//  Created by huangguangbao on 2017/6/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HGBStringTransForm)
#pragma mark 字符串-十六进制字符串转化
/**
 十六进制转换为普通字符串的
 @return 普通字符串
 */
- (NSString *)stringFromHexString;
/**
 普通字符串转换为十六进制的
 
 @return 十六进制字符串
 */
- (NSString *)hexString;
#pragma mark 转换类
/**
 *  身份证号码转生日
 *
 *
 *  @return 生日
 */
-(NSString *)idCardNumTransToBirthday;
@end
