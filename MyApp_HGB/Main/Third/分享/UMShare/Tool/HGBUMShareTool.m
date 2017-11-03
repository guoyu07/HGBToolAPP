
//
//  HGBUMShareTool.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/11/2.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBUMShareTool.h"
#import "AppDelegate+HGBUMShare.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>

@interface HGBUMShareTool ()<UMSocialShareMenuViewDelegate>

@property (nonatomic, assign) UMSocialPlatformType platformType;
@property (nonatomic, assign) UMS_SHARE_TYPE shareType;


@property (nonatomic, strong) NSDictionary *platfomrSupportTypeDict;
@end
@implementation HGBUMShareTool
#pragma mark init
static HGBUMShareTool *instance=nil;
/**
 单例

 @return 实例
 */
+ (instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBUMShareTool alloc]init];
    }
    return instance;
}
#pragma mark 分享
/**
 *  友盟分享
 *
 *  @param command h5传值-
 1.url：分享的url
 2 title：分享的标题
 3.description：分享描述
 返回状态：
 1.    0：分享成功。
 2.    1：分享取消
 3.    2：分享失败
 */

/**
 *  通用分享
 *  @param shareType     类型
 *
 *  @param CompleteBlock 返回结果
 */
+(void)shareWithPlatformType:(UMS_SHARE_TYPE)shareType
        andWithCompleteBlock:(void (^)(NSString *status))CompleteBlock{
    [HGBUMShareTool shareInstance];
    instance.shareType=shareType;
    [HGBUMShareTool setUMSharePlatforms];

}
/**
 设置友盟分享平台
 */
+ (void)setUMSharePlatforms
{
    [HGBUMShareTool shareInstance];

    //设置用户自定义的平台
    [UMSocialUIManager setPreDefinePlatforms:instance.shareTypes];

    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRoundAndSuperRadius;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        instance.platformType=platformType;
        [HGBUMShareTool shareWithType:instance.platformType];
    }];
}
//
/**
 设置友盟分享-类型

 @param type 友盟分享-类型
 */
+ (void)shareWithType:(UMS_SHARE_TYPE)type
{
    switch (type) {
        case UMS_SHARE_TYPE_TEXT:
        {
            [HGBUMShareTool shareTextWithTitle:instance.shareTitle andWithText:instance.shareDescription ToPlatformType:instance.platformType andWithCompleteBlock:^(NSString *status) {
                [HGBUMShareTool returnReslutWithStatus:status];
            }];
        }
            break;
        case UMS_SHARE_TYPE_IMAGE:
        {

        }
            break;
        case UMS_SHARE_TYPE_IMAGE_URL:
        {

        }
            break;
        case UMS_SHARE_TYPE_TEXT_IMAGE:
        {
            [HGBUMShareTool shareTextAndImageWithTitle:instance.shareTitle andWithText:instance.shareDescription andWithImage:nil andWithThumbImage:nil ToPlatformType:instance.platformType andWithCompleteBlock:^(NSString *status) {
                [HGBUMShareTool returnReslutWithStatus:status];
            }];
        }
            break;
        case UMS_SHARE_TYPE_WEB_LINK:
        {
            [HGBUMShareTool shareWebPageWithWeburl:instance.shareUrl andWithTitle:instance.shareTitle andWithText:instance.shareDescription andWithImage:nil andWithThumbImage:nil ToPlatformType:instance.platformType andWithCompleteBlock:^(NSString *status) {
                [self returnReslutWithStatus:status];

            }];
        }
            break;
        case UMS_SHARE_TYPE_MUSIC_LINK:
        {

        }
            break;
        case UMS_SHARE_TYPE_MUSIC:
        {

        }
            break;
        case UMS_SHARE_TYPE_VIDEO_LINK:
        {

        }
            break;
        case UMS_SHARE_TYPE_VIDEO:
        {

        }
            break;
        case UMS_SHARE_TYPE_EMOTION:
        {

        }
            break;
        case UMS_SHARE_TYPE_FILE:
        {

        }
            break;
        case UMS_SHARE_TYPE_MINI_PROGRAM:
        {

        }
            break;
        default:
            break;
    }
}
+(void)returnReslutWithStatus:(NSString *)status{
    
}
#pragma mark - UMSocialShareMenuViewDelegate
- (void)UMSocialShareMenuViewDidAppear
{
    NSLog(@"UMSocialShareMenuViewDidAppear");
}
- (void)UMSocialShareMenuViewDidDisappear
{
    NSLog(@"UMSocialShareMenuViewDidDisappear");
}

