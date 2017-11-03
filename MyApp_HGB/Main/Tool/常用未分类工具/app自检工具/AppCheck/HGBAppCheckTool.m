//
//  HGBAppCheckTool.m
//  HelloCordova
//
//  Created by huangguangbao on 2017/8/17.
//
//

#import "HGBAppCheckTool.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CommonCrypto/CommonDigest.h>

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

typedef void(^ SucessBlock)(void);

@interface HGBAppCheckTool()<UIAlertViewDelegate>
@property(strong,nonatomic)SucessBlock sucessBlock;

@end
@implementation HGBAppCheckTool
#pragma mark init
static HGBAppCheckTool *instance=nil;
+ (instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBAppCheckTool alloc]init];
    }
    return instance;
}
#pragma mark app自检
/**
 app自检
 */
+(void)appCheck{
    [HGBAppCheckTool shareInstance];
    NSString *appCodeSignatureData=[HGBAppCheckTool getAppCodeSignatureData];

    if(![appCodeSignatureData isEqualToString:@"58957e7dc99ab2f96d893d9ad0fa83f8fd31d306"]){

        [HGBAppCheckTool alertPromptWithTitle:@"版权提示" Detail:@"您使用的APP非正版,请下载正版使用!" andWithSucessBlock:^{
            [[UIApplication sharedApplication]setIdleTimerDisabled:NO];
            exit(0);
        } InParent:[HGBAppCheckTool currentViewController]];



    }
}
#pragma mark 获取app数据
/**
 获取签名证书加密数据

 @return 签名证书加密数据
 */
+ (NSString *)getAppCodeSignatureData
{
    NSString *sourcePath =[HGBAppCheckTool getAppCodeSignaturePath];
    NSData *sourceData=[[NSData alloc]initWithContentsOfFile:sourcePath];
    NSString *sourceDataString=[[NSString alloc]initWithData:sourceData encoding:NSASCIIStringEncoding];
    NSLog(@"%@",sourceDataString);
    NSString *sourceDataEncryptString=[HGBAppCheckTool encryptStringWithsha1:sourceDataString];
    return sourceDataEncryptString;
}

/**
 获取资源文件数据

 @return 资源文件数据
 */
+ (NSString *)getAppBinaryData
{
    NSString *sourcePath =[HGBAppCheckTool getAppBinaryPath];
    NSData *sourceData=[[NSData alloc]initWithContentsOfFile:sourcePath];
    NSString *sourceDataString=[[NSString alloc]initWithData:sourceData encoding:NSASCIIStringEncoding];
    NSLog(@"%@",sourceDataString);
    NSString *sourceDataEncryptString=[HGBAppCheckTool encryptStringWithsha1:sourceDataString];
    return sourceDataEncryptString;
}
#pragma mark 检包路径获取

/**
 获取签名证书路径

 @return 签名证书路径
 */
+ (NSString *)getAppCodeSignaturePath
{
//    NSString *excutableName = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
//    NSString *docPath = [HGBAppCheckTool getDocumentFilePath];
//    NSString *appPath = [[docPath stringByAppendingPathComponent:excutableName]stringByAppendingPathExtension:@"app"];
//    NSString *codeSignaturePath = [[appPath stringByAppendingPathComponent:@"_CodeSignature"]stringByAppendingPathComponent:@"CodeResources"];

    NSString *bundlePath=[[NSBundle mainBundle]resourcePath];
    NSString *appCodeSignaturePath=[bundlePath stringByAppendingPathComponent:@"_CodeSignature/CodeResources"];
    NSLog(@"%@",appCodeSignaturePath);
    return appCodeSignaturePath;
}

/**
 获取资源文件路径

 @return 资源文件路径
 */
+ (NSString *)getAppBinaryPath
{
//    NSString *excutableName = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
//    NSString *docPath = [HGBAppCheckTool getDocumentFilePath];
//    NSString *appPath = [[docPath stringByAppendingPathComponent:excutableName] stringByAppendingPathExtension:@"app"];
//    NSString *binaryPath = [appPath stringByAppendingPathComponent:excutableName];
    NSString *bundlePath=[[NSBundle mainBundle]resourcePath];

    NSLog(@"%@",bundlePath);
    return bundlePath;
}
#pragma mark 提示
/**
 展示内容

 @param prompt 提示
 */
+(void)alertWithPrompt:(NSString *)prompt{
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [[HGBAppCheckTool currentViewController] presentViewController:alert animated:YES completion:nil];
#else
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:prompt delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
#endif

}
/**
 *  单键-功能－标题
 *
 *  @param title    提示标题
 *  @param detail     提示详情
 *
 *  @param sucessBlock 成功返回
 *  @param parent 父控件
 */
+(void)alertPromptWithTitle:(NSString *)title Detail:(NSString *)detail andWithSucessBlock:(SucessBlock)sucessBlock InParent:(UIViewController *)parent
{
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:detail preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        sucessBlock();
    }];
    [alert addAction:action1];
    [parent presentViewController:alert animated:YES completion:nil];
#else
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title message:detail delegate:instance cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
#endif

}
#ifdef KiOS8Later
#else
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(instance.sucessBlock){
        instance.sucessBlock();
    }
}
#endif

#pragma mark 获取当前控制器

/**
 获取当前控制器

 @return 当前控制器
 */
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [HGBAppCheckTool findBestViewController:viewController];
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
        return [HGBAppCheckTool findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBAppCheckTool findBestViewController:svc.viewControllers.lastObject];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBAppCheckTool findBestViewController:svc.topViewController];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBAppCheckTool findBestViewController:svc.selectedViewController];
        }else{
            return vc;
        }
    } else {
        return vc;
    }
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
    NSString  *path_huang =[NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory,NSUserDomainMask,YES) lastObject];
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
#pragma mark sha1加密
/**
 *  sha1加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)encryptStringWithsha1:(NSString*)string
{
    if(string==nil){
        return nil;
    }
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (int)data.length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;

}

@end
