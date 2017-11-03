//
//  HGBFileTool.m
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBFileTool.h"
#import "HGBFileBase64.h"

#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>


static NSString *SFHFKeychainUtilsErrorDomain = @"SFHFKeychainUtilsErrorDomain";

@implementation HGBFileTool
#pragma mark 文件归档和反归档-普通

/**
 归档-普通
 
 @param object 要归档的数据
 @param filePath 归档的路径
 @return 保存结果
 */
+ (BOOL)archiverWithObject:(id)object filePath:(NSString *)filePath
{
    if(filePath==nil||filePath.length==0){
        return NO;
    }
    filePath=[HGBFileTool getDestinationCompletePathFromSimplifyFilePath:filePath];
    NSString *fileName = [filePath lastPathComponent];
    
    
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isExit=[filemanage fileExistsAtPath:filePath];
    if(isExit){
        [filemanage removeItemAtPath:filePath error:nil];
    }else{
        NSString *directoryPath=[filePath stringByDeletingLastPathComponent];
        if(![HGBFileTool isExitAtFilePath:directoryPath]){
            [HGBFileTool createDirectoryPath:directoryPath];
        }
    }
    
    NSMutableData *archiverData = [NSMutableData data];
    
    //创建归档工具
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:archiverData];
    //归档
    [archiver encodeObject:object forKey:fileName];
    
    //结束归档
    [archiver finishEncoding];
    BOOL flag=[archiverData writeToFile:filePath atomically:YES];
    return flag;
    
}
/**
 反归档-普通
 
 @param filePath 要解归档的路径
 @return 解归档后对象
 */
+ (id)unarcheiverWithfilePath:(NSString *)filePath
{
    if(filePath==nil||filePath.length==0){
        return nil;
    }
    filePath=[HGBFileTool getCompletePathFromSimplifyFilePath:filePath];
    NSString *fileName = [filePath lastPathComponent];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if(!data){
        return nil;
    }
    //将NSData通过反归档,转化成CheckViolationModel的数组对象
    NSKeyedUnarchiver *unarcheiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    //通过反归档得到复杂对象
    id reslutObj = [unarcheiver decodeObjectForKey:fileName];
    return reslutObj;
    
}
#pragma mark 文件归档和反归档-加密
/**
 归档-加密
 
 @param object 要归档的数据
 @param filePath 归档的路径
 @return 保存结果
 */
+ (BOOL)archiverEncryptWithObject:(id)object filePath:(NSString *)filePath
{
    if(filePath==nil||filePath.length==0){
        return NO;
    }
     filePath=[HGBFileTool getDestinationCompletePathFromSimplifyFilePath:filePath];
     NSString *fileName = [filePath lastPathComponent];

    
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isExit=[filemanage fileExistsAtPath:filePath];
    if(isExit){
        [filemanage removeItemAtPath:filePath error:nil];
    }else{
        NSString *directoryPath=[filePath stringByDeletingLastPathComponent];
        if(![HGBFileTool isExitAtFilePath:directoryPath]){
            [HGBFileTool createDirectoryPath:directoryPath];
        }
    }
    
    NSMutableData *archiverData = [NSMutableData data];
    
    //创建归档工具
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:archiverData];
    //归档
    [archiver encodeObject:object forKey:fileName];
    
    //结束归档
    [archiver finishEncoding];
    archiverData=[NSMutableData dataWithData:[HGBFileTool AES256ParmEncryptData:archiverData WithKey:[NSString stringWithFormat:@"%@",fileName]]];
    
    BOOL flag=[archiverData writeToFile:filePath atomically:YES];
    return flag;
    
}
/**
 反归档-加密
 
 @param filePath 要解归档的路径
 @return 解归档后对象
 */
+ (id)unarcheiverWithEncryptFilePath:(NSString *)filePath
{
    if(filePath==nil||filePath.length==0){
        return nil;
    }
    filePath=[HGBFileTool getCompletePathFromSimplifyFilePath:filePath];
    NSString *fileName = [filePath lastPathComponent];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    data=[HGBFileTool AES256ParmDecryptData:data WithKey:[NSString stringWithFormat:@"%@",fileName]];
    if(!data){
        return nil;
    }
    //将NSData通过反归档,转化成CheckViolationModel的数组对象
    NSKeyedUnarchiver *unarcheiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    //通过反归档得到复杂对象
    id reslutObj = [unarcheiver decodeObjectForKey:fileName];
    return reslutObj;
    
}
#pragma mark 文档通用

