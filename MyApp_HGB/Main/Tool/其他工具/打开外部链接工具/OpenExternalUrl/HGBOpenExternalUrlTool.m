//
//  HGBOpenExternalUrlTool.m
//  VirtualCard
//
//  Created by huangguangbao on 2017/6/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBOpenExternalUrlTool.h"
#import <UIKit/UIKit.h>


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

@implementation HGBOpenExternalUrlTool
static HGBOpenExternalUrlTool*instance=nil;
#pragma mark 初始化
+(instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBOpenExternalUrlTool alloc]init];
    }
    return instance;
}
#pragma mark 基础
/**
 打开浏览器
 
 @param urlString url字符串
 @return 结果
 */
+(BOOL)openBrowserWithUrlString:(NSString *)urlString{
    [HGBOpenExternalUrlTool shareInstance];
    NSURL *url=[NSURL URLWithString:urlString];
    if([[UIApplication sharedApplication]canOpenURL:url]){
#ifdef KiOS10Later
         static BOOL sucessFlag=YES;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
            sucessFlag=success;
            //发出已完成的信号
            dispatch_semaphore_signal(semaphore);
        }];


        //等待执行，不会占用资源
        dispatch_semaphore_wait(semaphore, 20);
        return sucessFlag;
#else
        return [[UIApplication sharedApplication]openURL:url];
#endif

    }else{
        return NO;
    }
}
/**
 打电话
 
 @param phoneNumber 电话号码
 @return 结果
 */
+(BOOL)openToCallPhoneWithPhoneNumber:(NSString *)phoneNumber{
    [HGBOpenExternalUrlTool shareInstance];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[HGBOpenExternalUrlTool deleteSpace:phoneNumber]]];
    if([[UIApplication sharedApplication]canOpenURL:url]){
        ;
#ifdef KiOS10Later
        static BOOL sucessFlag=YES;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
            sucessFlag=success;
            //发出已完成的信号
            dispatch_semaphore_signal(semaphore);
        }];


        //等待执行，不会占用资源
        dispatch_semaphore_wait(semaphore, 20);
        return sucessFlag;
#else
        return [[UIApplication sharedApplication]openURL:url];
#endif
    }else{
        return NO;
    }
}
/**
 打开外部链接
 
 @param urlString url
 @return 结果
 */
+(BOOL)openAppWithUrlString:(NSString *)urlString{
    [HGBOpenExternalUrlTool shareInstance];
    NSURL *url=[NSURL URLWithString:urlString];
    if([[UIApplication sharedApplication]canOpenURL:url]){
#ifdef KiOS10Later
        static BOOL sucessFlag=YES;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
            sucessFlag=success;
            //发出已完成的信号
            dispatch_semaphore_signal(semaphore);
        }];


        //等待执行，不会占用资源
        dispatch_semaphore_wait(semaphore, 20);
        return sucessFlag;
#else
        return [[UIApplication sharedApplication]openURL:url];
#endif
    }else{
        return NO;
    }
}

/**
 打开设置界面
 
 @return 结果
 */
+(BOOL)openAppSetView{
    [HGBOpenExternalUrlTool shareInstance];
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {

#ifdef KiOS10Later
        static BOOL sucessFlag=YES;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
            sucessFlag=success;
            //发出已完成的信号
            dispatch_semaphore_signal(semaphore);
        }];


        //等待执行，不会占用资源
        dispatch_semaphore_wait(semaphore, 20);
        return sucessFlag;
#else
        return [[UIApplication sharedApplication]openURL:url];
#endif
    }else{
        return NO;
    }
}
#pragma mark 打开各种设置界面
/**
 打开各种设置界面
 
 @param seturl 类型
 @return 结果
 */
+(BOOL)openAppSetViewWithType:(HGBSetURL)seturl{
    [HGBOpenExternalUrlTool shareInstance];
    NSArray *urlArray=@[@"root=General&path=About",
                     @"root=General&path=ACCESSIBILITY",
                     @"root=AIRPLANE_MODE",
                     @"root=General&path=AUTOLOCK",
                     @"root=Brightness",
                     @"root=General&path=Bluetooth",
                     @"root=General&path=DATE_AND_TIME",
                     @"root=FACETIME",
                     @"root=General",
                     @"root=General&path=Keyboard",
                     @"root=CASTLE iCloud",
                     @"root=CASTLE&path=STORAGE_AND_BACKUP",
                     @"root=General&path=INTERNATIONAL",
                     @"root=LOCATION_SERVICES",
                     @"root=MUSIC",
                     @"MUSIC&path=EQ",
                     @"root=MUSIC&path=VolumeLimit",
                     @"root=General&path=Network",
                     @"root=NIKE_PLUS_IPOD",
                     @"root=NOTES",
                     @"root=NOTIFICATIONS_ID",
                     @"root=Phone",
                     @"root=Photos",
                     @"root=General&path=ManagedConfigurationList",
                     @"root=General&path=Reset",
                     @"root=Safari",
                     @"root=General&path=Assistant",
                     @"root=Sounds",
                     @"root=General&path=SOFTWARE_UPDATE_LINK",
                     @"root=STORE",
                     @"root=TWITTER",
                     @"root=General&path=USAGE",
                     @"root=General&path=Network/VPN",
                     @"root=Wallpaper",
                     @"root=WIFI",
                     @"root=INTERNET_TETHERING"];
    
    NSString *urlStr=urlArray[seturl];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"App-Prefs:%@",urlStr]];
    if([[UIApplication sharedApplication] canOpenURL:url]) {

#ifdef KiOS10Later
        static BOOL sucessFlag=YES;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
            sucessFlag=success;
            //发出已完成的信号
            dispatch_semaphore_signal(semaphore);
        }];


        //等待执行，不会占用资源
        dispatch_semaphore_wait(semaphore, 20);
        return sucessFlag;
#else
        return [[UIApplication sharedApplication]openURL:url];
#endif
    }else{
        return NO;
    }
}
#pragma mark 删除空格
+(NSString *)deleteSpace:(NSString *)string
{
    NSString *str=string;
    while ([str containsString:@" "]){
        str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return str;
}

@end
