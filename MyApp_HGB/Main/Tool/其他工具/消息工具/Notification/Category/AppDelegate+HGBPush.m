//
//  AppDelegate+HGBPush.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/22.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate+HGBPush.h"
#import <UserNotifications/UserNotifications.h>
#import <objc/runtime.h>

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


#define WidthScale [UIScreen mainScreen].bounds.size.width/375
#define HeightScale [UIScreen mainScreen].bounds.size.height/667
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height





/**
 通知消息类型
 */
typedef enum HGBPushNotificatonType
{
    HGBPushNotificatonTypeRemoteActive,//活跃状态远程消息
    HGBPushNotificatonTypeLocalActive,//活跃状态本地消息
    HGBPushNotificatonTypeRemoteUnActive,//非活跃状态远程消息
    HGBPushNotificatonTypeLocalUnActive,//非活跃状态本地消息
    HGBPushNotificatonTypeRemoteLanuch,//app加载状态远程消息
    HGBPushNotificatonTypeLocalLanuch//app加载状态本地消息

}HGBPushNotificatonType;


#define AlertFlag NO
@implementation AppDelegate (HGBPush)

#pragma mark init
/**
 推送初始化

 @param launchOptions 加载参数
 */
-(void)init_Push_ServerWithOptions:(NSDictionary *)launchOptions{
    [self application_Push_DidLaunchHandleWithOptions:launchOptions];
}
#pragma mark life
/**
 app加载

 @param launchOptions 信息
 */
-(void)application_Push_DidLaunchHandleWithOptions:(NSDictionary *)launchOptions{
    [self registerPushNotificationAuthorityWithapplication:[UIApplication sharedApplication]];
    [self launchWithNotificationInfo:launchOptions];
}
/**
 app进入前台

 @param notification 消息
 */
-(void)application_Push_DidBecomeActiveHandle:(NSNotification *)notification{
}
/**
 app将要进入后台

 @param notification 消息
 */
-(void)application_Push_DidBecomeBackHandle:(NSNotification *)notification{
}

#pragma mark 消息处理
/**
 消息处理

 @param messageTitle 消息标题
 @param messageBody 消息体
 @param messageContent 消息内容
 @param messageInfo 消息信息
 */
-(void)applicationDidReciveMessageWithMessageTitle:(NSString *)messageTitle andWithMessageBody:(NSString *)messageBody andWithMessageContent:(id)messageContent andWithMessageInfo:(NSDictionary *)messageInfo andWithMessageType:(HGBPushNotificatonType )messageType{
    NSLog(@"%@-%@-%@-%@",messageTitle,messageBody,messageContent,messageInfo);
    if(AlertFlag){
        NSString *string=[NSString stringWithFormat:@"%@-%@-%@",messageTitle,messageBody,[self ObjectToJSONString:messageInfo]];
        [self alertWithTitle:@"message" andWithPrompt:string];
    }
}
#pragma mark 申请推送权限
/**
 推送权限

 @param application application
 */
-(void)registerPushNotificationAuthorityWithapplication:(UIApplication *)application{
    //注册
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {

#ifdef KiOS10Later

        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        //请求获取通知权限（角标，声音，弹框）
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //获取用户是否同意开启通知
                NSLog(@"request authorization successed!");
            }
        }];

#else
        UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        //        本地通知
        [application registerUserNotificationSettings:setting];
#endif

        //        远程通知
        [application registerForRemoteNotifications];
    }
}

#pragma mark 远程通知注册反馈

/**
 注册远程通知成功

 @param application application
 @param deviceToken token
 */
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    NSString *dvsToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    //============保存dvsToken===========================
    NSString *formatToekn = [dvsToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@",formatToekn);
    if(AlertFlag){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"remote:token" message:nil preferredStyle:UIAlertControllerStyleAlert];

        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {

            textField.text =formatToekn;
        }];

        UIAlertAction *a=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:a];
        [[self currentViewController] presentViewController:alert animated:YES completion:nil];

    }
}
/**
 注册远程通知失败

 @param application application
 @param error 错误
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"remote:failed");
    if(AlertFlag){
        [self alertWithTitle:@"remote" andWithPrompt:@"failed"];
    }
}
#pragma mark iOS10以下本地通知注册反馈
#ifdef KiOS10Later
#else
/**
 本地通知注册成功

 @param application application
 @param notificationSettings 配置
 */
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"local:sucess");
    if(AlertFlag){
        [self alertWithTitle:@"local" andWithPrompt:@"sucess"];
    }
}
#endif

#pragma mark 初次进入消息处理

/**
 初次进入application获取到消息（状态栏点击消息进入）

 @param launchOptions 信息
 */
