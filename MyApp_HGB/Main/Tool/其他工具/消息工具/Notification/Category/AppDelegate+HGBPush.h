//
//  AppDelegate+HGBPush.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/22.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate (HGBPush)<UNUserNotificationCenterDelegate>
/**
 推送初始化

 @param launchOptions 加载参数
 */
-(void)init_Push_ServerWithOptions:(NSDictionary *)launchOptions;
@end
