//
//  HGBNotificationTool.h
//  测试
//
//  Created by huangguangbao on 2017/8/6.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotificationsUI/UserNotificationsUI.h>


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

#ifndef KiOS11Later
#define KiOS11Later (SYSTEM_VERSION >= 11)
#endif



///**
// 扫描方式类型
// */
//typedef enum HGBRomotePushType
//{
//    HGBRomotePushTypeTest,//测试版证书
//    HGBRomotePushTypeFormal//发布版证书
//
//}HGBRomotePushType;

typedef void (^ReslutBlock)(BOOL status,NSDictionary *returnMessage);


@interface HGBNotificationTool : NSObject
#pragma mark 通知
/**
 发送通知

 @param name 通知名
 @param object 通知对象
 @param userInfo 消息相关信息
 */
+(void)sendNotificationNotificationName:(NSString *)name andWithObject:(id)object andWithUserInfo:(NSDictionary *)userInfo;
/**
 监听通知

 @param name 通知名
 @param object 通知对象
 @param selector 监听方法
 @param observer 监听者
 */
+(void)observerNotificationWithObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object;
/**
 移除通知监听

 @param observer 监听者
 */
+ (void)removeNotificationObserver:(id)observer;
#pragma mark 本地推送
/**
 发送本地推送消息

 @param messageTitle 消息标题
 @param messageSubTitle 消息副标题
 @param messageBody 消息体
 @param userInfo 消息相关信息
  @param messageIdentify 消息标记
 @param fireDate 消息发送时间
 @param setBlock  设置 参数iOS10 以下设置localNoti iOS10以上设置content
 @param reslutBlock  结果

 */
+(void)pushLocalNotificationWithMessageTitle:(NSString *)messageTitle andWithMessageSubTitle:(NSString *)messageSubTitle andWithMessageBody:(NSString *)messageBody andWithUserInfo:(NSDictionary *)userInfo andWithMessageIdentify:(NSString *)messageIdentify InFireDate:(NSDate *)fireDate WithSetBlock:(void (^)(id localNoti,id content))setBlock andWithReslutBlock:(ReslutBlock)reslutBlock;

//取消本地推送

/**
 取消本地推送

 @param messageIdentify 本地推送标志位-根据userInfo中id_key字段判断
 */
+(void)cancelLocalNotificationWithMessageIdentify:(NSString *)messageIdentify;
/**
 取消所有本地通知
 */
+(void)cancelAllLocalNotification;
/**
 获取推送消息

 @param reslutBlock 结果
 */
+(void)getAllNotifications:(void(^)(BOOL sucessFlag,NSArray *notifivations))reslutBlock;
@end
