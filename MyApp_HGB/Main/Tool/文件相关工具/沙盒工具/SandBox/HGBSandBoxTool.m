//
//  HGBSandBoxTool.m
//  测试
//
//  Created by huangguangbao on 2017/9/15.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBSandBoxTool.h"

@implementation HGBSandBoxTool
#pragma mark 获取沙盒文件URL
/**
 获取沙盒根URL

 @return 根URL
 */
+(NSString *)getHomeFileURL{
    return [HGBSandBoxTool getUrlFromFilePath:[HGBSandBoxTool getHomeFilePath]];
}

/**
 获取沙盒DocumentURL

 @return DocumentURL
 */
+(NSString *)getDocumentFileURL{
    return [HGBSandBoxTool getUrlFromFilePath:[HGBSandBoxTool getDocumentFilePath]];
}

/**
 获取沙盒libraryURL

 @return libraryURL
 */
+(NSString *)getLibraryFileURL{
    return [HGBSandBoxTool getUrlFromFilePath:[HGBSandBoxTool getLibraryFilePath]];
}

/**
 获取沙盒cacheURL

 @return cacheURL
 */
+(NSString *)getCacheFileURL{
    return [HGBSandBoxTool getUrlFromFilePath:[HGBSandBoxTool getCacheFilePath]];
}

/**
 获取沙盒PreferenceURL

 @return PreferenceURL
 */
+(NSString *)getPreferenceFileURL{
    return [HGBSandBoxTool getUrlFromFilePath:[HGBSandBoxTool getPreferenceFilePath]];
}

/**
 获取沙盒tmpURL

 @return tmpURL
 */
+(NSString *)getTmpFileURL{
    return [HGBSandBoxTool getUrlFromFilePath:[HGBSandBoxTool getTmpFilePath]];
}
#pragma mark 获取沙盒文件路径
/**
 获取沙盒根路径

 @return 根路径
 */
+(NSString *)getHomeFilePath{
    NSString *path_huang=NSHomeDirectory();
    return path_huang;
}
/**
 获取沙盒Document路径

 @return Document路径
 */
+(NSString *)getDocumentFilePath{
    NSString  *path_huang =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    return path_huang;
}
/**
 获取沙盒library路径

 @return library路径
 */
+(NSString *)getLibraryFilePath{
    NSString  *path_huang =[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) lastObject];
    return path_huang;
}
/**
 获取沙盒cache路径

 @return cache路径
 */
+(NSString *)getCacheFilePath{
    NSString  *path_huang =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject];
    return path_huang;
}
/**
 获取沙盒Preference路径

 @return Preference路径
 */
+(NSString *)getPreferenceFilePath{
    NSString  *path_huang =[[HGBSandBoxTool getLibraryFilePath]stringByAppendingPathComponent:@"Preferences"];
    return path_huang;
}
/**
 获取沙盒tmp路径

 @return tmp路径
 */
+(NSString *)getTmpFilePath{
    NSString *tmpPath=NSTemporaryDirectory();
    return tmpPath;
}
#pragma mark 文件路径转url
/**
 通过文件路径获取url

 @param filePath 文件路径
 @return url
 */
+(NSString *)getUrlFromFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return nil;
    }
    NSURL *url_huang=[NSURL fileURLWithPath:filePath];
    return [url_huang absoluteString];
}
#pragma mark bundle
/**
 获取主资源文件路径

 @return 主资源文件路径
 */
+(NSString *)getMainBundlePath{
    return [[NSBundle mainBundle]resourcePath];
}
/**
 获取主资源文件URL
 @return 主资源文件URL
 */
+(NSString *)getMainBundleUrl{
    return [[[NSBundle mainBundle]resourceURL] absoluteString];
}
/**
 获取资源文件路径

 @param bundleName 资源文件名
 @return 资文件路径
 */
+(NSString *)getBundlePathWithBundleName:(NSString *)bundleName{
    NSString *path=[[NSBundle mainBundle]pathForResource:bundleName ofType:@".bundle"];
    return path;
}
/**
 获取资源文件URL

 @param bundleName 资源文件名
 @return 资源文件URL
 */

+(NSString *)getBundleUrlWithBundleName:(NSString *)bundleName{
    NSString *url=[[[NSBundle mainBundle]URLForResource:bundleName withExtension:@"bundle"] absoluteString];
    return url;
}
@end
