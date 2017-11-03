//
//  AppDelegate+HGBUMShare.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/11/2.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate+HGBUMShare.h"
#import <UMSocialCore/UMSocialCore.h>


@implementation AppDelegate (HGBUMShare)
/**
 友盟分享初始化

 @param launchOptions 加载参数
 */
-(void)init_UMShare_ServerWithLaunchOptions:(NSDictionary *)launchOptions{
    [self UMShareInit];

}
#pragma mark 友盟分享初始化
/**
 分享初始化
 */
-(void)UMShareInit{
    /* 打开日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    // 打开图片水印
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;
    NSDictionary *configDic=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HGBUMShare.plist" ofType:nil]];
    NSString *UMAppKey=[configDic objectForKey:@"appKey"];
    if(UMAppKey){
        /* 设置友盟appkey */
        [[UMSocialManager defaultManager] setUmSocialAppkey:UMAppKey];
        [self configUSharePlatforms];
        [self confitUShareSettings];
    }

}

/**
 分享基础设置
 */
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;

    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;

}
/**
 分享平台设置
 */
- (void)configUSharePlatforms
{

    NSDictionary *configDic=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SharePlugin.plist" ofType:nil]];
    NSDictionary *shareMenu=[configDic objectForKey:@"shareMenu"];

    NSDictionary *WechatSessionDic=[shareMenu objectForKey:@"WechatSession"];
    NSString *wechatAppKey=[WechatSessionDic objectForKey:@"appKey"];
    NSString *wechatAppSecret=[WechatSessionDic objectForKey:@"appSecret"];
    NSString *wechatRedirectURL=[WechatSessionDic objectForKey:@"redirectURL"];
    if(wechatAppKey&&wechatAppKey.length!=0&&wechatAppSecret&&wechatAppSecret.length!=0&&wechatRedirectURL&&wechatRedirectURL.length!=0){
        /* 设置微信的appKey和appSecret */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:wechatAppKey appSecret:wechatAppSecret redirectURL:wechatRedirectURL];
        /*
         * 移除相应平台的分享，如微信收藏
         */
        [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    }


    NSDictionary *QQDic=[shareMenu objectForKey:@"QQ"];
    NSString *QQAppKey=[QQDic objectForKey:@"appKey"];
    NSString *QQRedirectURL=[QQDic objectForKey:@"redirectURL"];
    if(QQAppKey&&QQAppKey.length!=0&&QQRedirectURL&&QQRedirectURL.length!=0){
        /* 设置分享到QQ互联的appID
         * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
         100424468.no permission of union id
         */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppKey/*设置QQ平台的appID*/  appSecret:nil redirectURL:QQRedirectURL];
    }
    NSDictionary *SinaDic=[shareMenu objectForKey:@"Sina"];
    NSString *SinaAppKey=[SinaDic objectForKey:@"appKey"];
    NSString *SinaAppSecret=[SinaDic objectForKey:@"appSecret"];
    NSString *SinaRedirectURL=[SinaDic objectForKey:@"redirectURL"];
    if(SinaAppKey&&SinaAppKey.length!=0&&SinaAppSecret&&SinaAppSecret.length!=0&&SinaRedirectURL&&SinaRedirectURL.length!=0){
        /* 设置新浪的appKey和appSecret */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SinaAppKey  appSecret:SinaAppSecret redirectURL:SinaRedirectURL];
    }



    NSDictionary *DingDingDic=[shareMenu objectForKey:@"DingDing"];
    NSString *DingDingAppKey=[DingDingDic objectForKey:@"appKey"];

    if(DingDingAppKey&&DingDingAppKey.length!=0){
        /* 钉钉的appKey */
        [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DingDing appKey:DingDingAppKey appSecret:nil redirectURL:nil];
    }


    NSDictionary *AlipaySessionDic=[shareMenu objectForKey:@"AlipaySession"];
    NSString *AlipaySessionAppKey=[AlipaySessionDic objectForKey:@"appKey"];

    NSString *AlipaySessionRedirectURL=[WechatSessionDic objectForKey:@"redirectURL"];
    if(AlipaySessionAppKey&&AlipaySessionAppKey.length!=0&&AlipaySessionRedirectURL&&AlipaySessionRedirectURL.length!=0){
        /* 支付宝的appKey */
        [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:AlipaySessionAppKey appSecret:nil redirectURL:AlipaySessionRedirectURL];
    }



    NSDictionary *YixinSessionDic=[shareMenu objectForKey:@"YixinSession"];
    NSString *YixinSessionAppKey=[YixinSessionDic objectForKey:@"appKey"];

    NSString *YixinSessionRedirectURL=[YixinSessionDic objectForKey:@"redirectURL"];
    if(YixinSessionAppKey&&YixinSessionAppKey.length!=0&&YixinSessionRedirectURL&&YixinSessionRedirectURL.length!=0){
        /* 设置易信的appKey */
        [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_YixinSession appKey:YixinSessionAppKey appSecret:nil redirectURL:YixinSessionRedirectURL];
    }

    NSDictionary *LaiWangSessionDic=[shareMenu objectForKey:@"LaiWangSession"];
    NSString *LaiWangSessionAppKey=[LaiWangSessionDic objectForKey:@"appKey"];
    NSString *LaiWangSessionAppSecret=[LaiWangSessionDic objectForKey:@"appSecret"];
    NSString *LaiWangSessionRedirectURL=[LaiWangSessionDic objectForKey:@"redirectURL"];
    if(LaiWangSessionAppKey&&LaiWangSessionAppKey.length!=0&&LaiWangSessionAppSecret&&LaiWangSessionAppSecret.length!=0&&LaiWangSessionRedirectURL&&LaiWangSessionRedirectURL.length!=0){
        /* 设置点点虫（原来往）的appKey和appSecret */
        [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_LaiWangSession appKey:LaiWangSessionAppKey appSecret:LaiWangSessionAppSecret redirectURL:LaiWangSessionRedirectURL];
    }

    NSDictionary *LinkedinDic=[shareMenu objectForKey:@"Linkedin"];
    NSString *LinkedinAppKey=[LinkedinDic objectForKey:@"appKey"];
    NSString *LinkedinAppSecret=[LinkedinDic objectForKey:@"appSecret"];
    NSString *LinkedinRedirectURL=[LinkedinDic objectForKey:@"redirectURL"];
    if(LinkedinAppKey&&LinkedinAppKey.length!=0&&LinkedinAppSecret&&LinkedinAppSecret.length!=0&&LinkedinRedirectURL&&LinkedinRedirectURL.length!=0){
        /* 设置领英的appKey和appSecret */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Linkedin appKey:LinkedinAppKey  appSecret:LinkedinAppSecret redirectURL:LinkedinRedirectURL];
    }

    NSDictionary *TwitterDic=[shareMenu objectForKey:@"Twitter"];
    NSString *TwitterAppKey=[TwitterDic objectForKey:@"appKey"];
    NSString *TwitterAppSecret=[TwitterDic objectForKey:@"appSecret"];

    if(TwitterAppKey&&TwitterAppKey.length!=0&&TwitterAppSecret&&TwitterAppSecret.length!=0){
        /* 设置Twitter的appKey和appSecret */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:TwitterAppKey  appSecret:TwitterAppSecret redirectURL:nil];
    }

    NSDictionary *FacebookDic=[shareMenu objectForKey:@"Facebook"];
    NSString *FacebookAppKey=[FacebookDic objectForKey:@"appKey"];

    NSString *FacebookRedirectURL=[FacebookDic objectForKey:@"redirectURL"];
    if(FacebookAppKey&&FacebookAppKey.length!=0&&FacebookRedirectURL&&FacebookRedirectURL.length!=0){
        /* 设置Facebook的appKey和UrlString */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:FacebookAppKey  appSecret:nil redirectURL:FacebookRedirectURL];
    }

    NSDictionary *PinterestDic=[shareMenu objectForKey:@"Pinterest"];
    NSString *PinterestAppKey=[PinterestDic objectForKey:@"appKey"];

    if(PinterestAppKey&&PinterestAppKey.length!=0){
        /* 设置Pinterest的appKey */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Pinterest appKey:PinterestAppKey  appSecret:nil redirectURL:nil];
    }

    NSDictionary *DropBoxDic=[shareMenu objectForKey:@"DropBox"];
    NSString *DropBoxAppKey=[DropBoxDic objectForKey:@"appKey"];
    NSString *DropBoxAppSecret=[DropBoxDic objectForKey:@"appSecret"];
    NSString *DropBoxRedirectURL=[DropBoxDic objectForKey:@"redirectURL"];
    if(DropBoxAppKey&&DropBoxAppKey.length!=0&&DropBoxAppSecret&&DropBoxAppSecret.length!=0&&DropBoxRedirectURL&&DropBoxRedirectURL.length!=0){
        /* dropbox的appKey */
        [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DropBox appKey:DropBoxAppKey appSecret:DropBoxAppSecret redirectURL:DropBoxRedirectURL];
    }

    NSDictionary *VKontakteDic=[shareMenu objectForKey:@"VKontakte"];
    NSString *VKontakteAppKey=[VKontakteDic objectForKey:@"appKey"];

    if(VKontakteAppKey&&VKontakteAppKey.length!=0){
        /* vk的appkey */
        [[UMSocialManager defaultManager]  setPlaform:UMSocialPlatformType_VKontakte appKey:VKontakteAppKey appSecret:nil redirectURL:nil];
    }

}

//#define __IPHONE_10_0    100000
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


@end