/**
 文件拷贝
 
 @param srcPath 文件路径
 @param filePath 复制文件路径
 @return 结果
 */
+(BOOL)copyFilePath:(NSString *)srcPath ToPath:(NSString *)filePath{
    if(srcPath==nil||srcPath.length==0){
        return NO;
    }
    if(filePath==nil||filePath.length==0){
        filePath=[srcPath lastPathComponent];
    }
    srcPath=[HGBFileTool getCompletePathFromSimplifyFilePath:srcPath];
    filePath=[HGBFileTool getDestinationCompletePathFromSimplifyFilePath:filePath];
    if(![HGBFileTool isExitAtFilePath:srcPath]){
        return NO;
    }
    NSString *directoryPath=[filePath stringByDeletingLastPathComponent];
    if(![HGBFileTool isExitAtFilePath:directoryPath]){
        [HGBFileTool createDirectoryPath:directoryPath];
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL flag=[filemanage copyItemAtPath:srcPath toPath:filePath error:nil];
    if(flag){
        return YES;
    }else{
        return NO;
    }
}

/**
 文件剪切
 
 @param srcPath 文件路径
 @param filePath 复制文件路径
 @return 结果
 */
+(BOOL)moveFilePath:(NSString *)srcPath ToPath:(NSString *)filePath{

    if(srcPath==nil||srcPath.length==0){
        return NO;
    }
    if(filePath==nil||filePath.length==0){
        filePath=[srcPath lastPathComponent];
    }
    srcPath=[HGBFileTool getCompletePathFromSimplifyFilePath:srcPath];
    filePath=[HGBFileTool getDestinationCompletePathFromSimplifyFilePath:filePath];

    if(![HGBFileTool isExitAtFilePath:srcPath]){
        return NO;
    }
    NSString *directoryPath=[filePath stringByDeletingLastPathComponent];
    if(![HGBFileTool isExitAtFilePath:directoryPath]){
        [HGBFileTool createDirectoryPath:directoryPath];
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL flag=[filemanage moveItemAtPath:srcPath toPath:filePath error:nil];
    if(flag){
        return YES;
    }else{
        return NO;
    }
}

/**
 删除文档
 
 @param filePath 文件路径
 @return 结果
 */
+ (BOOL)removeFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return YES;
    }
    filePath=[HGBFileTool getDestinationCompletePathFromSimplifyFilePath:filePath];
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
 
 @param filePath 文件路径
 @return 结果
 */
+(BOOL)isExitAtFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return NO;
    }
    filePath=[HGBFileTool getDestinationCompletePathFromSimplifyFilePath:filePath];
     filePath=[HGBFileTool getDestinationCompletePathFromSimplifyFilePath:filePath];
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isExit=[filemanage fileExistsAtPath:filePath];
    return isExit;
}

#pragma mark 文件夹

/**
 路径是不是文件夹

 @param path 路径
 @return 结果
 */
+(BOOL)isDirectoryAtPath:(NSString *)path{
    if(path==nil||path.length==0){
        return NO;
    }
    path=[HGBFileTool getDestinationCompletePathFromSimplifyFilePath:path];
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isDir,isExit;
    isExit=[filemanage fileExistsAtPath:path isDirectory:&isDir];
    if(isExit==YES&&isDir==YES){
        return YES;
    }else{
        return NO;
    }
}
/**
 创建文件夹

 @param directoryPath 路径
 @return 结果
 */
+(BOOL)createDirectoryPath:(NSString *)directoryPath{
    if(directoryPath==nil||directoryPath.length==0){
        return NO;
    }
    directoryPath=[HGBFileTool getDestinationCompletePathFromSimplifyFilePath:directoryPath];
    if([HGBFileTool isExitAtFilePath:directoryPath]){
        return YES;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];
    BOOL flag=[filemanage createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:nil];
    if(flag){
        return YES;
    }else{
        return NO;
    }
}

/**
 获取文件夹直接子路径

 @param directoryPath 文件夹路径
 @return 结果
 */
