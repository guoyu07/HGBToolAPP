//
//  HGBUMShareTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/11/2.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
//com.camelot.Club
#import <UMSocialCore/UMSocialCore.h>

typedef NS_ENUM(NSUInteger, UMS_SHARE_TYPE)
{
    UMS_SHARE_TYPE_TEXT,//文本
    UMS_SHARE_TYPE_IMAGE,//图片
    UMS_SHARE_TYPE_IMAGE_URL,//网络图片
    UMS_SHARE_TYPE_TEXT_IMAGE,//文本与图片
    UMS_SHARE_TYPE_WEB_LINK,//网页
    UMS_SHARE_TYPE_MUSIC_LINK,//网络音乐
    UMS_SHARE_TYPE_MUSIC,//音乐
    UMS_SHARE_TYPE_VIDEO_LINK,//网络视频
    UMS_SHARE_TYPE_VIDEO,//视频
    UMS_SHARE_TYPE_EMOTION,
    UMS_SHARE_TYPE_FILE,//文件
    UMS_SHARE_TYPE_MINI_PROGRAM//小程序
};
@interface HGBUMShareTool : NSObject
#pragma mark 参数
/*
 分享链接
 */
@property(strong,nonatomic)NSString *shareUrl;
/*
 分享标题
 */
@property(strong,nonatomic)NSString *shareTitle;
/*
 分享内容
 */
@property(strong,nonatomic)NSString *shareDescription;
/*
 分享图片
 */
@property(strong,nonatomic)UIImage *shareImage;
/*
 分享小图标
 */
@property(strong,nonatomic)UIImage *shareThumImage;
/*
 分享种类
 */
@property(strong,nonatomic)NSArray *shareTypes;
#pragma mark init
/**
 单例

 @return 实例
 */
+ (instancetype)shareInstance;
#pragma mark 统一分享-需要配置参数

#pragma mark 具体分享
/**
 *  分享文本
 *
 *  @param title     标题
 *  @param text     文本
 *
 *  @param CompleteBlock 返回结果
 */
+ (void)shareTextWithTitle:(NSString *)title andWithText:(NSString *)text ToPlatformType:(UMSocialPlatformType)platformType andWithCompleteBlock:(void (^)(NSString *status))CompleteBlock;

/**
 *  分享图片
 *
 *  @param image     图片
 *  @param thumbImage     缩略图
 *
 *  @param CompleteBlock 返回结果
 */
+ (void)shareImageWithImage:(UIImage *)image andWithThumbImage:(UIImage *)thumbImage  ToPlatformType:(UMSocialPlatformType)platformType andWithCompleteBlock:(void (^)(NSString *status))CompleteBlock;

/**
 *  分享网络图片
 *
 *  @param imageurl     图片
 *  @param thumbImageurl     缩略图
 *
 *  @param CompleteBlock 返回结果
 */
+ (void)shareNetImageWithImageUrl:(NSString *)imageurl andWithThumbImage:(NSString *)thumbImageurl ToPlatformType:(UMSocialPlatformType)platformType andWithCompleteBlock:(void (^)(NSString *status))CompleteBlock;

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
+(void)shareTextAndImageWithTitle:(NSString *)title andWithText:(NSString *)text andWithImage:(UIImage *)image andWithThumbImage:(UIImage *)thumbImage ToPlatformType:(UMSocialPlatformType)platformType andWithCompleteBlock:(void (^)(NSString *status))CompleteBlock;
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
@end
