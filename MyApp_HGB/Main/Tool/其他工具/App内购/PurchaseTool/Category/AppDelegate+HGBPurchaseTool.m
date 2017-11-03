//
//  AppDelegate+HGBPurchaseTool.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/17.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate+HGBPurchaseTool.h"
#import "HGBPurchaseTool.h"

@implementation AppDelegate (HGBPurchaseTool)
#pragma mark init
/**
 内购初始化

 @param launchOptions 加载参数
 */
-(void)init_Purchase_ServerWithOptions:(NSDictionary *)launchOptions{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(application_Purchase_didLaunchHandle:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(application_Purchase_willTerminateHandle:) name:UIApplicationWillTerminateNotification object:nil];

}
#pragma mark life
-(void)application_Purchase_didLaunchHandle:(NSNotification *)notification{
    [[HGBPurchaseTool shareInstance]startManager];
}
-(void)application_Purchase_willTerminateHandle:(NSNotification *)notification{
    [[HGBPurchaseTool shareInstance]stopManager];
}
@end
