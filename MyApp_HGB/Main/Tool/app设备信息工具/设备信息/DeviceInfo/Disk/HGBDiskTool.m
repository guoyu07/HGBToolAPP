
//
//  HGBDiskTool.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/31.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBDiskTool.h"
#import <sys/utsname.h>
// 下面是获取mac地址需要导入的头文件
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>

#import <sys/sockio.h>
#import <sys/ioctl.h>

@implementation HGBDiskTool
#pragma mark - Disk
/**
 获取本 App 所占磁盘空间

 @return App 所占磁盘空间
 */
+ (NSString *)getApplicationSize {
    unsigned long long documentSize   =  [HGBDiskTool _getSizeOfFolder:[HGBDiskTool _getDocumentPath]];
    unsigned long long librarySize   =  [self _getSizeOfFolder:[HGBDiskTool _getLibraryPath]];
    unsigned long long cacheSize =  [HGBDiskTool _getSizeOfFolder:[HGBDiskTool _getCachePath]];

    unsigned long long total = documentSize + librarySize + cacheSize;

    NSString *applicationSize = [NSByteCountFormatter stringFromByteCount:total countStyle:NSByteCountFormatterCountStyleFile];
    return applicationSize;
}
/**
 获取磁盘总空间

 @return 磁盘总空间
 */
+ (int64_t)getTotalDiskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}
/**
 获取未使用的磁盘空间

 @return 未使用的磁盘空间
 */
+ (int64_t)getFreeDiskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}
/**
 获取已使用的磁盘空间

 @return 已使用的磁盘空间
 */
+ (int64_t)getUsedDiskSpace {
    int64_t totalDisk = [HGBDiskTool getTotalDiskSpace];
    int64_t freeDisk = [HGBDiskTool getFreeDiskSpace];
    if (totalDisk < 0 || freeDisk < 0) return -1;
    int64_t usedDisk = totalDisk - freeDisk;
    if (usedDisk < 0) usedDisk = -1;
    return usedDisk;
}
#pragma mark - Private Method
/**
 获取系统信息

 @param typeSpecifier 类型
 @return 信息
 */
+ (NSUInteger)_getSystemInfo:(uint)typeSpecifier {
    size_t size = sizeof(int);
    int result;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &result, &size, NULL, 0);
    return (NSUInteger)result;
}
/**
 获取Document路径

 @return Document路径
 */

+(NSString *)_getDocumentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
}

/**
 获取Library路径

 @return Library路径
 */
+ (NSString *)_getLibraryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
}

/**
 获取Cache路径

 @return Cache路径
 */
+ (NSString *)_getCachePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
}

/**
 获取文件夹大小

 @param folderPath 文件路径
 @return 文件大小
 */
+(unsigned long long)_getSizeOfFolder:(NSString *)folderPath {
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];

    NSString *file;
    unsigned long long folderSize = 0;

    while (file = [contentsEnumurator nextObject]) {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:file] error:nil];
        folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
    }
    return folderSize;
}
@end
