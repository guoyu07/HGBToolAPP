//
//  HGBCallPhoneWeexPlugin.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>


@protocol HGBCallPhoneWeexPluginDelegate <WXModuleProtocol>
/**
 打电话

 @param arguments html传参数
 @param sucessCallback 成功回调
 @param failCallback 失败回调
 */
- (void)getCallPhone:(NSDictionary *)arguments :(WXModuleCallback)sucessCallback :(WXModuleCallback)failCallback;
@end

@interface HGBCallPhoneWeexPlugin : NSObject<HGBCallPhoneWeexPluginDelegate>

@end

