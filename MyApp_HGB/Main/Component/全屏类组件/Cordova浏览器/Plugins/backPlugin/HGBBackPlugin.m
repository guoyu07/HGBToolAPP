
//
//  HGBBackPlugin.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBackPlugin.h"

@implementation HGBBackPlugin
/**
 *  返回插件
 *
 *  @param command 用来接收h5传过来的参数对象
 */
-(void)getBack:(CDVInvokedUrlCommand *)command{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"SUCESS"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
@end
