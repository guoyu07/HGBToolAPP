
//
//  HGBHTMLToPDFTool.m
//  测试
//
//  Created by huangguangbao on 2017/8/28.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBHTMLToPDFTool.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height

//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
#define VERSION 8.0//界限版本号

#define ErrorCode @"errorCode"
#define ErrorMessage @"errorMessage"

@interface HGBHTMLToPDFTool()
/**
 失败提示
 */
@property(assign,nonatomic)BOOL withoutFailPrompt;
@end
@implementation HGBHTMLToPDFTool
static HGBHTMLToPDFTool *instance=nil;
#pragma mark init
/**
 单例

 @return 实例
 */
+ (instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBHTMLToPDFTool alloc]init];
    }
    return instance;
}
#pragma mark 设置

/**
 设置失败提示

 @param withoutFailPrompt 失败提示标志
 */
+(void)setQuickLookWithoutFailPrompt:(BOOL)withoutFailPrompt{
    [HGBHTMLToPDFTool shareInstance];
    instance.withoutFailPrompt=withoutFailPrompt;
}
#pragma mark 功能
/**
 通过HTML字符串创建PDF

 @param HTMLString HTML字符串
 @param PDFpath pdf路径
 @param compeleteBlock 完成回调

 */
+ (void)createPDFWithHTMLSting:(NSString*)HTMLString pathForPDF:(NSString*)PDFpath compeleteBlock:(HGBHTMLtoPDFToolCompletionBlock)compeleteBlock{
    [HGBHTMLToPDFTool shareInstance];
    NSString *dirPath=[PDFpath stringByDeletingLastPathComponent];
    if(![HGBHTMLToPDFTool isExitAtFilePath:dirPath]){
        [HGBHTMLToPDFTool createDirectoryPath:dirPath];
    }
    [HGBHTMLtoPDF createPDFWithHTML:HTMLString pathForPDF:PDFpath pageSize:basePageSize margins:UIEdgeInsetsMake(5, 5, 5, 5) successBlock:^(HGBHTMLtoPDF *htmlToPDF) {
        compeleteBlock(YES,@{});
    } errorBlock:^(HGBHTMLtoPDF *htmlToPDF) {
        compeleteBlock(NO,@{ErrorCode:@"0",ErrorMessage:@"转换失败"});
    }];
}
/**
 通过HTML字符串创建PDF

 @param HTMLPath HTML文件路径
 @param PDFpath pdf路径
 @param compeleteBlock 完成回调

 */
+ (void)createPDFWithHTMLPath:(NSString*)HTMLPath pathForPDF:(NSString*)PDFpath compeleteBlock:(HGBHTMLtoPDFToolCompletionBlock)compeleteBlock{
    [HGBHTMLToPDFTool shareInstance];
    if(HTMLPath==nil||HTMLPath.length==0){
        compeleteBlock(NO,@{ErrorCode:@"1",ErrorMessage:@"html文件路径不能为空"});
        return;
    }
    if(HTMLPath==nil||HTMLPath.length==0){
        PDFpath=[[HGBHTMLToPDFTool getDocumentFilePath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",[[HTMLPath lastPathComponent] stringByDeletingPathExtension]]];

    }
     PDFpath=[HGBHTMLToPDFTool getDestinationCompletePathFromSimplifyFilePath:PDFpath];
    [HGBHTMLToPDFTool createPDFWithHTMLUrl:[[NSURL fileURLWithPath:HTMLPath] absoluteString] pathForPDF:PDFpath compeleteBlock:^(BOOL status, NSDictionary *messageInfo) {
        compeleteBlock(status,messageInfo);
    }];

}

/**
 通过HTML字符串创建PDF

 @param HTMLUrl HTML URL
 @param PDFpath pdf路径
 @param compeleteBlock 完成回调

 */
+ (void)createPDFWithHTMLUrl:(NSString*)HTMLUrl pathForPDF:(NSString*)PDFpath compeleteBlock:(HGBHTMLtoPDFToolCompletionBlock)compeleteBlock{
    [HGBHTMLToPDFTool shareInstance];
    if(![HTMLUrl containsString:@"http"]){
        NSString *path=[[NSURL URLWithString:HTMLUrl] path];
        path=[HGBHTMLToPDFTool getCompletePathFromSimplifyFilePath:path];
        if(![HGBHTMLToPDFTool isExitAtFilePath:path]){
             compeleteBlock(NO,@{ErrorCode:@"1",ErrorMessage:@"html文件路径不存在"});
            return;
        }
        HTMLUrl=[[NSURL fileURLWithPath:path] absoluteString];
    }else{
        if(![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:HTMLUrl]]){
            compeleteBlock(NO,@{ErrorCode:@"1",ErrorMessage:@"html文件路径不存在"});
            return;
        }
    }
    NSString *htmlString=[[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:HTMLUrl] encoding:NSUTF8StringEncoding error:nil];
    [HGBHTMLToPDFTool createPDFWithHTMLSting:htmlString pathForPDF:PDFpath compeleteBlock:^(BOOL status, NSDictionary *messageInfo) {
        compeleteBlock(status,messageInfo);
    }];
}
#pragma mark 提示
/**
 展示内容

 @param prompt 提示
 */
+(void)alertWithPrompt:(NSString *)prompt{
    if(instance==nil||instance.withoutFailPrompt==YES){
        return;
    }
    if((SYSTEM_VERSION<VERSION)){
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:prompt delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertview show];
    }else{
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:action];
        [[HGBHTMLToPDFTool currentViewController] presentViewController:alert animated:YES completion:nil];
    }
}
#pragma mark 获取文件完整路径

/**
 将简化路径转化为完整路径

 @param simplifyFilePath 简化路径
 @return 完整路径
 */
+(NSString *)getCompletePathFromSimplifyFilePath:(NSString *)simplifyFilePath{
    NSString *path=[simplifyFilePath copy];
    if(![HGBHTMLToPDFTool isExitAtFilePath:path]){
        if(![HGBHTMLToPDFTool isExitAtFilePath:path]){
            path=[[HGBHTMLToPDFTool getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
            if(![HGBHTMLToPDFTool isExitAtFilePath:path]){
                path=[[HGBHTMLToPDFTool getDocumentFilePath] stringByAppendingPathComponent:simplifyFilePath];
                if(![HGBHTMLToPDFTool isExitAtFilePath:path]){
                    path=[[HGBHTMLToPDFTool getMainBundlePath] stringByAppendingPathComponent:simplifyFilePath];
                    if(![HGBHTMLToPDFTool isExitAtFilePath:path]){

                    }

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
    if(!([simplifyFilePath containsString:[HGBHTMLToPDFTool getHomeFilePath]]||[simplifyFilePath containsString:[HGBHTMLToPDFTool getMainBundlePath]])){
        simplifyFilePath=[[HGBHTMLToPDFTool getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
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
#pragma mark 文件
/**
 创建文件夹

 @param directoryPath 路径
 @return 结果
 */
+(BOOL)createDirectoryPath:(NSString *)directoryPath{
    if([HGBHTMLToPDFTool isExitAtFilePath:directoryPath]){
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

#pragma mark 获取当前控制器

/**
 获取当前控制器

 @return 当前控制器
 */
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [HGBHTMLToPDFTool findBestViewController:viewController];
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
        return [HGBHTMLToPDFTool findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBHTMLToPDFTool findBestViewController:svc.viewControllers.lastObject];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBHTMLToPDFTool findBestViewController:svc.topViewController];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBHTMLToPDFTool findBestViewController:svc.selectedViewController];
        }else{
            return vc;
        }
    } else {
        return vc;
    }
}
@end
