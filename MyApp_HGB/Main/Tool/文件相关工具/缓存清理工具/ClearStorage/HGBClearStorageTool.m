//
//  HGBClearStorageTool.m
//  HelloCordova
//
//  Created by huangguangbao on 2017/8/3.
//
//

#import "HGBClearStorageTool.h"

@implementation HGBClearStorageTool
/**
 清除缓存

 @param path 缓存地址
 */
+(BOOL)clearStrorageAtPath:(NSString *)path{
    if(![HGBClearStorageTool isExitAtFilePath:path]){
        return NO;
    }
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    for (NSString *fileName in enumerator) {
        [HGBClearStorageTool removeFilePath:[path stringByAppendingPathComponent:fileName]];
    }
    return YES;
}
/**
 清除沙盒路径或子路径的缓存

 @param subPath 子路径-子路径为空时清空沙盒
 @return 结果
 */
+(BOOL)clearHomeStrorageWithSubPath:(NSString *)subPath{
    NSString *path=[HGBClearStorageTool getHomeFilePath];
    if(subPath&&subPath.length!=0){
        path=[path stringByAppendingPathComponent:subPath];
    }
    BOOL flag=[HGBClearStorageTool clearStrorageAtPath:path];
    return flag;

}

/**
 清除沙盒Document路径或子路径的缓存

 @param subPath 子路径-子路径为空时清空Document
 @return 结果
 */
+(BOOL)clearDocumentStrorageWithSubPath:(NSString *)subPath{
    NSString *path=[HGBClearStorageTool getDocumentFilePath];
    if(subPath&&subPath.length!=0){
        path=[path stringByAppendingPathComponent:subPath];
    }
    BOOL flag=[HGBClearStorageTool clearStrorageAtPath:path];
    return flag;
}
/**
 清除沙盒Cache路径或子路径的缓存

 @param subPath 子路径-子路径为空时清空Cache
 @return 结果
 */
+(BOOL)clearCacheStrorageWithSubPath:(NSString *)subPath{
    NSString *path=[HGBClearStorageTool getCacheFilePath];
    if(subPath&&subPath.length!=0){
        path=[path stringByAppendingPathComponent:subPath];
    }
    BOOL flag=[HGBClearStorageTool clearStrorageAtPath:path];
    return flag;
}
/**
 清除沙盒Tmp路径或子路径的缓存

 @param subPath 子路径-子路径为空时清空Tmp
 @return 结果
 */
+(BOOL)clearTmpStrorageWithSubPath:(NSString *)subPath{
    NSString *path=[HGBClearStorageTool getTmpFilePath];
    if(subPath&&subPath.length!=0){
        path=[path stringByAppendingPathComponent:subPath];
    }
    BOOL flag=[HGBClearStorageTool clearStrorageAtPath:path];
    return flag;
}
#pragma mark 文档通用
/**
 删除文档

 @param filePath 归档的路径
 @return 结果
 */
+ (BOOL)removeFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return YES;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isExit=[filemanage fileExistsAtPath:filePath];
    BOOL deleteFlag=NO;
    if(isExit){
        deleteFlag=[filemanage removeItemAtPath:filePath error:nil];
    }else{
        deleteFlag=NO;
    }
    return deleteFlag;
}
/**
 文档是否存在

 @param filePath 归档的路径
 @return 结果
 */
+(BOOL)isExitAtFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return NO;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isExit=[filemanage fileExistsAtPath:filePath];
    return isExit;
}

#pragma mark 沙盒路径
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
 获取沙盒cache路径

 @return cache路径
 */
+(NSString *)getCacheFilePath{
    NSString  *path_huang =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject];
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
@end
