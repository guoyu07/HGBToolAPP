//
//  WeexSDKManager.m
//  WeexDemo
//
//  Created by yangshengtao on 16/11/14.
//  Copyright © 2016年 taobao. All rights reserved.
//

#import "WeexSDKManager.h"
#import "WeexBundleUrlLoder.h"
#import <WeexSDK/WeexSDK.h>
#import "HGBWeexController.h"
#import "HGBWeexPluginManager.h"
@implementation WeexSDKManager
+(void)baseSetup{
    [self initWeexSDK];
    [HGBWeexPluginManager registerWeexPlugin];
}
+ (void)setup;
{
    [self initWeexSDK];
    [HGBWeexPluginManager registerWeexPlugin];
    [self loadCustomContainWithScannerWithUrl:nil];
}

+ (void)initWeexSDK
{
    [WXAppConfiguration setAppGroup:@"HUANG GUANG BAO"];
    [WXAppConfiguration setAppName:@"HelloCordova"];
    [WXAppConfiguration setAppVersion:@"1.0.0"];
    [WXAppConfiguration setExternalUserAgent:@"HUANG GUANG BAO"];
    
    [WXSDKEngine initSDKEnvironment];
    [WXLog setLogLevel:WXLogLevelLog];
   
    
}

+ (void)loadCustomContainWithScannerWithUrl:(NSURL *)url
{
    [[UIApplication sharedApplication] delegate].window.rootViewController = [[HGBWeexController alloc] init];
}

@end
