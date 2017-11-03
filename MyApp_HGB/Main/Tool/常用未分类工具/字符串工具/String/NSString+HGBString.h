//
//  NSString+HGBString.h
//  CTTX
//
//  Created by huangguangbao on 16/5/28.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 字符串处理
 */
@interface NSString (HGBString)
#pragma mark 删除两段空格
/**
 删除两段空格

 @return 字符串
 */
-(NSString *)trim;
#pragma mark 删除空格
/**
 删除空格

 @return 字符串
 */
-(NSString *)deleteSpace;
#pragma mark 汉字转拼音
/**
 汉字转拼音

 @return 汉字
 */
-(NSString *)transToPinYin;
/**
 *  获取数字字符串
 *
 *
 *  @return 字符串中的数字字符串
 */
-(NSString *)getNumberString;
/**
 *  url字符处理
 *
 *
 *  @return 新url
 */
-(NSString *)urlFormatString;
/**
 字符串编码
 @return 编码后字符串
 */
-(NSString *)stringEncoding;

@end
