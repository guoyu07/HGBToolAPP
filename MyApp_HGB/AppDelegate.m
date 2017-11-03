//
//  AppDelegate.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate.h"

#import "AppDelegate+HGBDataBase.h"
#import "AppDelegate+HGBSEDataBase.h"
#import "AppDelegate+HGBPush.h"
#import "AppDelegate+HGBPurchaseTool.h"

#import "AppDelegate+HGBBaiduMap.h"
#import "AppDelegate+HGBUMengAnalytics.h"
#import "AppDelegate+HGBWeex.h"
#import "AppDelegate+HGBWChatShare.h"
#import "AppDelegate+HGBUMShare.h"

#import "HGBRootViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //数据库初始化
    [self init_DataBase_ServerWithOptions:launchOptions];
    //SE数据库初始化
    [self init_SEDataBase_ServerWithOptions:launchOptions];
    //推送初始化
    [self init_Push_ServerWithOptions:launchOptions];
    //app内购初始化
    [self init_Purchase_ServerWithOptions:launchOptions];



    //weex初始化
    [self init_Weex_ServerWithOptions:launchOptions];
    //百度地图初始化
    [self init_BaiduMap_ServerWithBaiduMapAppKey:@"fEH1pg9fLuIHZ6ubiyAhEHfNaKkrwHei" andWithLaunchOptions:launchOptions];
    //友盟统计
    [self init_UMengAnalytics_ServerWithUMengAnalyticsAppKey:@"59df2c8b82b6356c4b00006f" andWithLaunchOptions:launchOptions];
    //微信分享
    [self init_WChatShare_ServerWithWChatShareAppKey:nil andWithLaunchOptions:launchOptions];
    //友盟分享
    [self init_UMShare_ServerWithLaunchOptions:launchOptions];
    

    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    HGBRootViewController *rootVC=[[HGBRootViewController alloc]init];
    self.window.rootViewController=rootVC;
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}
#pragma mark url
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    //    NSLog(@"%@",options);
    return [self applicationOpenURL:url];
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [self applicationOpenURL:url];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [self applicationOpenURL:url];
}

@end
