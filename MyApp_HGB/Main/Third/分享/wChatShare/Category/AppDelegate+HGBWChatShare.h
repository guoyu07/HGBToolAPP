//
//  AppDelegate+HGBWChatShare.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/11/2.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "WechatAuthSDK.h"
#import "WXApiObject.h"

@interface AppDelegate (HGBWChatShare)<WXApiDelegate>
/**
 微信分享初始化

 @param WChatShareAppKey AppKey
 @param launchOptions 加载参数
 */
-(void)init_WChatShare_ServerWithWChatShareAppKey:(NSString *)WChatShareAppKey andWithLaunchOptions:(NSDictionary *)launchOptions;
/**
 打开url

 @param url url
 @return 结果
 */
- (BOOL)applicationOpenURL:(NSURL *)url;
@end
