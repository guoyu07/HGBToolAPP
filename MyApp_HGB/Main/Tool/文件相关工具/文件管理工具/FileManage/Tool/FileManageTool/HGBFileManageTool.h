//
//  HGBFileManageTool.h
//  测试
//
//  Created by huangguangbao on 2017/8/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HGBFileModel.h"

@interface HGBFileManageTool : NSObject
#pragma mark  开发模式
/**
 添加开发模式文件管理功能
 */
+(void)addDevelopFileManageToApplacation;

#pragma mark 获取文件信息

/**
 获取文件夹下子文件信息

 @param directoryPath 文件夹路径
 @return 子文件信息
 */
+(NSArray<HGBFileModel *> *)getFileModelsFromDirectoryPath:(NSString *)directoryPath;
#pragma mark 设置
/**
 设置不可删除文件

 @param filePaths 文件路径集合
 */
+(void)setIsUnDeleteableFilesWithPaths:(NSArray <NSString *>*)filePaths;
#pragma mark 获取沙盒文件路径
/**
 获取沙盒根路径

 @return 根路径
 */
+(NSString *)getHomeFilePath;
/**
 获取沙盒Document路径

 @return Document路径
 */
+(NSString *)getDocumentFilePath;
/**
 获取沙盒library路径

 @return library路径
 */
+(NSString *)getLibraryFilePath;
/**
 获取沙盒cache路径

 @return cache路径
 */
+(NSString *)getCacheFilePath;
/**
 获取沙盒Preference路径

 @return Preference路径
 */
+(NSString *)getPreferenceFilePath;
/**
 获取沙盒tmp路径

 @return tmp路径
 */
+(NSString *)getTmpFilePath;
#pragma mark bundle
/**
 获取主资源文件路径

 @return 主资源文件路径
 */
+(NSString *)getMainBundlePath;
/**
 获取主资源文件URL
 @return 主资源文件URL
 */
+(NSString *)getMainBundleUrl;

/**
 获取资源文件路径

 @param bundleName 资源文件名
 @return 资文件路径
 */
+(NSString *)getBundlePathWithBundleName:(NSString *)bundleName;
/**
 获取资源文件URL
 
 @param bundleName 资源文件名
 @return 资源文件URL
 */

+(NSString *)getBundleUrlWithBundleName:(NSString *)bundleName;
#pragma mark 文件工具
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

/**
 创建文件

 @param filePath 路径
 @return 结果
 */
+(BOOL)createFileAtPath:(NSString *)filePath;

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
/**
 文件清空

 @param filePath 路径
 @return 结果
 */
+(BOOL)clearStrorageAtFilePath:(NSString *)filePath;
@end