+(NSArray *)getDirectSubPathsInDirectoryPath:(NSString *)directoryPath{
    if(directoryPath==nil||directoryPath.length==0){
        return nil;
    }
    directoryPath=[HGBFileTool getCompletePathFromSimplifyFilePath:directoryPath];
    if(![HGBFileTool isExitAtFilePath:directoryPath]){
        return nil;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    NSArray *paths=[filemanage contentsOfDirectoryAtPath:directoryPath error:nil];
    return paths;
}
/**
 获取文件夹所有子路径
 
 @param directoryPath 文件夹路径
 @return 结果
 */
+(NSArray *)getAllSubPathsInDirectoryPath:(NSString *)directoryPath{
    if(directoryPath==nil||directoryPath.length==0){
        return nil;
    }
    directoryPath=[HGBFileTool getCompletePathFromSimplifyFilePath:directoryPath];
    if(![HGBFileTool isExitAtFilePath:directoryPath]){
        return nil;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    NSArray *paths=[filemanage subpathsAtPath:directoryPath];
    return paths;
}
#pragma mark 文件信息
/**
 获取文件信息

 @param filePath 文件路径
 @return 文件信息
 */
+(NSDictionary *)getFileInfoFromFilePath:(NSString *)filePath{

    if(filePath==nil||filePath.length==0){
        return nil;
    }
    filePath=[HGBFileTool getCompletePathFromSimplifyFilePath:filePath];
    if(![HGBFileTool isExitAtFilePath:filePath]){
        return nil;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    NSDictionary *infoDic=[filemanage attributesOfItemAtPath:filePath error:nil];
    return infoDic;
}
/**
 文档是否可读

 @param filePath 文件路径
 @return 结果
 */
+(BOOL)isReadableFileAtFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return NO;
    }
     filePath=[HGBFileTool getCompletePathFromSimplifyFilePath:filePath];
    if(![HGBFileTool isExitAtFilePath:filePath]){
        return NO;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isRead=[filemanage isReadableFileAtPath:filePath];
    return isRead;
}
/**
 文档是否可写

 @param filePath 文件路径
 @return 结果
 */
+(BOOL)isWriteableFileAtFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return NO;
    }
     filePath=[HGBFileTool getCompletePathFromSimplifyFilePath:filePath];
    if(![HGBFileTool isExitAtFilePath:filePath]){
        return NO;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isWrite=[filemanage isWritableFileAtPath:filePath];
    return isWrite;
}
/**
 文档是否可删

 @param filePath 文件路径
 @return 结果
 */
+(BOOL)isDeleteableFileAtFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return NO;
    }
     filePath=[HGBFileTool getCompletePathFromSimplifyFilePath:filePath];
    if(![HGBFileTool isExitAtFilePath:filePath]){
        return NO;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isDelete=[filemanage isDeletableFileAtPath:filePath];
    return isDelete;
}

#pragma mark bundle
/**
 获取主资源文件路径

 @return 主资源文件路径
 */
+(NSString *)getMainBundlePath{
    return [[NSBundle mainBundle]resourcePath];
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
#pragma mark 加密
+ (NSData *)AES256ParmEncryptData:(NSData *)data WithKey:(NSString *)key   //加密
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


+ (NSData *)AES256ParmDecryptData:(NSData *)data WithKey:(NSString *)key   //解密
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}


#pragma mark 获取文件完整路径

/**
 将简化路径转化为完整路径

 @param simplifyFilePath 简化路径
 @return 完整路径
 */
+(NSString *)getCompletePathFromSimplifyFilePath:(NSString *)simplifyFilePath{
    NSString *path=[simplifyFilePath copy];
    if(![HGBFileTool isExitAtFilePath:path]){
         path=[[HGBFileTool getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
        if(![HGBFileTool isExitAtFilePath:path]){
             path=[[HGBFileTool getDocumentFilePath] stringByAppendingPathComponent:simplifyFilePath];
            if(![HGBFileTool isExitAtFilePath:path]){
                path=[[HGBFileTool getMainBundlePath] stringByAppendingPathComponent:simplifyFilePath];
                if(![HGBFileTool isExitAtFilePath:path]){
                    path=simplifyFilePath;
                }

            }

        }

    }
    return path;
}
/**
 将简化目标路径转化为完整路径

 @param simplifyFilePath 简化路径
 @return 完整路径
 */
+(NSString *)getDestinationCompletePathFromSimplifyFilePath:(NSString *)simplifyFilePath{
    if(!([simplifyFilePath containsString:[HGBFileTool getHomeFilePath]]||[simplifyFilePath containsString:[HGBFileTool getMainBundlePath]])){
        simplifyFilePath=[[HGBFileTool getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
    }
    return simplifyFilePath;
}

@end
