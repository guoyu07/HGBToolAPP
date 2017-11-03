//
//  HGBHTMLToPDFTool.h
//  测试
//
//  Created by huangguangbao on 2017/8/28.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBHTMLtoPDF.h"


typedef void (^HGBHTMLtoPDFToolCompletionBlock)(BOOL status,NSDictionary *messageInfo);

@interface HGBHTMLToPDFTool : NSObject
#pragma mark 设置
/**
 设置失败提示

 @param withoutFailPrompt 失败提示标志
 */
+(void)setQuickLookWithoutFailPrompt:(BOOL)withoutFailPrompt;
#pragma mark 工具
/**
 通过HTML字符串创建PDF

 @param HTMLString HTML字符串
 @param PDFpath pdf路径
 @param compeleteBlock 完成回调
 
 */
+ (void)createPDFWithHTMLSting:(NSString*)HTMLString pathForPDF:(NSString*)PDFpath compeleteBlock:(HGBHTMLtoPDFToolCompletionBlock)compeleteBlock;
/**
 通过HTML字符串创建PDF

 @param HTMLPath HTML文件路径
 @param PDFpath pdf路径
 @param compeleteBlock 完成回调

 */
+ (void)createPDFWithHTMLPath:(NSString*)HTMLPath pathForPDF:(NSString*)PDFpath compeleteBlock:(HGBHTMLtoPDFToolCompletionBlock)compeleteBlock;

/**
 通过HTML字符串创建PDF

 @param HTMLUrl HTML URL
 @param PDFpath pdf路径
 @param compeleteBlock 完成回调

 */
+ (void)createPDFWithHTMLUrl:(NSString*)HTMLUrl pathForPDF:(NSString*)PDFpath compeleteBlock:(HGBHTMLtoPDFToolCompletionBlock)compeleteBlock;
@end
