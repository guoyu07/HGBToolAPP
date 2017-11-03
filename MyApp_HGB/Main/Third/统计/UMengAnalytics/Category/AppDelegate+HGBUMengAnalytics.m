//
//  AppDelegate+HGBUMengAnalytics.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate+HGBUMengAnalytics.h"
#import <UMMobClick/MobClick.h>

@implementation AppDelegate (HGBUMengAnalytics)
/**
 友盟统计初始化

 @param UMengAnalyticsAppKey AppKey
 @param launchOptions 加载参数
 */
-(void)init_UMengAnalytics_ServerWithUMengAnalyticsAppKey:(NSString *)UMengAnalyticsAppKey andWithLaunchOptions:(NSDictionary *)launchOptions{
    if(UMengAnalyticsAppKey==nil||UMengAnalyticsAppKey.length==0){
        UMengAnalyticsAppKey=@"59df2c8b82b6356c4b00006f";
    }
    UMConfigInstance.appKey = UMengAnalyticsAppKey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick setEncryptEnabled:YES];//日志加密
    [MobClick setAppVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [MobClick setLogEnabled:YES];
    [MobClick setCrashReportEnabled:YES];
    [MobClick setLogSendInterval:120];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}
@end
