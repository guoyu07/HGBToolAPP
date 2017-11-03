//
//  HGBClearStorageTool.h
//  HelloCordova
//
//  Created by huangguangbao on 2017/8/3.
//
//

#import <Foundation/Foundation.h>

@interface HGBClearStorageTool : NSObject
/**
 清除缓存

 @param path 缓存地址
 */
+(BOOL)clearStrorageAtPath:(NSString *)path;
/**
 清除沙盒路径或子路径的缓存

 @param subPath 子路径-子路径为空时清空沙盒
 @return 结果
 */
+(BOOL)clearHomeStrorageWithSubPath:(NSString *)subPath;
/**
 清除沙盒Document路径或子路径的缓存

 @param subPath 子路径-子路径为空时清空Document
 @return 结果
 */
+(BOOL)clearDocumentStrorageWithSubPath:(NSString *)subPath;
/**
 清除沙盒Cache路径或子路径的缓存

 @param subPath 子路径-子路径为空时清空Cache
 @return 结果
 */
+(BOOL)clearCacheStrorageWithSubPath:(NSString *)subPath;
/**
 清除沙盒Tmp路径或子路径的缓存

 @param subPath 子路径-子路径为空时清空Tmp
 @return 结果
 */
+(BOOL)clearTmpStrorageWithSubPath:(NSString *)subPath;
@end
