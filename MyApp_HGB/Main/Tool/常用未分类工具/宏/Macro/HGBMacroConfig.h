//
//  HGBMacroConfig.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/28.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#ifndef HGBMacroConfig_h
#define HGBMacroConfig_h

#pragma mark 屏幕尺寸

#define HSize ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)

#define HWidth ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)

#define HHeight ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)





//屏幕比例
#define HScale HWidth / 750.0
#define WScale HHeight / 1334.0

#define HGBNavigationBar_Height 44
#pragma mark 系统版本

#ifndef HVersion
#define HVersion [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
#endif

#ifndef KiOS6Later
#define KiOS6Later (HVersion >= 6)
#endif

#ifndef KiOS7Later
#define KiOS7Later (HVersion >= 7)
#endif

#ifndef KiOS8Later
#define KiOS8Later (HVersion >= 8)
#endif

#ifndef KiOS9Later
#define KiOS9Later (HVersion >= 9)
#endif

#ifndef KiOS10Later
#define KiOS10Later (HVersion >= 10)
#endif

#ifndef KiOS11Later
#define KiOS11Later (HVersion >= 11)
#endif
#pragma mark 设备

#if TARGET_OS_IPHONE                           //iPhone Device
#endif
#if TARGET_IPHONE_SIMULATOR          //iPhone Simulator
#endif

#define HGBISiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define HGBISiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#pragma mark 应用

#define HGBApplication        [UIApplication sharedApplication]
#define HGBKeyWindow          [UIApplication sharedApplication].keyWindow
#define HGBAppDelegate        [UIApplication sharedApplication].delegate
#define HGBUserDefaults      [NSUserDefaults standardUserDefaults]
#define HGBNotificationCenter [NSNotificationCenter defaultCenter]

#define HGBAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define HGBCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

#define HGBDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#define HGBTempPath NSTemporaryDirectory()

#define HGBCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#pragma mark ARC与非ARC实例
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif
#pragma mark 引用
#define HGBWeakSelf(type)  __weak typeof(type) weak##type = type;
#define GBStrongSelf(type) __strong typeof(type) type = weak##type;

#pragma mark 程序的本地化,引用国际化的文件
#define HGBLocal(x,...) NSLocalizedString(x, nil)

#pragma mark 单例

#define HGBShareInstance(classname) static classname *shared##classname = nil; + (classname *)shared##classname{@synchronized(self) {if (shared##classname == nil){shared##classname = ［self alloc] init];}} return shared##classname; } + (id)allocWithZone:(NSZone *)zone{@synchronized(self){if (shared##classname == nil){shared##classname = [super allocWithZone:zone];return shared##classname;}} return nil;} - (id)copyWithZone:(NSZone *)zone{return self; }

#pragma mark 线程
#define HGBBack(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define HGBMain(block) dispatch_async(dispatch_get_main_queue(),block)





#pragma mark 提示

#ifdef DEBUG
#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif

#ifdef DEBUG
#  define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__,__LINE__, ##__VA_ARGS__);
#else
#  define DLog(...)
#endif

#ifdef DEBUG
#define ULog(t,m) { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:t message:m delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#  define ULog(...)
#endif

#pragma mark tag
#define HGBTag(object,tag)    [object viewWithTag : tag]

#pragma mark 角度弧度

#define HGBDegreesToRadian(x)  (M_PI*(x)/ 180.0)

#define HGBRadianToDegrees(radian) (radian * 180.0) / (M_PI)

#pragma mark 字体大小

/**
 字体大小

 @param size 大小
 @return 字体
 */
#define HGBFont(size) [UIFont systemFontOfSize:size]

#pragma mark 颜色
/**
 颜色

 @param r 红色
 @param g 绿色
 @param b 蓝色
 @param a 透明度
 @return 颜色
 */
#define HGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/**
 颜色-不透明

 @param r 红色
 @param g 绿色
 @param b 蓝色
 @return 颜色
 */
#define HGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#pragma mark 图片

#define HGBBundleImage(name) [UIImage imageWithContentsOfFile:［NSBundle mainBundle] pathForResource:name ofType:nil］

#define HGBLoadImage(file,ext) [UIImage imageWithContentsOfFile:［NSBundle mainBundle]pathForResource:file ofType:ext］

#define HGBImage(name) [UIImage imageNamed:name］


#pragma mark 字符串

/**
 字符串去除两端空格

 @param string 字符串
 @return 字符串
 */
#define HGBTrim(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];


/**
 删除字符串空格

 @param string 字符串
 @return 字符串
 */
#define HGBDelSpace(string) while([string containsString:@" "]){string=[string stringByReplacingOccurrencesOfString:@" " withString:@""];}


#pragma mark 判空

/**
 字符串判空

 @param string 字符串
 @return 是否为空
 */
#define HGBStringIsEmpty(string) ([string isKindOfClass:[NSNull class]] || string == nil || [string length] < 1 ? YES : NO )

/**
 数组判空

 @param array 数组
 @return 是否为空
 */
#define HGBArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0? YES : NO)

/**
 数组判空

 @param array 数组
 @return 是否为空
 */
#define HGBArrayEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0? YES : NO)

/**
 字典判空

 @param dictionary 字典
 @return 是否为空
 */
#define HGBDictionaryIsEmpty(dictionary)  (dictionary == nil || [dictionary isKindOfClass:[NSNull class]] || dictionary.allKeys.count == 0? YES : NO)

/**
 对象判空

 @param object 对象
 @return 是否为空
 */
#define HGBObjectIsEmpty(object)  (object == nil||[object isKindOfClass:[NSNull class]]||([object respondsToSelector:@selector(length)] && [(NSData *)object length] == 0)|| ([object respondsToSelector:@selector(count)] && [(NSArray *)object count] == 0)?YES:NO)


#endif /* HGBMacroConfig_h */
