//
//  HGBQROrBarCodeTool.h
//  VirtualCard
//
//  Created by huangguangbao on 2017/6/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HGBQROrBarCodeTool : NSObject

#pragma mark 二维码生成-普通
/**
 *   二维码生成－普通
 *
 *  @param codeString    字符串
 *
 *  return          二维码
 */
+(UIImage *)createQRCodeImageWithString:(NSString *)codeString;
/**
 * 二维码－普通-自定义尺寸

 @param codeString 字符串
 @param width 宽度
 @param height 高度
 @return 图片
 */
+(UIImage *)createQRCodeImageWithString:(NSString *)codeString andWithWidth:(CGFloat)width andWithHeight:(CGFloat)height;
#pragma mark 二维码生成-logo
/**
 *   二维码生成-logo
 *
 *  @param codeString    字符串
 *  @param logoImage  二维码中间logo
 *
 *  return             带logo二维码
 */
+(UIImage *)createQRCodeImageWithString:(NSString *)codeString andWithLogoImage:(UIImage *)logoImage;
/**
 *   二维码生成-logo-自定义尺寸
 *
 *  @param codeString    字符串
 *  @param logoImage  二维码中间logo
 *
 *  return             带logo二维码
 */
+(UIImage *)createQRCodeImageWithString:(NSString *)codeString andWithLogoImage:(UIImage *)logoImage  andWithWidth:(CGFloat)width andWithHeight:(CGFloat)height;


#pragma mark 二维码识别
/**
 *   二维码识别
 *
 *  @param image    二维码图片
 *
 *  return          二维码
 */
+(NSString *)identifyQRCodeImage:(UIImage *)image;
#pragma mark 条形码生成
/**
 条形码生成

 @param codeString 字符串
 @return 图片
 */
+(UIImage*)createBarCodeWithString:(NSString*)codeString;
/**
 条形码生成-自定义尺寸
 
 @param codeString 字符串
 @param width 宽度
 @param height 高度
 @return 图片
 */
+(UIImage*)createBarCodeWithString:(NSString*)codeString andWithWidth:(CGFloat)width andWithHeight:(CGFloat)height;
@end
