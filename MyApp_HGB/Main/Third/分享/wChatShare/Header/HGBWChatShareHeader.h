//
//  HGBWChatShareHeader.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/11/2.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#ifndef HGBWChatShareHeader_h
#define HGBWChatShareHeader_h

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0

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


/**
 分享消息名称
 */
#define HGBWChatShareReslutNoti @"wChatShareReslutNoti"
/**
 分享结果
 */
typedef NS_ENUM(NSUInteger, HGBWChatShareStatus) {
    HGBWChatShareStatusSuccess = 0,//成功
    HGBWChatShareStatusUserCancel,//取消
    HGBWChatShareStatusErrorUnInstall,//未安装微信
    HGBWChatShareStatusErrorAuthDeny,//权限不足
    HGBWChatShareStatusErrorUnsupport,//不支持
    HGBWChatShareStatusErrorSentFail,//发送失败
    HGBWChatShareStatusErrorCommon//其他错误
};

#endif /* HGBWChatShareHeader_h */
