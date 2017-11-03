//
//  HGBAppCheckTool.h
//  HelloCordova
//
//  Created by huangguangbao on 2017/8/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HGBAppCheckTool : NSObject
#pragma mark app自检
/**
 app自检
 */
+(void)appCheck;
#pragma mark 获取app数据
/**
 获取签名证书加密数据

 @return 签名证书加密数据
 */
+ (NSString *)getAppCodeSignatureData;

/**
 获取资源文件数据

 @return 资源文件数据
 */
+ (NSString *)getAppBinaryData;
#pragma mark 提示
/**
 展示内容

 @param prompt 提示
 */
+(void)alertWithPrompt:(NSString *)prompt;
@end
