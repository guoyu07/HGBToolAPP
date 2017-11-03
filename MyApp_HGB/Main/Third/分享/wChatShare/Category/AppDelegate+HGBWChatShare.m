//
//  AppDelegate+HGBWChatShare.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/11/2.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate+HGBWChatShare.h"

#import "HGBWChatShareHeader.h"

#define ReslutCode @"reslutCode"
#define ReslutMessage @"reslutMessage"
#define ReslutError @"reslutError"



@interface AppDelegate ()

@end
@implementation AppDelegate (HGBWChatShare)
/**
 微信分享初始化

 @param WChatShareAppKey AppKey
 @param launchOptions 加载参数
 */
-(void)init_WChatShare_ServerWithWChatShareAppKey:(NSString *)WChatShareAppKey andWithLaunchOptions:(NSDictionary *)launchOptions{
    if(WChatShareAppKey){
        [WXApi registerApp:WChatShareAppKey];
    }else{
        [WXApi registerApp:@"wxc3d27f07b30b3b66"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(application_DataBase_willTerminateHandle:) name:UIApplicationWillTerminateNotification object:nil];

}
#pragma mark 微信分享

/**
 打开url

 @param url url
 @return 结果
 */
- (BOOL)applicationOpenURL:(NSURL *)url
{
    //    NSLog(@"%@",options);
    return [WXApi handleOpenURL:url delegate:self];;
}

-(void)onReq:(BaseReq *)req{

}
-(void)onResp:(BaseResp *)resp{


    /*
     enum  WXErrCode {
     WXSuccess           = 0,    成功
     WXErrCodeCommon     = -1,  普通错误类型
     WXErrCodeUserCancel = -2,    用户点击取消并返回
     WXErrCodeSentFail   = -3,   发送失败
     WXErrCodeAuthDeny   = -4,    授权失败
     WXErrCodeUnsupport  = -5,   微信不支持
     };
     */
    [[NSNotificationCenter defaultCenter]postNotificationName:HGBWChatShareReslutNoti object:@{ReslutCode:@(resp.errCode),ReslutMessage:resp.errStr}];

}
@end
