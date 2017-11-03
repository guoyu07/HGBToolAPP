//
//  HGBSandBoxTool.h
//  测试
//
//  Created by huangguangbao on 2017/9/15.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBSandBoxTool : NSObject
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
#pragma mark 获取沙盒文件URL
/**
 获取沙盒根URL

 @return 根URL
 */
+(NSString *)getHomeFileURL;

/**
 获取沙盒DocumentURL

 @return DocumentURL
 */
+(NSString *)getDocumentFileURL;

/**
 获取沙盒libraryURL

 @return libraryURL
 */
+(NSString *)getLibraryFileURL;

/**
 获取沙盒cacheURL

 @return cacheURL
 */
+(NSString *)getCacheFileURL;

/**
 获取沙盒PreferenceURL

 @return PreferenceURL
 */
+(NSString *)getPreferenceFileURL;

/**
 获取沙盒tmpURL

 @return tmpURL
 */
+(NSString *)getTmpFileURL;
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
#pragma mark 文件路径转url
/**
 通过文件路径获取url

 @param filePath 文件路径
 @return url
 */
+(NSString *)getUrlFromFilePath:(NSString *)filePath;
@end