-(void)launchWithNotificationInfo:(NSDictionary *)launchOptions{
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];

    NSDictionary* localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];

    if(localNotification){
        NSLog(@"local-first:%@",localNotification);
         [self applicationDidReciveMessageWithMessageTitle:nil andWithMessageBody:nil andWithMessageContent:nil andWithMessageInfo:localNotification andWithMessageType:HGBPushNotificatonTypeLocalLanuch];
        if(AlertFlag){
            NSString *string=[NSString stringWithFormat:@"first:%@",[self ObjectToJSONString:localNotification]];
            [self alertWithTitle:@"local" andWithPrompt:string];
        }
    }
    if(remoteNotification){
        NSLog(@"remote-first:%@",remoteNotification);
         [self applicationDidReciveMessageWithMessageTitle:nil andWithMessageBody:nil andWithMessageContent:nil andWithMessageInfo:remoteNotification andWithMessageType:HGBPushNotificatonTypeRemoteLanuch];
        if(AlertFlag){
            NSString *string=[NSString stringWithFormat:@"first:%@",[self ObjectToJSONString:remoteNotification]];
            [self alertWithTitle:@"remote" andWithPrompt:string];
        }
    }

#ifdef KiOS10Later
#else

#endif

}
#pragma mark iOS10以上消息处理
#ifdef KiOS10Later
//
/**
 App处于前台接收通知时

 @param center 消息中心
 @param notification 消息中心
 @param completionHandler 完成
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{

    //收到推送的请求
    UNNotificationRequest *request = notification.request;

    //收到推送的内容
    UNNotificationContent *content = request.content;

    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;

    //收到推送消息的角标
    NSNumber *badge = content.badge;

    //收到推送消息body
    NSString *body = content.body;

    //推送消息的声音
    UNNotificationSound *sound = content.sound;

    // 推送消息的副标题
    NSString *subtitle = content.subtitle;

    // 推送消息的标题
    NSString *title = content.title;

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        [self applicationDidReciveMessageWithMessageTitle:title andWithMessageBody:body andWithMessageContent:content andWithMessageInfo:userInfo andWithMessageType:HGBPushNotificatonTypeRemoteActive];
        NSString *string=[NSString stringWithFormat:@"%@-%@-%@",title,body,[self ObjectToJSONString:userInfo]];
        [self alertWithTitle:@"remote" andWithPrompt:string];

    }else {
        // 判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
        [self applicationDidReciveMessageWithMessageTitle:title andWithMessageBody:body andWithMessageContent:content andWithMessageInfo:userInfo andWithMessageType:HGBPushNotificatonTypeLocalActive];
        NSString *string=[NSString stringWithFormat:@"%@-%@-%@",title,body,[self ObjectToJSONString:userInfo]];
        [self alertWithTitle:@"local" andWithPrompt:string];
    }


    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);

}



/**
 App通知的点击事件

 @param center 消息中心
 @param response 反馈
 @param completionHandler 完成
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;

    //收到推送的内容
    UNNotificationContent *content = request.content;

    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;

    //收到推送消息的角标
    NSNumber *badge = content.badge;

    //收到推送消息body
    NSString *body = content.body;

    //推送消息的声音
    UNNotificationSound *sound = content.sound;

    // 推送消息的副标题
    NSString *subtitle = content.subtitle;

    // 推送消息的标题
    NSString *title = content.title;

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        [self applicationDidReciveMessageWithMessageTitle:title andWithMessageBody:body andWithMessageContent:content andWithMessageInfo:userInfo andWithMessageType:HGBPushNotificatonTypeRemoteUnActive];
        //此处省略一万行需求代码。。。。。
        NSString *string=[NSString stringWithFormat:@"%@-%@-%@",title,body,[self ObjectToJSONString:userInfo]];
        [self alertWithTitle:@"remote" andWithPrompt:string];


    }else {
        // 判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
        [self applicationDidReciveMessageWithMessageTitle:title andWithMessageBody:body andWithMessageContent:content andWithMessageInfo:userInfo andWithMessageType:HGBPushNotificatonTypeLocalUnActive];
        NSString *string=[NSString stringWithFormat:@"%@-%@-%@",title,body,[self ObjectToJSONString:userInfo]];
        [self alertWithTitle:@"local" andWithPrompt:string];
    }
    completionHandler(); // 系统要求执行这个方法
}
#else
#pragma mark iOS10以下本地消息处理

/**
 收到本地通知

 @param application application
 @param notification 消息
 */
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"local:%@-%@-%@",notification.alertTitle,notification.alertBody,notification.userInfo);
    if(application.applicationState!=0){
        [self applicationDidReciveMessageWithMessageTitle:notification.alertTitle andWithMessageBody:notification.alertBody andWithMessageContent:nil andWithMessageInfo:notification.userInfo andWithMessageType:HGBPushNotificatonTypeLocalUnActive];
    }else{
        [self applicationDidReciveMessageWithMessageTitle:notification.alertTitle andWithMessageBody:notification.alertBody andWithMessageContent:nil andWithMessageInfo:notification.userInfo andWithMessageType:HGBPushNotificatonTypeLocalActive];
    }

    if(AlertFlag){
        NSString *string=[NSString stringWithFormat:@"%@-%@-%@",notification.alertTitle,notification.alertBody,[self ObjectToJSONString:notification.userInfo]];
        [self alertWithTitle:@"local" andWithPrompt:string];
    }

}
/**
 本地通知事件

 @param application application
 @param identifier 标识
 @param notification 消息
 @param completionHandler 完成
 */
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler{
    NSLog(@"local-action:%@-%@-%@",notification.alertTitle,notification.alertBody,notification.userInfo);
    if(application.applicationState!=0){
        [self applicationDidReciveMessageWithMessageTitle:notification.alertTitle andWithMessageBody:notification.alertBody andWithMessageContent:nil andWithMessageInfo:notification.userInfo andWithMessageType:HGBPushNotificatonTypeLocalUnActive];
    }else{
        [self applicationDidReciveMessageWithMessageTitle:notification.alertTitle andWithMessageBody:notification.alertBody andWithMessageContent:nil andWithMessageInfo:notification.userInfo andWithMessageType:HGBPushNotificatonTypeLocalActive];
    }
    if(AlertFlag){
        NSString *string=[NSString stringWithFormat:@"action:%@-%@-%@",notification.alertTitle,notification.alertBody,[self ObjectToJSONString:notification.userInfo]];
        [self alertWithTitle:@"local" andWithPrompt:string];

    }

}
#pragma mark iOS10以下远程消息处理
/**
 收到远程通知

 @param application application
 @param userInfo 信息
 @param completionHandler 完成
 */
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{


    NSLog(@"remote:%@",userInfo);
    if(application.applicationState!=0){
        [self applicationDidReciveMessageWithMessageTitle:nil andWithMessageBody:nil andWithMessageContent:nil andWithMessageInfo:userInfo andWithMessageType:HGBPushNotificatonTypeLocalUnActive];
    }else{
        [self applicationDidReciveMessageWithMessageTitle:nil andWithMessageBody:nil andWithMessageContent:nil andWithMessageInfo:userInfo andWithMessageType:HGBPushNotificatonTypeLocalActive];
    }
    if(AlertFlag){
        NSString *string=[NSString stringWithFormat:@"%@",[self ObjectToJSONString:userInfo]];
        [self alertWithTitle:@"remote" andWithPrompt:string];
    }


    // 1.打开后台模式 2.告诉系统是否有新内容的更新 3.发送的通知有固定的格式("content-available":"1")
    // 2.告诉系统有新内容
    completionHandler(UIBackgroundFetchResultNewData);
}
/**
 远程通知事件

 @param application application
 @param identifier 标识
 @param userInfo 消息
 @param completionHandler 完成
 */
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    NSLog(@"remote-action:%@",userInfo);
    if(application.applicationState!=0){
        [self applicationDidReciveMessageWithMessageTitle:nil andWithMessageBody:nil andWithMessageContent:nil andWithMessageInfo:userInfo andWithMessageType:HGBPushNotificatonTypeLocalUnActive];
    }else{
        [self applicationDidReciveMessageWithMessageTitle:nil andWithMessageBody:nil andWithMessageContent:nil andWithMessageInfo:userInfo andWithMessageType:HGBPushNotificatonTypeLocalActive];
    }


    if(AlertFlag){
        NSString *string=[NSString stringWithFormat:@"action:%@",[self ObjectToJSONString:userInfo]];
        [self alertWithTitle:@"remote" andWithPrompt:string];
    }
}
#endif



#pragma mark 提示
/**
 展示内容

 @param prompt 提示
 */
-(void)alertWithTitle:(NSString *)title andWithPrompt:(NSString *)prompt{
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [[self currentViewController] presentViewController:alert animated:YES completion:nil];
#else
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:titl message:prompt delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
#endif
}

#pragma mark 获取当前控制器
- (UIViewController *)findBestViewController:(UIViewController *)vc
{
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}
#pragma mark 返回根视图控制器
- (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}
#pragma mark 工具
/**
 把Json对象转化成json字符串

 @param object json对象
 @return json字符串
 */
- (NSString *)ObjectToJSONString:(id)object
{
    if(!([object isKindOfClass:[NSDictionary class]]||[object isKindOfClass:[NSArray class]]||[object isKindOfClass:[NSString class]])){
        return @"";
    }
    if([object isKindOfClass:[NSString class]]){
        return object;
    }
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return myString;
}
@end
