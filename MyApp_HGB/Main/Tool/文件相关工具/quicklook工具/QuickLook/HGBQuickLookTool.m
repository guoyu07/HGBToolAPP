//
//  HGBQuickLookTool.m
//  测试
//
//  Created by huangguangbao on 2017/8/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBQuickLookTool.h"
#import <QuickLook/QuickLook.h>
#import <QuartzCore/QuartzCore.h>

#ifndef SYSTEM_VERSION
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号

#endif

#ifndef KiOS6Later
#define KiOS6Later (SYSTEM_VERSION >= 6)
#endif

#ifndef KiOS7Later
#define KiOS7Later (SYSTEM_VERSION >= 7)
#endif

#ifndef KiOS8Later
#define KiOS8Later (SYSTEM_VERSION >= 8)
#endif

#ifndef KiOS9Later
#define KiOS9Later (SYSTEM_VERSION >= 9)
#endif

#ifndef KiOS10Later
#define KiOS10Later (SYSTEM_VERSION >= 10)
#endif

#define ReslutCode @"reslutCode"
#define ReslutMessage @"reslutMessage"

@interface HGBQuickLookTool ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>
/**
 浏览器
 */
@property (nonatomic,strong) QLPreviewController *quickLookController;
/**
 父控制器
 */
@property(strong,nonatomic)UIViewController *parent;
/**
 代理
 */
@property(assign,nonatomic)id<HGBQuickLookToolDelegate>delegate;
/**
 路径
 */
@property(strong,nonatomic)NSString *url;
/**
 失败提示
 */
@property(assign,nonatomic)BOOL withoutFailPrompt;
@end


@implementation HGBQuickLookTool
static HGBQuickLookTool *instance;
#pragma mark init
+ (instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBQuickLookTool alloc]init];
    }
    return instance;
}
#pragma mark 设置
/**
 设置代理

 @param delegate 代理
 */
+(void)setQuickLookDelegate:(id<HGBQuickLookToolDelegate>)delegate{
    [HGBQuickLookTool shareInstance];
    instance.delegate=delegate;
}
/**
 设置失败提示

 @param withoutFailPrompt 失败提示标志
 */
+(void)setQuickLookWithoutFailPrompt:(BOOL)withoutFailPrompt{
    [HGBQuickLookTool shareInstance];
    instance.withoutFailPrompt=withoutFailPrompt;
}
#pragma mark 打开文件
/**
 快速浏览文件

 @param path 路径
 @param parent 父控制器
 */
+(void)lookFileAtPath:(NSString *)path inParent:(UIViewController *)parent{
    [HGBQuickLookTool shareInstance];
    if(parent==nil){
        if (instance.delegate&&[instance.delegate respondsToSelector:@selector(quickLook:didOpenFailedWithError:)]) {
            [instance.delegate quickLook:instance didOpenFailedWithError:@{ReslutCode:@(HGBQuickLookToolErrorTypePath),ReslutMessage:@"路径不能为空"}];
        }
        [HGBQuickLookTool alertWithPrompt:@"parent不能为空"];

        return;
    }
    if(path==nil&&path.length==0){
        if (instance.delegate&&[instance.delegate respondsToSelector:@selector(quickLook:didOpenFailedWithError:)]) {
            [instance.delegate quickLook:instance didOpenFailedWithError:@{ReslutCode:@(HGBQuickLookToolErrorTypePath),ReslutMessage:@"路径不能为空"}];
        }
        [HGBQuickLookTool alertWithPrompt:@"路径不能为空"];

        return;
    }
    [HGBQuickLookTool lookFileAtUrl:[[NSURL fileURLWithPath:path] absoluteString] inParent:parent];
}


/**
 快速浏览文件

 @param url 路径
 @param parent 父控制器
 */
