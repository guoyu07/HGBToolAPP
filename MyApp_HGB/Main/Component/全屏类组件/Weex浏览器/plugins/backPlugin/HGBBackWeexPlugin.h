//
//  HGBBackWeexPlugin.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>


@protocol HGBBackWeexPluginDelegate <WXModuleProtocol>
/**
 返回

 @param arguments html传参数
 @param sucessCallback 回调
 @param failCallback 失败回调
 */
- (void)getBack:(NSDictionary *)arguments :(WXModuleCallback)sucessCallback :(WXModuleCallback)failCallback;
@end

@interface HGBBackWeexPlugin : NSObject<HGBBackWeexPluginDelegate>

@end
