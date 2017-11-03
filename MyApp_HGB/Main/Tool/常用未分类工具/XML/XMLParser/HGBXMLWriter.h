//
//  HGBXMLWriter.h
//  测试
//
//  Created by huangguangbao on 2017/9/5.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBXMLWriter : NSObject

#pragma mark 字典
/**
 *  XML生成
 *
 *  @param dictionary 数据源
 *
 *  @return xml结果
 */
+(NSString *)XMLStringFromDictionary:(NSDictionary *)dictionary;
/**
 *  XML生成
 *
 *  @param dictionary 数据源
 *  @param header 是否是属性
 *
 *  @return xml结果
 */
+(NSString *)XMLStringFromDictionary:(NSDictionary *)dictionary withHeader:(BOOL)header;
/**
 *  XML生成
 *
 *  @param dictionary 数据源
 *  @param path xml文件地址
 *  @param error 错误
 *
 *  @return xml结果
 */
+(BOOL)XMLDataFromDictionary:(NSDictionary *)dictionary toPath:(NSString *)path  Error:(NSError **)error;
#pragma mark 数组
/**
 *  XML生成
 *
 *  @param array 数据源
 *
 *  @return xml结果
 */
+(NSString *)XMLStringFromArray:(NSArray *)array;
/**
 *  XML生成
 *
 *  @param array 数据源
 *  @param header 是否是属性
 *
 *  @return xml结果
 */
+(NSString *)XMLStringFromArray:(NSArray *)array withHeader:(BOOL)header;
/**
 *  XML生成
 *
 *  @param array 数据源
 *  @param path xml文件地址
 *  @param error 错误
 *
 *  @return xml结果
 */
+(BOOL)XMLDataFromArray:(NSArray *)array toPath:(NSString *)path  Error:(NSError **)error;
#pragma mark JSON字符串
/**
 *  XML生成
 *
 *  @param jsonString 数据源
 *
 *  @return xml结果
 */
+(NSString *)XMLStringFromJSONString:(NSString *)jsonString;
/**
 *  XML生成
 *
 *  @param  jsonString 数据源
 *  @param header 是否是属性
 *
 *  @return xml结果
 */
+(NSString *)XMLStringFromJSONString:(NSString *)jsonString withHeader:(BOOL)header;
@end
