//
//  HGBImageToPDFTool.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/31.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBImageToPDFTool.h"
@interface HGBImageToPDFTool ()
@property(strong,nonatomic)id<HGBImageToPDFToolDelegate>delegate;
@end
@implementation HGBImageToPDFTool
#pragma mark init
static HGBImageToPDFTool *instance=nil;
+(instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBImageToPDFTool alloc]init];
    }
    return instance;
}
#pragma mark func
void HGBDrawContent(CGContextRef myContext, CFDataRef data,CGRect rect)
{
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(data);
    CGImageRef image = CGImageCreateWithJPEGDataProvider(dataProvider,NULL,NO,kCGRenderingIntentDefault);
    CGContextDrawImage(myContext, rect, image);
    CGDataProviderRelease(dataProvider);
    CGImageRelease(image);
}
void HGBCreatePDFFile (CFDataRef data,CGRect pageRect,const char *filepath, CFStringRef password)
{
    CGContextRef pdfContext;
    CFStringRef path;
    CFURLRef url;
    CFDataRef boxData = NULL;
    CFMutableDictionaryRef myDictionary = NULL;
    CFMutableDictionaryRef pageDictionary = NULL;

    path = CFStringCreateWithCString (NULL, filepath,kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath (NULL, path,kCFURLPOSIXPathStyle, 0);
    CFRelease (path);
    myDictionary = CFDictionaryCreateMutable(NULL,0,&kCFTypeDictionaryKeyCallBacks,&kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(myDictionary,kCGPDFContextTitle, CFSTR("Photo from iPrivate Album"));
    CFDictionarySetValue(myDictionary,kCGPDFContextCreator,CFSTR("iPrivate Album"));
    if (password) {
        CFDictionarySetValue(myDictionary, kCGPDFContextUserPassword, password);
        CFDictionarySetValue(myDictionary, kCGPDFContextOwnerPassword, password);
    }
    pdfContext = CGPDFContextCreateWithURL (url, &pageRect, myDictionary);
    CFRelease(myDictionary);
    CFRelease(url);
    pageDictionary = CFDictionaryCreateMutable(NULL,0,&kCFTypeDictionaryKeyCallBacks,&kCFTypeDictionaryValueCallBacks);
    boxData = CFDataCreate(NULL,(const UInt8 *)&pageRect, sizeof (CGRect));
    CFDictionarySetValue(pageDictionary, kCGPDFContextMediaBox, boxData);
    CGPDFContextBeginPage (pdfContext, pageDictionary);
   HGBDrawContent(pdfContext,data,pageRect);
    CGPDFContextEndPage (pdfContext);


    CGContextRelease (pdfContext);
    CFRelease(pageDictionary);
    CFRelease(boxData);
    if(instance.delegate&&[instance.delegate respondsToSelector:@selector(ImageToPDFDidSucceed:)]){
        [instance.delegate ImageToPDFDidSucceed:instance];
    }
}
/**
 *  @brief  抛出pdf文件存放地址
 *
 *  @param  filename    NSString型 文件名
 *
 *  @return NSString型 地址
 */
+ (NSString *)pdfDestPath:(NSString *)filename{
    return [HGBImageToPDFTool getDestinationCompletePathFromSimplifyFilePath:filename];;
}
/**
 *  @brief  创建PDF文件
 *
 *  @param  image        图片
 *  @param  destFilePath    PDF文件路径
 *  @param  password        要设定的密码
 */
+ (void)createPDFFileWithImage:(UIImage *)image toDestFilePath:(NSString *)destFilePath withPassword:(NSString *)password delegate:(id<HGBImageToPDFToolDelegate>)delegate
{
    [HGBImageToPDFTool shareInstance].delegate=delegate;
    if(image==nil){
        NSLog(@"图片不能为空");
        if(instance.delegate&&[instance.delegate respondsToSelector:@selector(ImageToPDFDidFail:)]){
            [instance.delegate ImageToPDFDidFail:instance];
        }
        return;
    }
    NSString *fileFullPath = [HGBImageToPDFTool getDestinationCompletePathFromSimplifyFilePath:destFilePath];
    instance.PDFpath=fileFullPath;
    const char *path = [fileFullPath UTF8String];
    NSData *imgData=UIImagePNGRepresentation(image);
    CFDataRef data = (__bridge CFDataRef)imgData;
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CFStringRef pw = (__bridge CFStringRef)password;
    HGBCreatePDFFile(data,rect, path,pw);
}
#pragma mark 获取文件完整路径

/**
 将简化路径转化为完整路径

 @param simplifyFilePath 简化路径
 @return 完整路径
 */
+(NSString *)getCompletePathFromSimplifyFilePath:(NSString *)simplifyFilePath{
    NSString *path=[simplifyFilePath copy];
    if(![HGBImageToPDFTool isExitAtFilePath:path]){
        if(![HGBImageToPDFTool isExitAtFilePath:path]){
            path=[[HGBImageToPDFTool getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
            if(![HGBImageToPDFTool isExitAtFilePath:path]){
                path=[[HGBImageToPDFTool getDocumentFilePath] stringByAppendingPathComponent:simplifyFilePath];
                if(![HGBImageToPDFTool isExitAtFilePath:path]){
                    path=[[HGBImageToPDFTool getMainBundlePath] stringByAppendingPathComponent:simplifyFilePath];
                    if(![HGBImageToPDFTool isExitAtFilePath:path]){

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
    if(!([simplifyFilePath containsString:[HGBImageToPDFTool getHomeFilePath]]||[simplifyFilePath containsString:[HGBImageToPDFTool getMainBundlePath]])){
        simplifyFilePath=[[HGBImageToPDFTool getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
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
    return [HGBImageToPDFTool findBestViewController:viewController];
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
        return [HGBImageToPDFTool findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBImageToPDFTool findBestViewController:svc.viewControllers.lastObject];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBImageToPDFTool findBestViewController:svc.topViewController];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBImageToPDFTool findBestViewController:svc.selectedViewController];
        }else{
            return vc;
        }
    } else {
        return vc;
    }
}
@end