//不需要改变父窗口则不需要重写此协议
- (UIView*)UMSocialParentView:(UIView*)defaultSuperView
{
    return defaultSuperView;
}
#pragma mark 具体分享
/**
 *  分享文本
 *
 *  @param title     标题
 *  @param text     文本
 *
 *  @param CompleteBlock 返回结果
 */
+ (void)shareTextWithTitle:(NSString *)title andWithText:(NSString *)text ToPlatformType:(UMSocialPlatformType)platformType andWithCompleteBlock:(void (^)(NSString *status))CompleteBlock
{
     [HGBUMShareTool shareInstance];
    if(text==nil||text.length==0){
        text=@"";
    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = text;
    messageObject.title=title;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[HGBUMShareTool currentViewController] completion:^(id data, NSError *error) {
        if (error) {
            NSDictionary *userInfodic=error.userInfo;
            NSString *message=[userInfodic objectForKey:@"message"];
            if([message containsString:@"cancel"]){
                CompleteBlock(@"1");
            }else{
                CompleteBlock(@"2");
            }
        }else{
            CompleteBlock(@"0");
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                //UMSocialShareResponse *resp = data;


            }else{

            }
        }
    }];
}

/**
 *  分享图片
 *
 *  @param image     图片
 *  @param thumbImage     缩略图
 *
 *  @param CompleteBlock 返回结果
 */
+(void)shareImageWithImage:(UIImage *)image andWithThumbImage:(UIImage *)thumbImage ToPlatformType:(UMSocialPlatformType)platformType andWithCompleteBlock:(void (^)(NSString *status))CompleteBlock
{
     [HGBUMShareTool shareInstance];
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];

    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    if(!image){
        image = [UIImage imageNamed:icon];
    }
    if(!thumbImage){
        thumbImage = [UIImage imageNamed:icon];
    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图本地
    shareObject.thumbImage =thumbImage;
    [shareObject setShareImage:image];

    // 设置Pinterest参数
    if (platformType == UMSocialPlatformType_Pinterest) {
        [HGBUMShareTool setPinterstInfo:messageObject];
    }

    // 设置Kakao参数
    if (platformType == UMSocialPlatformType_KakaoTalk) {
        messageObject.moreInfo = @{@"permission" : @1}; // @1 = KOStoryPermissionPublic
    }

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[HGBUMShareTool currentViewController] completion:^(id data, NSError *error) {
        if (error) {
            NSDictionary *userInfodic=error.userInfo;
            NSString *message=[userInfodic objectForKey:@"message"];
            if([message containsString:@"cancel"]){
                CompleteBlock(@"1");
            }else{
                CompleteBlock(@"2");
            }
        }else{
            CompleteBlock(@"0");
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;


            }else{

            }
        }
    }];
}
/**
 *  分享网络图片
 *
 *  @param imageurl     图片
 *  @param thumbImageurl     缩略图
 *
 *  @param CompleteBlock 返回结果
 */
