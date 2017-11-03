//
//  HGBWKWebController.h
//  测试app
//
//  Created by huangguangbao on 2017/7/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
/**
 基础浏览器代理
 */
@protocol  HGBWKWebControllerDelegate <NSObject>
@optional
@end
@interface HGBWKWebController : UIViewController<WKScriptMessageHandler>
@property(strong,nonatomic)id<HGBWKWebControllerDelegate>delegate;

/**
 导航栏
 
 @param title 标题
 */
-(void)createNavigationItemWithTitle:(NSString *)title;

/**
 加载url
 
 @param url url-完整url链接
 */
-(void)loadURL:(NSString *)url;
/**
 加载工程内url-简化url
 
 @param url url bundle往下路径
 */
-(void)loadBundleURL:(NSString *)url;
/**
 加载沙盒document文件夹下简化url
 
 @param url url document下路径
 */
-(void)loadDocumentURL:(NSString *)url;
/**
 加载沙盒文件夹下简化url
 
 @param url url 沙盒下路径
 */
-(void)loadMainURL:(NSString *)url;
/**
 加载html表单
 
 @param htmlString html内容
 */
-(void)loadHtmlString:(NSString *)htmlString;



/**
 打开工具栏
 
 @param type 打开方式 0 显示工具栏开启按钮 1直接显示工具栏
 */
-(void)openToolBarWithType:(NSInteger)type;
#pragma mark 沙盒途径
/**
 获取沙盒根路径
 
 @return 沙盒根路径
 */
-(NSString *)getHomeFilePath;
/**
 获取沙盒Document路径
 
 @return Document路径
 */
-(NSString *)getDocumentFilePath;
/**
 通过文件路径获取url
 
 @param filePath 文件路径
 @return url
 */
-(NSString *)getUrlFromFilePath:(NSString *)filePath;
@end
