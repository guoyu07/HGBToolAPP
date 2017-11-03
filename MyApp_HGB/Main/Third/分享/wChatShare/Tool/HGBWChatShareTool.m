//
//  HGBWChatShareTool.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/11/1.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBWChatShareTool.h"
#import "WXApi.h"
#import "WechatAuthSDK.h"
#import "WXApiObject.h"

#define ReslutCode @"reslutCode"
#define ReslutMessage @"reslutMessage"
#define ReslutError @"reslutError"


@interface HGBWChatShareTool ()
@property(strong,nonatomic)id<HGBWChatShareToolDelegate>delegate;
@end

@implementation HGBWChatShareTool
#pragma mark init
static HGBWChatShareTool *instance=nil;
/**
 单例

 @return 实例
 */
+ (instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBWChatShareTool alloc]init];
        [[NSNotificationCenter defaultCenter]addObserver:instance selector:@selector(wChatShareReslutNotiHandle:) name:HGBWChatShareReslutNoti object:nil];
    }
    return instance;
}
#pragma mark func
/**
 分享到微信聊天

 @param title 标题
 @param details 详细介绍
 @param url 链接
 @param thumImage 提示图片
 */
+(void)shareToWChatSceneSessionWithTitle:(NSString *)title andWithDetails:(NSString *)details andWithUrl:(NSString *)url andWithThumImage:(UIImage *)thumImage andWithDelegate:(id<HGBWChatShareToolDelegate>)delegate{
    [HGBWChatShareTool shareInstance];
    instance.delegate=delegate;

    //微信分享
    if(![WXApi isWXAppInstalled]){
        if(instance.delegate&&[instance.delegate respondsToSelector:@selector(wChatShare:didShareWithShareStatus:andWithReslutInfo:)]){
            [instance.delegate wChatShare:instance didShareWithShareStatus:HGBWChatShareStatusErrorUnInstall andWithReslutInfo:@{ReslutCode:@(2),ReslutMessage:@"未安装微信"}];
        }

        return;
    }

    WXMediaMessage *message=[WXMediaMessage message];
    if(title){
        message.title=title;
    }else{
        message.title=[HGBWChatShareTool getAppName];
    }
    message.description=details;
    if(thumImage){
        [message setThumbImage:thumImage];
    }else{
        if([HGBWChatShareTool getAppImage]){
            [message setThumbImage:[HGBWChatShareTool getAppImage]];
        }

    }


    WXWebpageObject *webPageObject=[WXWebpageObject object];
    if(url){
        webPageObject.webpageUrl=url;
    }
    message.mediaObject=webPageObject;
    SendMessageToWXReq *send=[[SendMessageToWXReq alloc]init];
    send.bText=NO;
    send.message=message;
    send.scene=WXSceneSession;
    [WXApi sendReq:send];
}
/**
 分享到朋友圈
 @param details 详细介绍-默认空
 @param url 链接
 @param thumImage 提示图片-默认应用图标
 */
+(void)shareToWChatSceneTimelineWithDetails:(NSString *)details andWithUrl:(NSString *)url andWithThumImage:(UIImage *)thumImage andWithDelegate:(id<HGBWChatShareToolDelegate>)delegate{
    [HGBWChatShareTool shareInstance];
    instance.delegate=delegate;

    //微信分享
    if(![WXApi isWXAppInstalled]){
        if(instance.delegate&&[instance.delegate respondsToSelector:@selector(wChatShare:didShareWithShareStatus:andWithReslutInfo:)]){
            [instance.delegate wChatShare:instance didShareWithShareStatus:HGBWChatShareStatusErrorUnInstall andWithReslutInfo:@{ReslutCode:@(2),ReslutMessage:@"未安装微信"}];
        }

        return;
    }

    WXMediaMessage *message=[WXMediaMessage message];
    message.description=details;
    if(thumImage){
        [message setThumbImage:thumImage];
    }else{
        if([HGBWChatShareTool getAppImage]){
            [message setThumbImage:[HGBWChatShareTool getAppImage]];
        }

    }


    WXWebpageObject *webPageObject=[WXWebpageObject object];
    if(url){
        webPageObject.webpageUrl=url;
    }
    message.mediaObject=webPageObject;
    SendMessageToWXReq *send=[[SendMessageToWXReq alloc]init];
    send.bText=NO;
    send.message=message;
    send.scene=WXSceneTimeline;
    [WXApi sendReq:send];
}
/**
 搜藏

 @param title 标题-默认app名称
 @param details 详细介绍-默认空
 @param url 链接
 @param thumImage 提示图片-默认应用图标
 */
+(void)collectToWChatSceneFavoriteWithTitle:(NSString *)title andWithDetails:(NSString *)details andWithUrl:(NSString *)url andWithThumImage:(UIImage *)thumImage andWithDelegate:(id<HGBWChatShareToolDelegate>)delegate{
    [HGBWChatShareTool shareInstance];
    instance.delegate=delegate;

    //微信分享
    if(![WXApi isWXAppInstalled]){
        if(instance.delegate&&[instance.delegate respondsToSelector:@selector(wChatShare:didShareWithShareStatus:andWithReslutInfo:)]){
            [instance.delegate wChatShare:instance didShareWithShareStatus:HGBWChatShareStatusErrorUnInstall andWithReslutInfo:@{ReslutCode:@(2),ReslutMessage:@"未安装微信"}];
        }

        return;
    }

    WXMediaMessage *message=[WXMediaMessage message];
    if(title){
        message.title=title;
    }else{
        message.title=[HGBWChatShareTool getAppName];
    }
    message.description=details;
    if(thumImage){
        [message setThumbImage:thumImage];
    }else{
        if([HGBWChatShareTool getAppImage]){
            [message setThumbImage:[HGBWChatShareTool getAppImage]];
        }

    }


    WXWebpageObject *webPageObject=[WXWebpageObject object];
    if(url){
        webPageObject.webpageUrl=url;
    }
    message.mediaObject=webPageObject;
    SendMessageToWXReq *send=[[SendMessageToWXReq alloc]init];
    send.bText=NO;
    send.message=message;
    send.scene=WXSceneFavorite;
    [WXApi sendReq:send];
}
#pragma mark noti
-(void)wChatShareReslutNotiHandle:(NSNotification *)noti{

}
#pragma mark 获取app信息
/**
 获取app图标

 @return app图标
 */
+(UIImage *)getAppImage{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];

    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];

    UIImage* image = [UIImage imageNamed:icon];
    return image;
}
/**
 获取app的名字

 @return app的名字
 */
+(NSString*) getAppName

{

    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];

    return appName;

}
@end
