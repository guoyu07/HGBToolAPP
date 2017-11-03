//
//  HGBImageLookTool.m
//  测试
//
//  Created by huangguangbao on 2017/8/17.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBImageLookTool.h"
#import "HGBFileImageController.h"


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

@interface HGBImageLookTool ()<HGBFileImageControllerDelegate>
/**
 浏览器
 */
@property(strong,nonatomic)HGBFileImageController *imageVC;
/**
 父控制器
 */
@property(strong,nonatomic)UIViewController *parent;
/**
 代理
 */
@property(assign,nonatomic)id<HGBImageLookToolDelegate>delegate;
/**
 路径
 */
@property(strong,nonatomic)NSString *url;
/**
 失败提示
 */
@property(assign,nonatomic)BOOL withoutFailPrompt;
@end
@implementation HGBImageLookTool
static HGBImageLookTool *instance;
#pragma mark init
+ (instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBImageLookTool alloc]init];
    }
    return instance;
}
#pragma mark 设置
/**
 设置代理

 @param delegate 代理
 */
+(void)setWebLookDelegate:(id<HGBImageLookToolDelegate>)delegate{
    [HGBImageLookTool shareInstance];
    instance.delegate=delegate;
}
/**
 设置失败提示

 @param withoutFailPrompt 失败提示标志
 */
+(void)setWebLookWithoutFailPrompt:(BOOL)withoutFailPrompt{
    [HGBImageLookTool shareInstance];
    instance.withoutFailPrompt=withoutFailPrompt;
}
#pragma mark 打开文件
/**
 快速浏览文件

 @param path 路径
 @param parent 父控制器
 */
+(void)lookFileAtPath:(NSString *)path inParent:(UIViewController *)parent{
    [HGBImageLookTool shareInstance];
    if(parent==nil){
        [HGBImageLookTool alertWithPrompt:@"parent不能为空"];
        if (instance.delegate&&[instance.delegate respondsToSelector:@selector(imageLookDidOpenFailed:)]) {
            [instance.delegate imageLookDidOpenFailed:instance];
        }
        return;
    }
    if(path==nil&&path.length==0){
        [HGBImageLookTool alertWithPrompt:@"路径不能为空"];
        if (instance.delegate&&[instance.delegate respondsToSelector:@selector(imageLookDidOpenFailed:)]) {
            [instance.delegate imageLookDidOpenFailed:instance];
        }
        return;
    }
    [HGBImageLookTool lookFileAtUrl:[[NSURL fileURLWithPath:path] absoluteString] inParent:parent];
}

/**
 快速浏览文件

 @param url 路径
 @param parent 父控制器
 */
+(void)lookFileAtUrl:(NSString *)url inParent:(UIViewController *)parent{
    if(parent==nil){
        [HGBImageLookTool alertWithPrompt:@"parent不能为空"];
        if (instance.delegate&&[instance.delegate respondsToSelector:@selector(imageLookDidOpenFailed:)]) {
            [instance.delegate imageLookDidOpenFailed:instance];
        }
        return;
    }
    if(url==nil&&url.length==0){
        [HGBImageLookTool alertWithPrompt:@"url不能为空"];
        if (instance.delegate&&[instance.delegate respondsToSelector:@selector(imageLookDidOpenFailed:)]) {
            [instance.delegate imageLookDidOpenFailed:instance];
        }
        return;
    }
    if([url containsString:@"http"]||[url containsString:@"https"]){
        if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]){
            [HGBImageLookTool alertWithPrompt:@"url无法发开"];
            if (instance.delegate&&[instance.delegate respondsToSelector:@selector(imageLookDidOpenFailed:)]) {
                [instance.delegate imageLookDidOpenFailed:instance];
            }
            return;
        }
    }else{
        if(![HGBImageLookTool isExitAtFilePath:[[NSURL URLWithString:url] path]]){
            [HGBImageLookTool alertWithPrompt:@"文件不存在"];
            if (instance.delegate&&[instance.delegate respondsToSelector:@selector(imageLookDidOpenFailed:)]) {
                [instance.delegate imageLookDidOpenFailed:instance];
            }
            return;
        }
    }

    instance.parent=parent;
    instance.url=url;

    if (instance.delegate&&[instance.delegate respondsToSelector:@selector(imageLookDidOpenSucessed:)]) {
        [instance.delegate imageLookDidOpenSucessed:instance];
    }
    instance.imageVC=[[HGBFileImageController alloc]init];
    instance.imageVC.url=url;
    instance.imageVC.delegate=instance;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:instance.imageVC];
    [parent presentViewController:nav animated:YES completion:nil];
}
-(void)fileImageControllerDidClosed{
    if (instance.delegate&&[instance.delegate respondsToSelector:@selector(imageLookDidClose:)]) {
        [instance.delegate imageLookDidClose:instance];
    }
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
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [[HGBImageLookTool currentViewController] presentViewController:alert animated:YES completion:nil];
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
    return [HGBImageLookTool findBestViewController:viewController];
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
        return [HGBImageLookTool findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBImageLookTool findBestViewController:svc.viewControllers.lastObject];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBImageLookTool findBestViewController:svc.topViewController];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBImageLookTool findBestViewController:svc.selectedViewController];
        }else{
            return vc;
        }
    } else {
        return vc;
    }
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
@end
