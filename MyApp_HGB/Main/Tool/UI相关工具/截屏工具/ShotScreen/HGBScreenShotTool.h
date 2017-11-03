//
//  HGBScreenShotTool.h
//  VirtualCard
//
//  Created by huangguangbao on 2017/6/24.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HGBScreenShotTool : NSObject
/**
 截屏

 @param view 要截屏的界面
 */
+(UIImage *)shotCurrentScreenWithView:(UIView *)view;
/**
 截屏
 
 @param webview 要截屏的界面
 */
+(UIImage *)shotFullScreenWithView:(UIWebView *)webview;
@end
