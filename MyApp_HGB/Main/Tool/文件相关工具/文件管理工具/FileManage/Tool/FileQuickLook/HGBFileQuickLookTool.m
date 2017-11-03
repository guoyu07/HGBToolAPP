//
//  HGBFileQuickLookTool.m
//  测试
//
//  Created by huangguangbao on 2017/8/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBFileQuickLookTool.h"
#import <QuickLook/QuickLook.h>
#import <QuartzCore/QuartzCore.h>

#import "HGBFileOutAppOpenFileTool.h"




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


@interface HGBFileQuickLookTool ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>
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
@property(assign,nonatomic)id<HGBFileQuickLookToolDelegate>delegate;
/**
 路径
 */
@property(strong,nonatomic)NSString *url;
/**
 失败提示
 */
@property(assign,nonatomic)BOOL withoutFailPrompt;
@end

@implementation HGBFileQuickLookTool
static HGBFileQuickLookTool *instance;
#pragma mark init
+ (instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBFileQuickLookTool alloc]init];
    }
    return instance;
}
#pragma mark 设置
/**
 设置代理

 @param delegate 代理
 */
+(void)setQuickLookDelegate:(id<HGBFileQuickLookToolDelegate>)delegate{
    [HGBFileQuickLookTool shareInstance];
    instance.delegate=delegate;
}
/**
 设置失败提示

 @param withoutFailPrompt 失败提示标志
 */
+(void)setQuickLookWithoutFailPrompt:(BOOL)withoutFailPrompt{
    [HGBFileQuickLookTool shareInstance];
    instance.withoutFailPrompt=withoutFailPrompt;
}
#pragma mark 打开文件
/**
 快速浏览文件

 @param path 路径
 @param parent 父控制器
 */
+(void)lookFileAtPath:(NSString *)path inParent:(UIViewController *)parent{
    [HGBFileQuickLookTool shareInstance];
    if(parent==nil){
        [HGBFileQuickLookTool alertWithPrompt:@"parent不能为空"];
        if (instance.delegate&&[instance.delegate respondsToSelector:@selector(quickLookDidOpenFailed:)]) {
            [instance.delegate quickLookDidOpenFailed:instance];
        }
        return;
    }
    if(path==nil&&path.length==0){
        [HGBFileQuickLookTool alertWithPrompt:@"路径不能为空"];
        if (instance.delegate&&[instance.delegate respondsToSelector:@selector(quickLookDidOpenFailed:)]) {
            [instance.delegate quickLookDidOpenFailed:instance];
        }
        return;
    }
    [HGBFileQuickLookTool lookFileAtUrl:[[NSURL fileURLWithPath:path] absoluteString] inParent:parent];
}


/**
 快速浏览文件

 @param url 路径
 @param parent 父控制器
 */
+(void)lookFileAtUrl:(NSString *)url inParent:(UIViewController *)parent{
    [HGBFileQuickLookTool shareInstance];
    if(parent==nil){
        [HGBFileQuickLookTool alertWithPrompt:@"parent不能为空"];
        if (instance.delegate&&[instance.delegate respondsToSelector:@selector(quickLookDidOpenFailed:)]) {
            [instance.delegate quickLookDidOpenFailed:instance];
        }
        return;
    }
    if(url==nil&&url.length==0){
        [HGBFileQuickLookTool alertWithPrompt:@"url不能为空"];
        if (instance.delegate&&[instance.delegate respondsToSelector:@selector(quickLookDidOpenFailed:)]) {
            [instance.delegate quickLookDidOpenFailed:instance];
        }
        return;
    }
    if([url containsString:@"http"]||[url containsString:@"https"]){
        if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]){
            [HGBFileQuickLookTool alertWithPrompt:@"url无法发开"];
            if (instance.delegate&&[instance.delegate respondsToSelector:@selector(quickLookDidOpenFailed:)]) {
                [instance.delegate quickLookDidOpenFailed:instance];
            }
            return;
        }
    }else{
        if(![HGBFileQuickLookTool isExitAtFilePath:[[NSURL URLWithString:url] path]]){
            [HGBFileQuickLookTool alertWithPrompt:@"文件不存在"];
            if (instance.delegate&&[instance.delegate respondsToSelector:@selector(quickLookDidOpenFailed:)]) {
                [instance.delegate quickLookDidOpenFailed:instance];
            }
            return;
        }
    }

    instance.parent=parent;
    instance.url=url;
    instance.quickLookController = [[QLPreviewController alloc] init];
    instance.quickLookController.dataSource = instance;
    instance.quickLookController.delegate=instance;
     //导航栏
    instance.quickLookController.navigationController.navigationBar.barTintColor=[UIColor orangeColor];
    instance.quickLookController.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"HGBFileManageToolBundle.bundle/icon_threepoint.png"] style:(UIBarButtonItemStylePlain) target:instance action:@selector(openWithOtherType)];


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
#pragma mark 其他方式打开
-(void)openWithOtherType{
    NSLog(@"11");
    [HGBFileOutAppOpenFileTool openFileWithExetenAppWithUrl:self.url inParent:self.quickLookController andWithCompleteBlock:^(NSInteger status) {
    }];
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
    [[HGBFileQuickLookTool currentViewController] presentViewController:alert animated:YES completion:nil];
#else
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:prompt delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
#endif

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

#pragma mark 获取当前控制器

/**
 获取当前控制器

 @return 当前控制器
 */
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [HGBFileQuickLookTool findBestViewController:viewController];
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
        return [HGBFileQuickLookTool findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBFileQuickLookTool findBestViewController:svc.viewControllers.lastObject];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBFileQuickLookTool findBestViewController:svc.topViewController];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBFileQuickLookTool findBestViewController:svc.selectedViewController];
        }else{
            return vc;
        }
    } else {
        return vc;
    }
}
@end