+(void)lookFileAtUrl:(NSString *)url inParent:(UIViewController *)parent{
    [HGBQuickLookTool shareInstance];
    if(parent==nil){
        if (instance.delegate&&[instance.delegate respondsToSelector:@selector(quickLook:didOpenFailedWithError:)]) {
            [instance.delegate quickLook:instance didOpenFailedWithError:@{ReslutCode:@(HGBQuickLookToolErrorTypePath),ReslutMessage:@"parent不能为空"}];
        }
        [HGBQuickLookTool alertWithPrompt:@"parent不能为空"];

        return;
    }
    if(url==nil&&url.length==0){
        if (instance.delegate&&[instance.delegate respondsToSelector:@selector(quickLook:didOpenFailedWithError:)]) {
            [instance.delegate quickLook:instance didOpenFailedWithError:@{ReslutCode:@(HGBQuickLookToolErrorTypePath),ReslutMessage:@"url不能为空"}];
        }
        [HGBQuickLookTool alertWithPrompt:@"url不能为空"];

        return;
    }
    if([url containsString:@"http"]||[url containsString:@"https"]){
        if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]){
            if (instance.delegate&&[instance.delegate respondsToSelector:@selector(quickLook:didOpenFailedWithError:)]) {
                [instance.delegate quickLook:instance didOpenFailedWithError:@{ReslutCode:@(HGBQuickLookToolErrorTypePath),ReslutMessage:@"url无法发开"}];
            }
            [HGBQuickLookTool alertWithPrompt:@"url无法发开"];

            return;
        }
    }else{
        NSString *path=[[NSURL URLWithString:url] path];
        path=[HGBQuickLookTool getCompletePathFromSimplifyFilePath:path];
        if(![HGBQuickLookTool isExitAtFilePath:path]){
            if (instance.delegate&&[instance.delegate respondsToSelector:@selector(quickLook:didOpenFailedWithError:)]) {
                [instance.delegate quickLook:instance didOpenFailedWithError:@{ReslutCode:@(HGBQuickLookToolErrorTypePath),ReslutMessage:@"文件不存在"}];
            }
            [HGBQuickLookTool alertWithPrompt:@"文件不存在"];

            return;
        }
        url=[[NSURL fileURLWithPath:path] absoluteString];
    }







    instance.parent=parent;
    instance.url=url;
    instance.quickLookController = [[QLPreviewController alloc] init];
    instance.quickLookController.dataSource = instance;
    instance.quickLookController.delegate=instance;
    [parent presentViewController:instance.quickLookController animated:YES completion:nil];
    if (instance.delegate&&[instance.delegate respondsToSelector:@selector(quickLookDidOpenSucessed:)]) {
        [instance.delegate quickLookDidOpenSucessed:instance];
    }

}
#pragma mark - qlpreViewdataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}
//返回一个需要加载文件的URL
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    if(self.url==nil||self.url.length==0){

    }
    NSURL *myQLDocument = [NSURL URLWithString:self.url];

    return myQLDocument;
}
#pragma mark - qlpreViewDelegate
- (void)previewControllerWillDismiss:(QLPreviewController *)controller{
    NSLog(@"WillDismiss");
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller{
    NSLog(@"DidDismiss");
    if (self.delegate&&[self.delegate respondsToSelector:@selector(quickLookDidClose:)]) {
        [self.delegate quickLookDidClose:self];
    }
}

- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item{
    NSLog(@"open");
    return YES;
}

#pragma mark 提示
+(void)alertWithPrompt:(NSString *)prompt{
    if(instance==nil||instance.withoutFailPrompt==YES){
        return;
    }
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [[HGBQuickLookTool currentViewController] presentViewController:alert animated:YES completion:nil];
#else
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:prompt delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
#endif
}
#pragma mark 获取文件完整路径

/**
 将简化路径转化为完整路径

 @param simplifyFilePath 简化路径
 @return 完整路径
 */
+(NSString *)getCompletePathFromSimplifyFilePath:(NSString *)simplifyFilePath{
    NSString *path=[simplifyFilePath copy];
    if(![HGBQuickLookTool isExitAtFilePath:path]){
        path=[[HGBQuickLookTool getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
        if(![HGBQuickLookTool isExitAtFilePath:path]){
            path=[[HGBQuickLookTool getDocumentFilePath] stringByAppendingPathComponent:simplifyFilePath];
            if(![HGBQuickLookTool isExitAtFilePath:path]){
                 path=[[HGBQuickLookTool getMainBundlePath] stringByAppendingPathComponent:simplifyFilePath];
                if(![HGBQuickLookTool isExitAtFilePath:path]){
                    path=simplifyFilePath;
                }

            }
            
        }
        
    }
    return path;
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
 文件拷贝

 @param srcPath 文件路径
 @param filePath 复制文件路径
 @return 结果
 */
+(BOOL)copyFilePath:(NSString *)srcPath ToPath:(NSString *)filePath{
    if(![HGBQuickLookTool isExitAtFilePath:srcPath]){
        return NO;
    }
    NSString *directoryPath=[filePath stringByDeletingLastPathComponent];
    if(![HGBQuickLookTool isExitAtFilePath:directoryPath]){
        [HGBQuickLookTool createDirectoryPath:directoryPath];
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
 创建文件夹

 @param directoryPath 路径
 @return 结果
 */
+(BOOL)createDirectoryPath:(NSString *)directoryPath{
    if([HGBQuickLookTool isExitAtFilePath:directoryPath]){
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
 删除文档

 @param filePath 文件路径
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
#pragma mark 获取当前控制器

/**
 获取当前控制器

 @return 当前控制器
 */
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [HGBQuickLookTool findBestViewController:viewController];
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
        return [HGBQuickLookTool findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBQuickLookTool findBestViewController:svc.viewControllers.lastObject];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBQuickLookTool findBestViewController:svc.topViewController];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBQuickLookTool findBestViewController:svc.selectedViewController];
        }else{
            return vc;
        }
    } else {
        return vc;
    }
}
@end
