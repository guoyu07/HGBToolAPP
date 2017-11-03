
//
//  HGBFileManageTool.m
//  测试
//
//  Created by huangguangbao on 2017/8/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBFileManageTool.h"
#import "HGBFileManageController.h"
@interface HGBFileManageTool()
/**
 不可删除文件
 */
@property(strong,nonatomic)NSMutableArray *unDeleteableFiles;
/**
 文件管理
 */
@property(strong,nonatomic)HGBFileManageController *fileManageVC;
@end
@implementation HGBFileManageTool
static HGBFileManageTool *instance=nil;
#pragma mark init
/**
 单例

 @return 模型
 */
+(instancetype)shareInstance;
{

    if (instance==nil) {
        instance=[[HGBFileManageTool alloc]init];
    }
    return instance;
}
#pragma mark  开发模式
/**
 添加开发模式文件管理功能
 */
+(void)addDevelopFileManageToApplacation{
    [HGBFileManageTool shareInstance];
    UITapGestureRecognizer *tapPress=[[UITapGestureRecognizer alloc]initWithTarget:instance action:@selector(tapPressHandler:)];
    tapPress.numberOfTouchesRequired=1;
    tapPress.numberOfTapsRequired=6;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tapPress];
}
-(void)tapPressHandler:(UITapGestureRecognizer *)_p{
    self.fileManageVC=[[HGBFileManageController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:self.fileManageVC];
    [[HGBFileManageTool currentViewController] presentViewController:nav animated:YES completion:nil];
}
#pragma mark 主要功能
/**
 获取文件夹下子文件信息

 @param directoryPath 文件夹路径
 @return 子文件信息
 */
+(NSArray<HGBFileModel *> *)getFileModelsFromDirectoryPath:(NSString *)directoryPath{
    [HGBFileManageTool shareInstance];
    if(directoryPath==nil||directoryPath.length==0){
        directoryPath=[HGBFileManageTool getHomeFilePath];
    }
    NSString *directoryPathCopy=[directoryPath copy];
    if(![HGBFileManageTool isExitAtFilePath:directoryPathCopy]){
        directoryPathCopy=[[HGBFileManageTool getHomeFilePath] stringByAppendingPathComponent:directoryPath];
        if(![HGBFileManageTool isExitAtFilePath:directoryPath]){
            directoryPathCopy=[[HGBFileManageTool getDocumentFilePath] stringByAppendingPathComponent:directoryPath];
            if(![HGBFileManageTool isExitAtFilePath:directoryPath]){
                return nil;
            }else{
                directoryPath=directoryPathCopy;
            }
        }else{
            directoryPath=directoryPathCopy;
        }
    }
    if(![HGBFileManageTool isDirectoryAtPath:directoryPath]){
        return nil;
    }
    NSArray *filePaths=[HGBFileManageTool getDirectSubPathsInDirectoryPath:directoryPath];
    NSMutableArray *fileModels=[NSMutableArray array];
    for(NSString *filePath in filePaths){
        if([[filePath lastPathComponent] containsString:@"DS_Store"]){
            continue;
        }
        if([[filePath lastPathComponent] containsString:@"metadata"]){
            continue;
        }
        if([[filePath lastPathComponent] containsString:@"Snapshots"]){
            continue;
        }

        if([filePath containsString:@"pastBord_huang"]){
            continue;
        }

        NSString *path=[directoryPath stringByAppendingPathComponent:filePath];

        HGBFileModel *fileModel=[[HGBFileModel alloc]init];
        fileModel.fileName=[filePath lastPathComponent];

        if([path containsString:[HGBFileManageTool getHomeFilePath]]){
             fileModel.filePath=[path stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",[HGBFileManageTool getHomeFilePath]] withString:@""];
            fileModel.fileType=HGBFilePathTypeSandBox;
        }else if ([path containsString:[HGBFileManageTool getMainBundlePath]]){
            fileModel.filePath=[path stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",[HGBFileManageTool getMainBundlePath]] withString:@""];
            fileModel.fileType=HGBFilePathTypeBundle;
        }else{
            fileModel.fileType=HGBFilePathTypeOther;
        }
       fileModel.fileIcon=[HGBFileManageTool getFileIconWithFilPath:path];
        fileModel.fileSize=[HGBFileManageTool getFileSizeWithFilPath:path];
        fileModel.fileAbout=[HGBFileManageTool getFileInfoWithFilePath:path];
        fileModel.fileType=[HGBFileManageTool getFileTypeWithFilePath:path];
       if([path containsString:[HGBFileManageTool getPreferenceFilePath]]){
            fileModel.isEdit=NO;
       }else{
           fileModel.isEdit=YES;
       }

        [fileModels addObject:fileModel];
    }
    return fileModels;
}
#pragma mark set
/**
 设置不可删除文件

 @param filePaths 文件路径集合
 */
+(void)setIsUnDeleteableFilesWithPaths:(NSArray <NSString *>*)filePaths{
    [HGBFileManageTool shareInstance];
    if(filePaths){
        [instance.unDeleteableFiles addObjectsFromArray:filePaths];
    }

}
#pragma mark 获取文件信息
/**
 获取文件图标

 @param filePath 文件路径
 @return 图标
 */
+(NSString *)getFileIconWithFilPath:(NSString *)filePath{
    [HGBFileManageTool shareInstance];
    if(filePath==nil||filePath.length==0){
        return @"HGBFileManageToolBundle.bundle/undefine.png";
    }
    HGBFileType fileType=[HGBFileManageTool getFileTypeWithFilePath:filePath];
    if(fileType==HGBFileTypeUnknown){
        return @"HGBFileManageToolBundle.bundle/undefine.png";
    }else if (fileType==HGBFileTypeDirectory){
        return @"HGBFileManageToolBundle.bundle/directory.png";
    }else if (fileType==HGBFileTypeText){
        return @"HGBFileManageToolBundle.bundle/text.png";
    }else if (fileType==HGBFileTypeWord){
        return @"HGBFileManageToolBundle.bundle/word.png";
    }else if (fileType==HGBFileTypeExcel){
        return @"HGBFileManageToolBundle.bundle/excel.png";
    }else if (fileType==HGBFileTypePowerPoint){
        return @"HGBFileManageToolBundle.bundle/ppt.png";
    }else if (fileType==HGBFileTypePDF){
        return @"HGBFileManageToolBundle.bundle/pdf.png";
    }else if (fileType==HGBFileTypeImage){
        return @"HGBFileManageToolBundle.bundle/image.png";
    }else if (fileType==HGBFileTypeAudio){
        return @"HGBFileManageToolBundle.bundle/audio.png";
    }else if (fileType==HGBFileTypeVideo){
        return @"HGBFileManageToolBundle.bundle/vedio.png";
    }else if (fileType==HGBFileTypeCompress){
        return @"HGBFileManageToolBundle.bundle/compress.png";
    }else if (fileType==HGBFileTypeBundle){
        return @"HGBFileManageToolBundle.bundle/bundle.png";
    }else{
        return @"HGBFileManageToolBundle.bundle/undefine.png";
    }








}
+(HGBFileType)getFileTypeWithFilePath:(NSString *)filePath{
    [HGBFileManageTool shareInstance];
    if(filePath==nil||filePath.length==0){
        return HGBFileTypeNull;
    }
    if([HGBFileManageTool isDirectoryAtPath:filePath]){
        return HGBFileTypeDirectory;
    }
    NSString *extention=[[filePath pathExtension] lowercaseString];

    NSArray *textTypeArr=@[@"txt",@"rtf",@"rtfd",@"html",@"css",@"js",@"xml",@"xmls",@"c",@"h",@"cpp",@"hpp",@"m",@"java",@"py",@"json"];
    NSArray *wordTypeArr=@[@"doc",@"docx"];
    NSArray *excelTypeArr=@[@"xls",@"xlsx"];
    NSArray *pptTypeArr=@[@"ppt",@"pptx"];
    NSArray *pdfTypeArr=@[@"pdf"];
    NSArray *imageTypeArr=@[@"jpg",@"jpeg",@"png",@"tiff",@"psd",@"swf",@"svg"];
    NSArray *audioTypeArr=@[@"wav",@"mod",@"st3",@"xt",@"s3m",@"far",@"669",@"mp3",@"ra",@"rm",@"rmx",@"cmf",@"cda",@"mid",@"vqf",@"wma",@"aac",@"m4a",@"mp1",@"mp2",@"mp3",@"aiff"];
    NSArray *videoTypeArr=@[@"avi",@"wma",@"rmvb",@"rm",@"flash",@"mp4",@"mid",@"3gp"];
    NSArray *compressTypeArr=@[@"zip",@"rar",@"7z",@"gz",@"bz",@"ace",@"uha",@"uda",@"zpaq"];
    NSArray *bundleTypeArr=@[@"bundle",@"framework"];
    if([textTypeArr containsObject:extention]){
        return HGBFileTypeText;
    }else if ([wordTypeArr containsObject:extention]){
        return HGBFileTypeWord;
    }else if ([excelTypeArr containsObject:extention]){
        return HGBFileTypeExcel;
    }else if ([pptTypeArr containsObject:extention]){
        return HGBFileTypePowerPoint;
    }else if ([pdfTypeArr containsObject:extention]){
        return HGBFileTypePDF;
    }else if ([imageTypeArr containsObject:extention]){
        return HGBFileTypeImage;
    }else if ([audioTypeArr containsObject:extention]){
        return HGBFileTypeAudio;
    }else if ([videoTypeArr containsObject:extention]){
        return HGBFileTypeVideo;
    }else if ([compressTypeArr containsObject:extention]){
        return HGBFileTypeCompress;
    }else if ([bundleTypeArr containsObject:extention]){
        return HGBFileTypeBundle;
    }else{
        return HGBFileTypeUnknown;
    }
}
/**
 获取文件信息

 @param filePath 文件路径
 @return 文件信息
 */
+(NSString *)getFileInfoWithFilePath:(NSString *)filePath{
    [HGBFileManageTool shareInstance];
    if ([HGBFileManageTool isDirectoryAtPath:filePath]){
        NSArray *filePaths=[HGBFileManageTool getDirectSubPathsInDirectoryPath:filePath];
        NSInteger fileNum=0,directoryNum=0;
        for(NSString *fpath in filePaths){
            NSString  *path=[filePath stringByAppendingPathComponent:fpath];
            if([[path lastPathComponent] containsString:@"DS_Store"]){
                continue;
            }
            if([[path lastPathComponent] containsString:@"metadata"]){
                continue;
            }
            if([path containsString:[[HGBFileManageTool getTmpFilePath] stringByAppendingPathComponent:@"pastBord_huang"]]){
                continue;
            }
            if([HGBFileManageTool isDirectoryAtPath:path]){
                directoryNum++;
            }else{
                fileNum++;
            }
        }
        NSString *fileInfo=[NSString stringWithFormat:@"文件夹:%zd 文件:%zd",directoryNum,fileNum];
        return fileInfo;

    }else{
        NSDictionary *info=[HGBFileManageTool getFileInfoFromFilePath:filePath];
        NSString *createTime=info[@"NSFileCreationDate"];
        NSString *size=[HGBFileManageTool getFileSizeWithFilPath:filePath];
        NSString *fileInfo=[NSString stringWithFormat:@"%@ %@",createTime,size];
        return fileInfo;
        
    }

}

/**
 获取文件大小

 @param filePath 文件路径
 @return 文件大小
 */
+(NSString *)getFileSizeWithFilPath:(NSString *)filePath{
    [HGBFileManageTool shareInstance];
    NSData *data=[NSData dataWithContentsOfFile:filePath];
    NSString *fileSize;
    CGFloat size;
    if(data.length<1024){
        size=data.length;
        fileSize=[NSString stringWithFormat:@"%.1fB",size];
    }else if((data.length/1024)<1024){
        size=((CGFloat )data.length)/1024.0;
        fileSize=[NSString stringWithFormat:@"%.1fKB",size];
    }else if(((data.length/1024)/1024)<1024){
        size=(((CGFloat )data.length)/1024.0)/1024.0;
        fileSize=[NSString stringWithFormat:@"%.1fMB",size];
    }else if((((data.length/1024)/1024)/1024)<1024){
        size=((((CGFloat )data.length)/1024.0)/1024.0)/1024.0;
        fileSize=[NSString stringWithFormat:@"%.1fGB",size];
    }else{
        fileSize=[NSString stringWithFormat:@"%.1ld",(unsigned long)data.length];
    }

    return fileSize;
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
    NSString  *path_huang =[HGBFileManageTool getLibraryFilePath];
    path_huang=[path_huang stringByAppendingPathComponent:@"Preferences"];
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
#pragma mark 文件工具
/**
 文件拷贝

 @param srcPath 文件路径
 @param filePath 复制文件路径
 @return 结果
 */
+(BOOL)copyFilePath:(NSString *)srcPath ToPath:(NSString *)filePath{
    if(![HGBFileManageTool isExitAtFilePath:srcPath]){
        return NO;
    }
    NSString *directoryPath=[filePath stringByDeletingLastPathComponent];
    if(![HGBFileManageTool isExitAtFilePath:directoryPath]){
        [HGBFileManageTool createDirectoryPath:directoryPath];
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
    if(![HGBFileManageTool isExitAtFilePath:srcPath]){
        return NO;
    }
    NSString *directoryPath=[filePath stringByDeletingLastPathComponent];
    if(![HGBFileManageTool isExitAtFilePath:directoryPath]){
        [HGBFileManageTool createDirectoryPath:directoryPath];
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
/**
 创建文件

 @param filePath 路径
 @return 结果
 */
+(BOOL)createFileAtPath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return NO;
    }
    NSString *directoryPath=[filePath stringByDeletingLastPathComponent];
    if (![HGBFileManageTool isExitAtFilePath:directoryPath]) {
        [HGBFileManageTool createDirectoryPath:directoryPath];
    }
    NSString *string=@"";
    NSData *data=[string dataUsingEncoding:NSUTF8StringEncoding];
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL flag3=[filemanage createFileAtPath:filePath contents:data attributes:nil];
    if(flag3){
        return YES;
    }else{
        return NO;
    }

}

#pragma mark 文件夹

/**
 路径是不是文件夹

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
 创建文件夹

 @param directoryPath 路径
 @return 结果
 */
+(BOOL)createDirectoryPath:(NSString *)directoryPath{
    if([HGBFileManageTool isExitAtFilePath:directoryPath]){
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
    if(![HGBFileManageTool isExitAtFilePath:directoryPath]){
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
    if(![HGBFileManageTool isExitAtFilePath:directoryPath]){
        return nil;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    NSArray *paths=[filemanage subpathsAtPath:directoryPath];
    return paths;
}
/**
 文件清空

 @param filePath 路径
 @return 结果
 */
+(BOOL)clearStrorageAtFilePath:(NSString *)filePath{
    if(filePath&&filePath.length==0){
        return NO;
    }
    NSString *fileCopyPath=[filePath copy];
    if(![HGBFileManageTool isExitAtFilePath:fileCopyPath]){
        fileCopyPath=[[HGBFileManageTool getHomeFilePath] stringByAppendingPathComponent:filePath];
        if(![HGBFileManageTool isExitAtFilePath:fileCopyPath]){
            fileCopyPath=[[HGBFileManageTool getDocumentFilePath] stringByAppendingPathComponent:filePath];
            if(![HGBFileManageTool isExitAtFilePath:fileCopyPath]){
                return NO;
            }
        }

    }

    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:fileCopyPath];
    for (NSString *fileName in enumerator) {
        [[NSFileManager defaultManager] removeItemAtPath:[fileCopyPath stringByAppendingPathComponent:fileName] error:nil];
    }
    return YES;
}
/**
 获取文件信息

 @param filePath 文件路径
 @return 文件信息
 */
+(NSDictionary *)getFileInfoFromFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return nil;
    }
    if(![HGBFileManageTool isExitAtFilePath:filePath]){
        return nil;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    NSDictionary *infoDic=[filemanage attributesOfItemAtPath:filePath error:nil];
    return infoDic;
}
#pragma mark 获取当前控制器

/**
 获取当前控制器

 @return 当前控制器
 */
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [HGBFileManageTool findBestViewController:viewController];
}

/**
 寻找上层控制器

 @param vc 控制器
 @return 上层控制器
 */
+ (UIViewController *)findBestViewController:(UIViewController *)vc
{
    if (vc.presentedViewController) {
        // Return presented view controller
        return [HGBFileManageTool findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBFileManageTool findBestViewController:svc.viewControllers.lastObject];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBFileManageTool findBestViewController:svc.topViewController];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBFileManageTool findBestViewController:svc.selectedViewController];
        }else{
            return vc;
        }
    } else {
        return vc;
    }
}
#pragma mark get
-(NSMutableArray *)unDeleteableFiles{
    if(_unDeleteableFiles==nil){
        _unDeleteableFiles=[NSMutableArray array];
    }
    return _unDeleteableFiles;
}
@end
