//
//  HGBCallPhonePlugin.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCallPhonePlugin.h"

@implementation HGBCallPhonePlugin
/**
 *  拨打电话插件
 *
 *  @param command 用来接收h5传过来的参数对象
 */
-(void)getCallPhone:(CDVInvokedUrlCommand *)command{
    NSString *phoneNumber;

    if ([command.arguments count] > 0) {
        phoneNumber = command.arguments[0];
    }
    if(phoneNumber!=nil&&phoneNumber.length!=0){
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]];
        [[UIApplication sharedApplication] openURL:url];
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"SUCESS"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }else{
         CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"ERROR"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
}

@end
