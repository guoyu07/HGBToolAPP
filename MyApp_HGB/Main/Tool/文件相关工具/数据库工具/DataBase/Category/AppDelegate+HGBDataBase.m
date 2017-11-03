//
//  AppDelegate+HGBDataBase.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/20.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate+HGBDataBase.h"

#import <objc/runtime.h>
#import "HGBDataBaseTool.h"
@implementation AppDelegate (HGBDataBase)
#pragma mark init
/**
 数据库初始化

 @param launchOptions 加载参数
 */
-(void)init_DataBase_ServerWithOptions:(NSDictionary *)launchOptions{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(application_DataBase_didLaunchHandle:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(application_DataBase_willTerminateHandle:) name:UIApplicationWillTerminateNotification object:nil];
}
#pragma mark life
-(void)application_DataBase_didLaunchHandle:(NSNotification *)notification{
    [HGBDataBaseTool shareInstance];
}
-(void)application_DataBase_willTerminateHandle:(NSNotification *)notification{
    [HGBDataBaseTool closeDataBase];
}
@end
