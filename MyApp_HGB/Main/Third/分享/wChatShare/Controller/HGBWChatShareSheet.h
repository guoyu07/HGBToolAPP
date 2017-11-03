//
//  HGBWChatShareSheet.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/11/1.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBWChatShareTool.h"
#import "HGBWChatShareHeader.h"

@class HGBWChatShareSheet;
/**
 微信分享代理
 */
@protocol HGBWChatShareSheetDelegate <NSObject>
/**
 分享结果

 @param wChatShareSheet 微信分享弹窗
 @param status 分享状态
 @param reslutInfo 信息
 */
-(void)wChatShareSheet:(HGBWChatShareSheet *)wChatShareSheet didShareWithShareStatus:(HGBWChatShareStatus)status andWithReslutInfo:(NSDictionary *)reslutInfo;

@end

/**
 微信分享
 */
@interface HGBWChatShareSheet : UIViewController
/**
 分享提示图
 */
@property(strong,nonatomic)UIImage *shareImage;
/**
 分享标题
 */
@property(strong,nonatomic)NSString *shareTitle;
/**
 分享详细介绍
 */
@property(strong,nonatomic)NSString *shareDetail;
/**
 分享链接
 */
@property(strong,nonatomic)NSString *shareUrl;
/**
 是否包含收藏
 */
@property(assign,nonatomic)BOOL isHaveFavorite;


/**
 创建
 */
+(instancetype)instanceWithParent:(UIViewController *)parent andWithDelegate:(id<HGBWChatShareSheetDelegate>)delegate;
/**
 弹出视图出现
 */
-(void)popInParentView;
@end
