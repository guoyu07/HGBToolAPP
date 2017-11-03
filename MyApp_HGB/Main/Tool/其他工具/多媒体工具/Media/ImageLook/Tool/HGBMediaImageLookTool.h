//
//  HGBMediaImageLookTool.h
//  测试
//
//  Created by huangguangbao on 2017/8/23.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HGBMediaImageLookTool;
/**
 快速预览
 */
@protocol HGBMediaImageLookToolDelegate <NSObject>
@optional
/**
 打开成功

 @param imageLook quickLook
 */
-(void)imageLookDidOpenSucessed:(HGBMediaImageLookTool *)imageLook;
/**
 打开失败

 @param imageLook quickLook
 */
-(void)imageLookDidOpenFailed:(HGBMediaImageLookTool *)imageLook;
/**
 关闭快速预览

 @param imageLook quickLook
 */
-(void)imageLookDidClose:(HGBMediaImageLookTool *)imageLook;

@end

@interface HGBMediaImageLookTool : NSObject
#pragma mark 设置
/**
 设置代理

 @param delegate 代理
 */
+(void)setWebLookDelegate:(id<HGBMediaImageLookToolDelegate>)delegate;


/**
 设置失败提示

 @param withoutFailPrompt 失败提示标志
 */
+(void)setWebLookWithoutFailPrompt:(BOOL)withoutFailPrompt;

#pragma mark 打开文件
/**
 快速浏览文件

 @param path 路径
 @param parent 父控制器
 */
+(void)lookFileAtPath:(NSString *)path inParent:(UIViewController *)parent;


/**
 快速浏览文件

 @param url 路径
 @param parent 父控制器
 */
+(void)lookFileAtUrl:(NSString *)url inParent:(UIViewController *)parent;
@end
