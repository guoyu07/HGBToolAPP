//
//  HGBOutAppOpenFileTool.m
//  HelloCordova
//
//  Created by huangguangbao on 2017/7/19.
//
//

#import "HGBOutAppOpenFileTool.h"
#import <QuickLook/QuickLook.h>
#import <SafariServices/SafariServices.h>


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



@interface HGBOutAppOpenFileTool()<UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property (nonatomic, strong) UIViewController *parentViewController;
@property (nonatomic, strong) QLPreviewController *preViewController;

/**
 代理
 */
@property(assign,nonatomic)id<HGBOutAppOpenFileToolDelegate>delegate;
/**
 路径
 */
@property(strong,nonatomic)NSString *url;
/**
 失败提示
 */
@property(assign,nonatomic)BOOL withoutFailPrompt;
/**
 是否打开
 */
@property(assign,nonatomic)BOOL openFlag;
@end
@implementation HGBOutAppOpenFileTool
static HGBOutAppOpenFileTool *instance=nil;
#pragma mark init
+(instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBOutAppOpenFileTool alloc]init];
    }
    return instance;
}
#pragma mark 设置
/**
 设置代理

 @param delegate 代理
 */
+(void)setQuickLookDelegate:(id<HGBOutAppOpenFileToolDelegate>)delegate{
    [HGBOutAppOpenFileTool shareInstance];
    instance.delegate=delegate;
}
/**
 设置失败提示

 @param withoutFailPrompt 失败提示标志
 */
+(void)setQuickLookWithoutFailPrompt:(BOOL)withoutFailPrompt{
    [HGBOutAppOpenFileTool shareInstance];
    instance.withoutFailPrompt=withoutFailPrompt;
}
#pragma mark 打开文件
/**
 快速浏览文件

 @param path 路径
 @param parent 父控制器
 */
+(void)lookFileAtPath:(NSString *)path inParent:(UIViewController *)parent{
    if(path==nil||path.length==0){
        [[self shareInstance]lookFileAtUrl:nil inParent:parent];
    }else{
        NSString *url=[[NSURL fileURLWithPath:path]absoluteString];
        [[self shareInstance]lookFileAtUrl:url inParent:parent];
    }
   
}
/**
 快速浏览文件

 @param url 路径
 @param parent 父控制器
 */
+(void)lookFileAtUrl:(NSString *)url inParent:(UIViewController *)parent{
    [[self shareInstance]lookFileAtUrl:url inParent:parent];
}
/**
 使用外部app打开文件
 
 @param url 路径
 @param parent 父控制器
 */
-(void)lookFileAtUrl:(NSString *)url inParent:(UIViewController *)parent{

    self.parentViewController = parent;

    self.openFlag=NO;

    if(parent==nil){
        if (instance.delegate&&[instance.delegate respondsToSelector:@selector(outLook:didOpenFailedWithError:)]) {
            [instance.delegate outLook:instance didOpenFailedWithError:@{ReslutCode:@(HGBOutAppOpenFileToolErrorTypePath),ReslutMessage:@"parent不能为空"}];
        }
        [HGBOutAppOpenFileTool alertWithPrompt:@"parent不能为空"];

        return;
    }

    if(url==nil&&url.length==0){
        if (instance.delegate&&[instance.delegate respondsToSelector:@selector(outLook:didOpenFailedWithError:)]) {
            [instance.delegate outLook:instance didOpenFailedWithError:@{ReslutCode:@(HGBOutAppOpenFileToolErrorTypePath),ReslutMessage:@"url不能为空"}];
        }
        [HGBOutAppOpenFileTool alertWithPrompt:@"url不能为空"];
        return;
    }
    if([url containsString:@"http"]||[url containsString:@"https"]){
        if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]){
            if (instance.delegate&&[instance.delegate respondsToSelector:@selector(outLook:didOpenFailedWithError:)]) {
                [instance.delegate outLook:instance didOpenFailedWithError:@{ReslutCode:@(HGBOutAppOpenFileToolErrorTypePath),ReslutMessage:@"url无法打开"}];
            }
            [HGBOutAppOpenFileTool alertWithPrompt:@"url无法打开"];

            return;
        }
    }else{
        NSString *path=[[NSURL URLWithString:url] path];
        path=[HGBOutAppOpenFileTool getCompletePathFromSimplifyFilePath:path];
        if(![HGBOutAppOpenFileTool isExitAtFilePath:path]){
            if (instance.delegate&&[instance.delegate respondsToSelector:@selector(outLook:didOpenFailedWithError:)]) {
                [instance.delegate outLook:instance didOpenFailedWithError:@{ReslutCode:@(HGBOutAppOpenFileToolErrorTypePath),ReslutMessage:@"文件不存在"}];
            }
            [HGBOutAppOpenFileTool alertWithPrompt:@"文件不存在"];

            return;
        }
        url=[[NSURL fileURLWithPath:path] absoluteString];


    }


    
    _documentController =[UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:url]];
    
    _documentController.delegate = self;
    
    
    
    //[_documentController presentOpenInMenuFromRect:CGRectZero
    //
    //										inView:parent.view
    //
    //									  animated:YES];
    
    //[_documentController presentPreviewAnimated:YES];
    
    [_documentController presentOptionsMenuFromRect:parent.view.bounds inView:parent.view animated:YES];

    
}



