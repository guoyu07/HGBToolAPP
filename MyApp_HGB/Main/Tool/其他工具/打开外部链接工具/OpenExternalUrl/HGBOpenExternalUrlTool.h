//
//  HGBOpenExternalUrlTool.h
//  VirtualCard
//
//  Created by huangguangbao on 2017/6/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 设置界面url
 */
typedef enum HGBSetURL
{
    HGBSetURL_About,//关于界面
    HGBSetURL_Accessibility,//Accessibility
    HGBSetURL_AirplaneModeOn,//AirplaneMode界面
    HGBSetURL_AutoLock,//AutoLock界面
    HGBSetURL_Brightness,//Brightness界面
    HGBSetURL_Bluetooth,//Bluetooth界面
    HGBSetURL_DateTime,//DateTime界面
    HGBSetURL_FaceTime,//FaceTime界面
    HGBSetURL_General,//General界面
    HGBSetURL_Keyboard,//Keyboard界面
    HGBSetURL_iCloud,//iCloud界面
    HGBSetURL_StorageBackup,//Storage&Backup界面
    HGBSetURL_International,//International界面
    HGBSetURL_LocationServices,//LocationServices界面
    HGBSetURL_Music,//Music界面
    HGBSetURL_MusicEqualizer,//Music Equalizer界面
    HGBSetURL_MusicVolumeLimit,//Music VolumeLimit界面
    HGBSetURL_Network,//Network界面
    HGBSetURL_NikeiPod,//Nike + iPod界面
    HGBSetURL_Notes,//Notes界面
    HGBSetURL_Notification,//Notification界面
    HGBSetURL_Phone,//Phone界面
    HGBSetURL_Photos,//Photos 界面
    HGBSetURL_Profile,//Profile 界面
    HGBSetURL_Reset,//Reset 界面
    HGBSetURL_Safari,//Safari 界面
    HGBSetURL_Siri,//Siri界面
    HGBSetURL_Sounds,//Sounds 界面
    HGBSetURL_SoftwareUpdate,//SoftwareUpdate 界面
    HGBSetURL_Store,//Store 界面
    HGBSetURL_Twitter,//Twitter 界面
    HGBSetURL_Usage,//Usage 界面
    HGBSetURL_VPN,//VPN 界面
    HGBSetURL_Wallpaper,//Wallpaper 界面
    HGBSetURL_WiFi,//Wi-Fi 界面
    HGBSetURL_Setting,//Setting 界面
    
}HGBSetURL;


@interface HGBOpenExternalUrlTool : NSObject
#pragma mark 基础
/**
 打开浏览器
 
 @param urlString url字符串
 @return 结果
 */
+(BOOL)openBrowserWithUrlString:(NSString *)urlString;
/**
 打电话
 
 @param phoneNumber 电话号码
 @return 结果
 */
+(BOOL)openToCallPhoneWithPhoneNumber:(NSString *)phoneNumber;
/**
 打开外部链接

 @param urlString url
 @return 结果
 */
+(BOOL)openAppWithUrlString:(NSString *)urlString;

/**
 打开设置界面
 @return 结果
 */
+(BOOL)openAppSetView;

#pragma mark 打开各种设置界面
/**
 打开各种设置界面

 @param seturl 类型
 @return 结果
 */
+(BOOL)openAppSetViewWithType:(HGBSetURL)seturl;
@end
