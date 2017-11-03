//
//  HGBCompressedFileTool.m
//  HelloCordova
//
//  Created by huangguangbao on 2017/7/11.
//
//

#import "HGBCompressedFileTool.h"
#import <UIKit/UIKit.h>
#import "LZMAExtractor.h"
#import "SARUnArchiveANY.h"
#import "SSZipArchive.h"
#import "ZipArchive.h"

#define ReslutCode @"reslutCode"
#define ReslutMessage @"reslutMessage"


@interface HGBCompressedFileTool()
@end
@implementation HGBCompressedFileTool
/**
 解压

 @param filePath 文件路径
 @param password 密码
 @param destPath 目标地址
 */
+(void)unArchive: (NSString *)filePath andPassword:(NSString*)password toDestinationPath:(NSString *)destPath andWithCompleteBlock:(HGBCompressedCompleteBlock)completeBlock{

    if(filePath==nil||filePath.length==0){
        completeBlock(NO,@{ReslutCode:@(HGBCompressedFileToolErrorTypePath),ReslutMessage:@"文件路径不能为空"});
        return;
    }
    filePath=[HGBCompressedFileTool getCompletePathFromSimplifyFilePath:filePath];
    if(![HGBCompressedFileTool isExitAtFilePath:filePath]){
        completeBlock(NO,@{ReslutCode:@(HGBCompressedFileToolErrorTypePath),ReslutMessage:@"文件路径不存在"});
        return;


    }


    destPath=[HGBCompressedFileTool getDestinationCompletePathFromSimplifyFilePath:destPath];

    if(destPath&&[[destPath lastPathComponent] pathExtension].length!=0){
        destPath=[destPath stringByReplacingOccurrencesOfString:[[destPath lastPathComponent] pathExtension] withString:@""];

    }
    if(![HGBCompressedFileTool isExitAtFilePath:destPath]){
        [HGBCompressedFileTool createDirectoryPath:destPath];
    }

    NSAssert(filePath, @"can't find filePath");
    SARUnArchiveANY *unarchive = [[SARUnArchiveANY alloc]initWithPath:filePath];
    if (password != nil && password.length > 0) {
        unarchive.password = password;
    }

    if (destPath != nil)
        unarchive.destinationPath = destPath;
    unarchive.completionBlock = ^(NSArray *filePaths){
        NSLog(@"For Archive : %@",filePath);

        for (NSString *filename in filePaths) {
            NSLog(@"File: %@", filename);
        }
        completeBlock(YES,@{ReslutCode:@(HGBCompressedFileToolReslutSucess),ReslutMessage:@"sucess"});
    };
    unarchive.failureBlock = ^(){
        NSLog(@"Cannot be unarchived");
        completeBlock(NO,@{ReslutCode:@(HGBCompressedFileToolErrorCompress),ReslutMessage:@"解压失败"});

    };
    [unarchive decompress];
}
#pragma mark 压缩
/**
 压缩
 @param filePaths 文件路径集合
 @param destPath 目标地址
 @param completeBlock 结果
 */
