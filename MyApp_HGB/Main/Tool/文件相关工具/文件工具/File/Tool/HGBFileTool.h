//
//  HGBFileTool.h
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBFileTool : NSObject

#pragma mark 文件归档和反归档-普通

/**
 归档-普通
 
 @param object 要归档的数据
 @param filePath 归档的路径
 @return 保存结果
 */
+ (BOOL)archiverWithObject:(id)object filePath:(NSString *)filePath;
/**
 反归档-普通
 
 @param filePath 要解归档的路径
 @return 保存结果
 */
+ (id)unarcheiverWithfilePath:(NSString *)filePath;
#pragma mark 文件归档和反归档-加密
/**
 归档-加密
 
 @param object 要归档的数据
 @param filePath 归档路径
 @return 保存结果
 */
+ (BOOL)archiverEncryptWithObject:(id)object filePath:(NSString *)filePath;
/**
 反归档-加密
 
 @param filePath 要解归档路径
 @return 解归档后对象
 */
+ (id)unarcheiverWithEncryptFilePath:(NSString *)filePath;

#pragma mark 文档通用
/**
 文件拷贝
 
 @param srcPath 文件路径
 @param filePath 复制文件路径
 @return 结果
 */
+(BOOL)copyFilePath:(NSString *)srcPath ToPath:(NSString *)filePath;

/**
 文件剪切
 
 @param srcPath 文件路径
 @param filePath 复制文件路径
 @return 结果
 */
+(BOOL)moveFilePath:(NSString *)srcPath ToPath:(NSString *)filePath;

/**
 删除文档
 
 @param filePath 归档的路径
 @return 结果
 */
+ (BOOL)removeFilePath:(NSString *)filePath;
/**
 文档是否存在
 
 @param filePath 归档的路径
 @return 结果
 */
+(BOOL)isExitAtFilePath:(NSString *)filePath;

#pragma mark 文件夹
/**
 路径是不是文件夹

 @param path 路径
 @return 结果
*/
+(BOOL)isDirectoryAtPath:(NSString *)path;
/**
 创建文件夹
 
 @param directoryPath 路径
 @return 结果
 */
+(BOOL)createDirectoryPath:(NSString *)directoryPath;

/**
 获取文件夹直接子路径
 
 @param directoryPath 文件夹路径
 @return 结果
 */
+(NSArray *)getDirectSubPathsInDirectoryPath:(NSString *)directoryPath;
/**
 获取文件夹所有子路径
 
 @param directoryPath 文件夹路径
 @return 结果
 */
+(NSArray *)getAllSubPathsInDirectoryPath:(NSString *)directoryPath;
#pragma mark 文件信息
/**
 获取文件信息

 @param filePath 文件路径
 @return 文件信息
 */
+(NSDictionary *)getFileInfoFromFilePath:(NSString *)filePath;
/**
 文档是否可读

 @param filePath 文件路径
 @return 结果
 */
+(BOOL)isReadableFileAtFilePath:(NSString *)filePath;
/**
 文档是否可写

 @param filePath 文件路径
 @return 结果
 */
+(BOOL)isWriteableFileAtFilePath:(NSString *)filePath;
/**
 文档是否可删

 @param filePath 文件路径
 @return 结果
 */
+(BOOL)isDeleteableFileAtFilePath:(NSString *)filePath;
@end
