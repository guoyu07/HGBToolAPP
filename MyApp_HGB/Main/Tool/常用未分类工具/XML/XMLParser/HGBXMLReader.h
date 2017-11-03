//
//  HGBXMLReader.h
//  测试
//
//  Created by huangguangbao on 2017/9/5.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 解析超时时间，默认 1.0s */
#define PARSER_TIMEOUT 1.0

@interface HGBXMLReader : NSObject
#pragma mark 设置
/**
 *  是否读取最外层Item
 *
 *  @param isReadBaseItem 读取
 *
 */
+(void)isReadBaseItem:(BOOL)isReadBaseItem;
#pragma mark 工具
/**
 *  XML解析
 *
 *  @param path 待解析的xml路径
 *
 *  @return 解析结果
 */
+ (id)XMLObjectWithXmlPath:(NSString *)path;
/**
 *  XML解析
 *
 *  @param url 待解析的xml URL
 *
 *  @return 解析结果
 */
+ (id)XMLObjectWithXmlUrl:(NSString *)url;
/**
 *  XML解析
 *
 *  @param xmlString 待解析的xml字符串
 *
 *  @return 解析结果
 */
+ (id)XMLObjectWithXMLString:(NSString *)xmlString;
/**
 *  XML解析
 *
 *  @param data 待解析的二进制数据
 *
 *  @return 解析结果
 */
+ (id)XMLObjectWithData:(NSData *)data;
@end