+(void)archiveToZipWithFilePaths: (NSArray *)filePaths toDestinationPath:(NSString *)destPath andWithCompleteBlock:(HGBCompressedCompleteBlock)completeBlock{
    NSMutableArray *files=[NSMutableArray array];
    for(NSString *filePath in filePaths){
        NSString *path=[filePath copy];
        path=[HGBCompressedFileTool getCompletePathFromSimplifyFilePath:path];
        if(![HGBCompressedFileTool isExitAtFilePath:path]){
            completeBlock(NO,@{ReslutCode:@(HGBCompressedFileToolErrorTypePath),ReslutMessage:@"路径错误"});
            return;


        }
        [files addObject:path];

    }
    destPath=[HGBCompressedFileTool getDestinationCompletePathFromSimplifyFilePath:destPath];
    if(!([destPath containsString:[HGBCompressedFileTool getHomeFilePath]]||[destPath containsString:[HGBCompressedFileTool getMainBundlePath]])){
        destPath=[[HGBCompressedFileTool getDocumentFilePath] stringByAppendingPathComponent:destPath];
    }
    if(destPath&&[[destPath lastPathComponent] pathExtension].length!=0){
        destPath=[destPath stringByReplacingOccurrencesOfString:[[destPath lastPathComponent] pathExtension] withString:@"zip"];

    }else{
        destPath=[destPath stringByAppendingString:@"/归档.zip"];
    }
    if([HGBCompressedFileTool isExitAtFilePath:destPath]){
        completeBlock(NO,@{ReslutCode:@(HGBCompressedFileToolErrorTypePath),ReslutMessage:@"目标文件已存在"});
        return;
    }

    NSString *basePath=[destPath stringByDeletingLastPathComponent];
    if(![HGBCompressedFileTool isExitAtFilePath:basePath]){
        [HGBCompressedFileTool createDirectoryPath:basePath];
    }

    NSString *baseCopyPath=[[HGBCompressedFileTool getTmpFilePath] stringByAppendingPathComponent:[[destPath lastPathComponent] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",[[destPath lastPathComponent] pathExtension]] withString:@""]];

    if([HGBCompressedFileTool isExitAtFilePath:baseCopyPath]){
        [HGBCompressedFileTool removeFilePath:baseCopyPath];
    }

    for(NSString *filePath in files){
        [HGBCompressedFileTool copyFilePath:filePath ToPath:[baseCopyPath stringByAppendingPathComponent:[filePath lastPathComponent]]];
    }



    BOOL flag=[self doZipAtDirectoryPath:baseCopyPath to:destPath];
    if(flag){
        completeBlock(YES,@{ReslutCode:@(HGBCompressedFileToolReslutSucess),ReslutMessage:@"成功"});
    }else{
        completeBlock(NO,@{ReslutCode:@(HGBCompressedFileToolErrorCompress),ReslutMessage:@"压缩失败"});
    }
    [HGBCompressedFileTool removeFilePath:baseCopyPath];
}

/**
 压缩文件

 @param sourceDirectoryPath 源文件夹
 @param destZipFile 目标文件
 @return 结果
 */
+(BOOL)doZipAtDirectoryPath:(NSString*)sourceDirectoryPath to:(NSString*)destZipFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    ZipArchive * zipArchive = [ZipArchive new];
    [zipArchive CreateZipFile2:destZipFile];
    NSArray *subPaths = [fileManager subpathsAtPath:sourceDirectoryPath];// 关键是subpathsAtPath方法
    for(NSString *subPath in subPaths){
        NSString *fullPath = [sourceDirectoryPath stringByAppendingPathComponent:subPath];
        BOOL isDir;
        if([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir)// 只处理文件
        {
            [zipArchive addFileToZip:fullPath newname:subPath];
        }
    }
    [zipArchive CloseZipFile2];
    return YES;
}
#pragma mark 获取文件完整路径

/**
 将简化路径转化为完整路径

 @param simplifyFilePath 简化路径
 @return 完整路径
 */
+(NSString *)getCompletePathFromSimplifyFilePath:(NSString *)simplifyFilePath{
    NSString *path=[simplifyFilePath copy];
    if(![HGBCompressedFileTool isExitAtFilePath:path]){
        path=[[HGBCompressedFileTool getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
        if(![HGBCompressedFileTool isExitAtFilePath:path]){
            path=[[HGBCompressedFileTool getDocumentFilePath] stringByAppendingPathComponent:simplifyFilePath];
            if(![HGBCompressedFileTool isExitAtFilePath:path]){
                path=[[HGBCompressedFileTool getMainBundlePath] stringByAppendingPathComponent:simplifyFilePath];
                if(![HGBCompressedFileTool isExitAtFilePath:path]){
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
    if(!([simplifyFilePath containsString:[HGBCompressedFileTool getHomeFilePath]]||[simplifyFilePath containsString:[HGBCompressedFileTool getMainBundlePath]])){
        simplifyFilePath=[[HGBCompressedFileTool getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
    }
    return simplifyFilePath;
}
#pragma mark bundle
/**
 获取主资源文件路径

 @return 主资源文件路径
 */
+(NSString *)getMainBundlePath{
    return [[NSBundle mainBundle]resourcePath];
}
#pragma mark 沙盒
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
#pragma mark 文件
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
 文件拷贝

 @param srcPath 文件路径
 @param filePath 复制文件路径
 @return 结果
 */
+(BOOL)copyFilePath:(NSString *)srcPath ToPath:(NSString *)filePath{
    if(![HGBCompressedFileTool isExitAtFilePath:srcPath]){
        return NO;
    }
    NSString *directoryPath=[filePath stringByDeletingLastPathComponent];
    if(![HGBCompressedFileTool isExitAtFilePath:directoryPath]){
        [HGBCompressedFileTool createDirectoryPath:directoryPath];
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL flag=[filemanage copyItemAtPath:srcPath toPath:filePath error:nil];
    if(flag){
        return YES;
    }else{
        return NO;
    }
}
#pragma mark 文件夹
/**
 创建文件夹

 @param directoryPath 路径
 @return 结果
 */
+(BOOL)createDirectoryPath:(NSString *)directoryPath{
    if([HGBCompressedFileTool isExitAtFilePath:directoryPath]){
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
 是否是文件夹

 @param path 路径
 @return 结果
 */
+(BOOL)isDirectoryAtPath:(NSString *)path{
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
 获取沙盒tmp路径
 
 @return tmp路径
 */
+(NSString *)getTmpFilePath{
    NSString *tmpPath=NSTemporaryDirectory();
    return tmpPath;
}
@end