+ (void)shareNetImageWithImageUrl:(NSString *)imageurl andWithThumbImage:(NSString *)thumbImageurl ToPlatformType:(UMSocialPlatformType)platformType andWithCompleteBlock:(void (^)(NSString *status))CompleteBlock{
     [HGBUMShareTool shareInstance];
    if(imageurl==nil||imageurl.length==0||thumbImageurl==nil||thumbImageurl.length==0){
        [HGBUMShareTool alertWithPrompt:@"网络图片连接不能为空!"];
    }

    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = thumbImageurl;

    [shareObject setShareImage:imageurl];

    // 设置Pinterest参数
    if (platformType == UMSocialPlatformType_Pinterest) {
        [HGBUMShareTool setPinterstInfo:messageObject];
    }

    // 设置Kakao参数
    if (platformType == UMSocialPlatformType_KakaoTalk) {
        messageObject.moreInfo = @{@"permission" : @1}; // @1 = KOStoryPermissionPublic
    }

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[HGBUMShareTool currentViewController] completion:^(id data, NSError *error) {
        if (error) {
            NSDictionary *userInfodic=error.userInfo;
            NSString *message=[userInfodic objectForKey:@"message"];
            if([message containsString:@"cancel"]){
                CompleteBlock(@"1");
            }else{
                CompleteBlock(@"2");
            }
        }else{
            CompleteBlock(@"0");
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;


            }else{

            }
        }
    }];
}
/**
 *  分享图片与文本
 *
 *  @param title     标题
 *  @param text     文本
 *  @param image     图片
 *  @param thumbImage     缩略图
 *
 *  @param CompleteBlock 返回结果
 */
+ (void)shareTextAndImageWithTitle:(NSString *)title andWithText:(NSString *)text andWithImage:(UIImage *)image andWithThumbImage:(UIImage *)thumbImage ToPlatformType:(UMSocialPlatformType)platformType andWithCompleteBlock:(void (^)(NSString *status))CompleteBlock
{
     [HGBUMShareTool shareInstance];
    if(text==nil||text.length==0){
        text=@"";
    }
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];

    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    if(image==nil){
        image = [UIImage imageNamed:icon];
    }
    if(thumbImage==nil){
        thumbImage = [UIImage imageNamed:icon];
    }
    NSLog(@"%@",thumbImage);
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //设置文本
    messageObject.text = text;
    messageObject.title=title;

    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    if (platformType == UMSocialPlatformType_Linkedin) {
        // linkedin仅支持URL图片
        shareObject.thumbImage = thumbImage;
        [shareObject setShareImage:image];
    } else {
        shareObject.thumbImage = thumbImage;
        shareObject.shareImage = image;
    }

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[HGBUMShareTool currentViewController] completion:^(id data, NSError *error) {
        if (error) {
            NSDictionary *userInfodic=error.userInfo;
            NSString *message=[userInfodic objectForKey:@"message"];
            if([message containsString:@"cancel"]){
                CompleteBlock(@"1");
            }else{
                CompleteBlock(@"2");
            }
        }else{
            CompleteBlock(@"0");
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;


            }else{

            }
        }
    }];
}
/**
 *  网页分享
 *
 *  @param weburl     网页
 *  @param title     标题
 *  @param text     文本
 *  @param image     图片
 *  @param thumbImage     缩略图
 *
 *  @param CompleteBlock 返回结果
 */
+(void)shareWebPageWithWeburl:(NSString *)weburl andWithTitle:(NSString *)title andWithText:(NSString *)text andWithImage:(UIImage *)image andWithThumbImage:(UIImage *)thumbImage ToPlatformType:(UMSocialPlatformType)platformType andWithCompleteBlock:(void (^)(NSString *status))CompleteBlock;
{
     [HGBUMShareTool shareInstance];
    if(text==nil||text.length==0){
        text=@"";
    }
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];

    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    if(image==nil){
        image = [UIImage imageNamed:icon];
    }
    if(thumbImage==nil){
        thumbImage = [UIImage imageNamed:icon];
    }

    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:text thumImage:thumbImage];
    //设置网页地址
    shareObject.webpageUrl = weburl;


    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[HGBUMShareTool currentViewController] completion:^(id data, NSError *error) {
        if (error) {
            NSDictionary *userInfodic=error.userInfo;
            NSString *message=[userInfodic objectForKey:@"message"];
            if([message containsString:@"cancel"]){
                CompleteBlock(@"1");
            }else{
                CompleteBlock(@"2");
            }
        }else{
            CompleteBlock(@"0");
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;


            }else{

            }
        }
    }];
}
#pragma mark 错误提示
+(void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}
+(void)alertWithPrompt:(NSString *)prompt
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share" message:prompt delegate:nil cancelButtonTitle:NSLocalizedString(@"sure", @"确定") otherButtonTitles:nil];
    [alert show];
}
/**
 *  设置平台相关参数
 *
 *  @param messageObj     分享信息
 *
 */
