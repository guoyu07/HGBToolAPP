//
//  HGBBackPlugin.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>

@interface HGBBackPlugin :CDVPlugin
/**
 *  返回插件
 *
 *  @param command 用来接收h5传过来的参数对象
 */
- (void)getBack:(CDVInvokedUrlCommand *)command;
@end
