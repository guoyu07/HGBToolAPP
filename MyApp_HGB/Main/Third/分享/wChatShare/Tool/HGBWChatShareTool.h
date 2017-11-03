//
//  HGBWChatShareTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/11/1.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#import "HGBWChatShareHeader.h"


@class HGBWChatShareTool;
/**
 微信分享代理
 */
@protocol HGBWChatShareToolDelegate <NSObject>
/**
 分享结果

 @param wChatShare 微信分享
 @param status 分享状态
 @param reslutInfo 信息
 */
-(void)wChatShare:(HGBWChatShareTool *)wChatShare didShareWithShareStatus:(HGBWChatShareStatus)status andWithReslutInfo:(NSDictionary *)reslutInfo;

@end


@interface HGBWChatShareTool : NSObject
/**
 分享到微信聊天

 @param title 标题-默认app名称
 @param details 详细介绍-默认空
 @param url 链接
 @param thumImage 提示图片-默认应用图标
 */
+(void)shareToWChatSceneSessionWithTitle:(NSString *)title andWithDetails:(NSString *)details andWithUrl:(NSString *)url andWithThumImage:(UIImage *)thumImage andWithDelegate:(id<HGBWChatShareToolDelegate>)delegate;
/**
 分享到朋友圈
 @param details 详细介绍-默认空
 @param url 链接
 @param thumImage 提示图片-默认应用图标
 */
+(void)shareToWChatSceneTimelineWithDetails:(NSString *)details andWithUrl:(NSString *)url andWithThumImage:(UIImage *)thumImage andWithDelegate:(id<HGBWChatShareToolDelegate>)delegate;
/**
 搜藏

 @param title 标题-默认app名称
 @param details 详细介绍-默认空
 @param url 链接
 @param thumImage 提示图片-默认应用图标
 */
+(void)collectToWChatSceneFavoriteWithTitle:(NSString *)title andWithDetails:(NSString *)details andWithUrl:(NSString *)url andWithThumImage:(UIImage *)thumImage andWithDelegate:(id<HGBWChatShareToolDelegate>)delegate;
@end
