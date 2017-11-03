//
//  HGBNotificationTool.m
//  测试
//
//  Created by huangguangbao on 2017/8/6.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBNotificationTool.h"


#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>


#define ReslutCode @"reslutCode"
#define ReslutMessage @"reslutMessage"
#define ReslutError @"ReslutError"

@implementation HGBNotificationTool
#pragma mark 通知
/**
 发送通知

 @param name 通知名
 @param object 通知对象
 @param userInfo 消息相关信息
 */
+(void)sendNotificationNotificationName:(NSString *)name andWithObject:(id)object andWithUserInfo:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter]postNotificationName:name object:object userInfo:userInfo];
}
/**
 监听通知

 @param name 通知名
 @param object 通知对象
 @param selector 监听方法
 @param observer 监听者
 */
+(void)observerNotificationWithObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object{
    [[NSNotificationCenter defaultCenter]addObserver:observer selector:selector name:name object:object];
}
/**
 移除通知监听

 @param observer 监听者
 */
+(void)removeNotificationObserver:(id)observer{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}
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
+(void)pushLocalNotificationWithMessageTitle:(NSString *)messageTitle andWithMessageSubTitle:(NSString *)messageSubTitle andWithMessageBody:(NSString *)messageBody andWithUserInfo:(NSDictionary *)userInfo andWithMessageIdentify:(NSString *)messageIdentify InFireDate:(NSDate *)fireDate WithSetBlock:(void (^)(id localNoti,id content))setBlock andWithReslutBlock:(ReslutBlock)reslutBlock{
#ifdef KiOS10Later

    UNMutableNotificationContent *content=[[UNMutableNotificationContent alloc]init];
    if(messageTitle){
        content.title=messageTitle;
    }
    if(userInfo){
        content.userInfo=userInfo;
    }
    if(messageBody){
        content.body=messageBody;
    }
    if(messageSubTitle){
         content.subtitle= messageSubTitle;
    }
    content.badge = @([[UIApplication sharedApplication]applicationIconBadgeNumber]+1);
//    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"caodi.m4a"];
//    content.sound = sound;
    setBlock(nil,content);
    NSTimeInterval interval=[fireDate timeIntervalSinceNow];

    //第三步：通知触发机制。（重复提醒，时间间隔要大于60s）
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:interval repeats:NO];

    //第四步：创建UNNotificationRequest通知请求对象
    NSString *requertIdentifier = messageIdentify;
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requertIdentifier content:content trigger:trigger];

    //第五步：将通知加到通知中心
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if(error){
            reslutBlock(YES,@{ReslutCode:@(error.code).stringValue,ReslutMessage:error.localizedDescription,ReslutError:error});
        }else{
            reslutBlock(YES,@{ReslutCode:@"0",ReslutMessage:@"成功"});
        }
    }];



#else
    UILocalNotification *localNoti=[[UILocalNotification alloc]init];
    if(messageTitle){
        localNoti.alertTitle=messageTitle;
    }
    if(userInfo||messageIdentify){
        NSMutableDictionary *userInfoMessage=[[NSMutableDictionary alloc]initWithDictionary:userInfo];
        [userInfoMessage setObject:messageIdentify forKey:@"messageIdentify_huangguangbao"];
        localNoti.userInfo=userInfo;
    }
    if(messageBody){
        localNoti.alertBody=messageBody;
    }
    localNoti.soundName= UILocalNotificationDefaultSoundName;

    localNoti.fireDate=fireDate;
    setBlock(localNoti,nil);
    [[UIApplication sharedApplication]scheduleLocalNotification:localNoti];

   reslutBlock(YES,@{ReslutCode:@"0",ReslutMessage:@"成功"});
#endif

}
//取消本地推送

/**
 取消本地推送

 @param messageIdentify 本地推送标志位-根据userInfo中id_key字段判断
 */
+(void)cancelLocalNotificationWithMessageIdentify:(NSString *)messageIdentify{
#ifdef KiOS10Later
    UNUserNotificationCenter *center=[UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:@[messageIdentify]];
    [center removeDeliveredNotificationsWithIdentifiers:@[messageIdentify]];
#else
    NSArray *notis=[[UIApplication sharedApplication]scheduledLocalNotifications];
    for(UILocalNotification *noti in notis){
        if([[noti.userInfo objectForKey:@"messageIdentify_huangguangbao"] isEqualToString:messageIdentify]){
            [[UIApplication sharedApplication]cancelLocalNotification:noti];
        }
    }
#endif

}
/**
 取消所有本地通知
 */
+(void)cancelAllLocalNotification{
#ifdef KiOS10Later
    UNUserNotificationCenter *center=[UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
    [center removeAllPendingNotificationRequests];
#else
    NSArray *notis=[[UIApplication sharedApplication]scheduledLocalNotifications];
    for(UILocalNotification *noti in notis){
        [[UIApplication sharedApplication]cancelLocalNotification:noti];
    }
#endif

}
/**
 获取推送消息

 @param reslutBlock 结果
 */
+(void)getAllNotifications:(void(^)(BOOL sucessFlag,NSArray *notifivations))reslutBlock{
#ifdef KiOS10Later
      UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        reslutBlock(YES,notifications);
    }];
    [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        reslutBlock(YES,requests);
    }];

#else
    NSArray *notis=[[UIApplication sharedApplication]scheduledLocalNotifications];
    reslutBlock(YES,notis);
#endif
}
#pragma mark 提示
/**
 展示内容

 @param prompt 提示
 */
-(void)alertWithPrompt:(NSString *)prompt{
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [[self currentViewController] presentViewController:alert animated:YES completion:nil];
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
-(UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}

/**
 寻找上层控制器

 @param vc 控制器
 @return 上层控制器
 */
- (UIViewController *)findBestViewController:(UIViewController *)vc
{
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0){
            return [self findBestViewController:svc.viewControllers.lastObject];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0){
            return [self findBestViewController:svc.topViewController];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0){
            return [self findBestViewController:svc.selectedViewController];
        }else{
            return vc;
        }
    } else {
        return vc;
    }
}
@end