+ (void)setPinterstInfo:(UMSocialMessageObject *)messageObj
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSDictionary *configDic=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SharePlugin.plist" ofType:nil]];
    // app名称
    NSString *app_Name = [configDic objectForKey:@"app_name"];
    if(app_Name==nil||app_Name.length==0){
        app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        if(app_Name==nil||app_Name.length==0){
            app_Name = @"text";
        }
    }

    // source_url

    NSString *source_url = [configDic objectForKey:@"source_url"];
    if(source_url==nil||source_url.length==0){
        source_url = @"http://www.baidu.com";
    }


    // description

    NSString *description = [configDic objectForKey:@"description"];
    if(description==nil||description.length==0){
        description = @"description";
    }

    // suggested_board_name

    NSString *suggested_board_name = [configDic objectForKey:@"suggested_board_name"];
    if(suggested_board_name==nil||suggested_board_name.length==0){
        suggested_board_name = @"board_name";
    }
    messageObj.moreInfo =
    @{@"source_url":
          source_url,
      @"app_name":
          app_Name,
      @"suggested_board_name":
          suggested_board_name,
      @"description":
          description
      };
}
#pragma mark 获取当前控制器
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [HGBUMShareTool findBestViewController:viewController];
}
+ (UIViewController *)findBestViewController:(UIViewController *)vc
{
    if (vc.presentedViewController) {
        // Return presented view controller
        return [HGBUMShareTool findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
            return [HGBUMShareTool findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0)
            return [HGBUMShareTool findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
            return [HGBUMShareTool findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}
#pragma mark get
-(NSString *)shareTitle{
    if(_shareTitle==nil){
        _shareTitle=@"title";
    }
    return _shareTitle;
}
-(NSString *)shareDescription{
    if(_shareDescription==nil){
        _shareDescription=@"description";
    }
    return _shareDescription;
}
-(NSString *)shareUrl{
    if(_shareUrl==nil){
        _shareUrl=@"http://www.baidu.com";
    }
    return _shareUrl;
}
-(NSDictionary *)platfomrSupportTypeDict{
    if(_platfomrSupportTypeDict==nil){
        self.platfomrSupportTypeDict =
        @{
          @(UMSocialPlatformType_WechatSession): @(UMS_SHARE_TYPE_TEXT_IMAGE),
          @(UMSocialPlatformType_WechatTimeLine): @(UMS_SHARE_TYPE_TEXT_IMAGE),
          @(UMSocialPlatformType_Sina): @(UMS_SHARE_TYPE_TEXT_IMAGE),
          @(UMSocialPlatformType_QQ): @(UMS_SHARE_TYPE_TEXT_IMAGE),
          @(UMSocialPlatformType_Qzone): @(UMS_SHARE_TYPE_TEXT_IMAGE),
          @(UMSocialPlatformType_Sms): @(UMS_SHARE_TYPE_TEXT_IMAGE),

          };
    }
    return _platfomrSupportTypeDict;
}
-(NSArray *)shareTypes{
    if(_shareTypes==nil){
        _shareTypes=@[
                      @(UMSocialPlatformType_WechatSession),
                      @(UMSocialPlatformType_WechatTimeLine),

                      @(UMSocialPlatformType_QQ),
                      @(UMSocialPlatformType_Qzone),
                      @(UMSocialPlatformType_Sina),
                      @(UMSocialPlatformType_TencentWb),

                      @(UMSocialPlatformType_Sms),

                      @(UMSocialPlatformType_UserDefine_Begin+1),
                      @(UMSocialPlatformType_UserDefine_End),
                      ];
    }
    return _shareTypes;
}
@end
