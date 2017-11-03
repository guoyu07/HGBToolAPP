//
//  HGBCallPhonePlugin.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
@interface HGBCallPhonePlugin : CDVPlugin
/**
 *  拨打电话插件
 *
 *  @param command 用来接收h5传过来的参数对象
 */
- (void)getCallPhone:(CDVInvokedUrlCommand *)command;
@end