#pragma mark delegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self.parentViewController;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller{
    return self.preViewController.view.frame;
}
- (nullable UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{
    return self.preViewController.view;
}

/**
 *  文件分享面板弹出的时候调用
 */
- (void)documentInteractionControllerWillPresentOptionsMenu:(UIDocumentInteractionController *)controller{
    NSLog(@"WillPresentOptionsMenu");
    
}
- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller{
    NSLog(@"DidDismissOptionsMenu");
    if(self.openFlag==YES){
        if (self.delegate&&[self.delegate respondsToSelector:@selector(outLookDidClose:)]) {
            [self.delegate outLookDidClose:self];
        }
    }
    [self performSelector:@selector(cancelHandle) withObject:nil afterDelay:0.9];

}
-(void)cancelHandle{
    if(self.openFlag==NO){
        if (instance.delegate&&[instance.delegate respondsToSelector:@selector(outLookDidCanceled:)]) {
            [instance.delegate outLookDidCanceled:instance];
        }
    }
}
/**
 *  当选择一个文件分享App的时候调用
 */
- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(nullable NSString *)application {
    NSLog(@"begin send : %@", application);
    self.openFlag=YES;
    if (instance.delegate&&[instance.delegate respondsToSelector:@selector(outLookDidOpenSucessed:)]) {
        [instance.delegate outLookDidOpenSucessed:instance];
    }
}
-(void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application{
    NSLog(@"did send : %@", application);

}
#pragma mark 获取文件完整路径

/**
 将简化路径转化为完整路径

 @param simplifyFilePath 简化路径
 @return 完整路径
 */
+(NSString *)getCompletePathFromSimplifyFilePath:(NSString *)simplifyFilePath{
    NSString *path=[simplifyFilePath copy];
    if(![HGBOutAppOpenFileTool isExitAtFilePath:path]){
         path=[[HGBOutAppOpenFileTool getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
        if(![HGBOutAppOpenFileTool isExitAtFilePath:path]){

             path=[[HGBOutAppOpenFileTool getDocumentFilePath] stringByAppendingPathComponent:simplifyFilePath];
            if(![HGBOutAppOpenFileTool isExitAtFilePath:path]){
                path=[[HGBOutAppOpenFileTool getMainBundlePath] stringByAppendingPathComponent:simplifyFilePath];
                if(![HGBOutAppOpenFileTool isExitAtFilePath:path]){
                    path=simplifyFilePath;
                }

            }

        }

    }
    return path;
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
    if(![HGBOutAppOpenFileTool isExitAtFilePath:srcPath]){
        return NO;
    }
    NSString *directoryPath=[filePath stringByDeletingLastPathComponent];
    if(![HGBOutAppOpenFileTool isExitAtFilePath:directoryPath]){
        [HGBOutAppOpenFileTool createDirectoryPath:directoryPath];
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
    if([HGBOutAppOpenFileTool isExitAtFilePath:directoryPath]){
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
#pragma mark 提示
+(void)alertWithPrompt:(NSString *)prompt{
//    if(instance==nil||instance.withoutFailPrompt==YES){
//        return;
//    }
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [[HGBOutAppOpenFileTool currentViewController] presentViewController:alert animated:YES completion:nil];
#else
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:prompt delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
#endif
}
#pragma mark 获取当前控制器

/**
 获取当前控制器

 @return 当前控制器
 */
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [HGBOutAppOpenFileTool findBestViewController:viewController];
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
        return [HGBOutAppOpenFileTool findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBOutAppOpenFileTool findBestViewController:svc.viewControllers.lastObject];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBOutAppOpenFileTool findBestViewController:svc.topViewController];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBOutAppOpenFileTool findBestViewController:svc.selectedViewController];
        }else{
            return vc;
        }
    } else {
        return vc;
    }
}
@end

