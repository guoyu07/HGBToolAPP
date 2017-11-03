//
//  HGBWeexPluginManager.m
//  CordovaAndWeexBase
//
//  Created by huangguangbao on 2017/7/5.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBWeexPluginManager.h"
#import "HGBWeexPluginLoader.h"
#import <WeexSDK/WeexSDK.h>
@implementation HGBWeexPluginManager

+ (void)registerWeexPlugin
{
    NSArray *pluginNames = [NSArray arrayWithArray:[HGBWeexPluginLoader getPlugins]];
    if (!pluginNames) {
        return;
    }
    [pluginNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *pluginInfo = (NSDictionary *)obj;
        if ([pluginInfo[@"category"] isEqualToString:@"handler"] && pluginInfo[@"protocol"]) {
            
            [WXSDKEngine registerHandler:[NSClassFromString(pluginInfo[@"ios-package"]) new]
                            withProtocol:NSProtocolFromString(pluginInfo[@"protocol"])];
        }else if ([pluginInfo[@"category"] isEqualToString:@"component"] && pluginInfo[@"ios-package"]) {
            [WXSDKEngine registerComponent:pluginInfo[@"api"] withClass:NSClassFromString(pluginInfo[@"ios-package"])];
        }else if ([pluginInfo[@"category"] isEqualToString:@"module"] && pluginInfo[@"ios-package"]) {
            [WXSDKEngine registerModule:pluginInfo[@"api"] withClass:NSClassFromString(pluginInfo[@"ios-package"])];
        }
    }];
}
@end
