//
//  HGBImageToPDFTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/31.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HGBImageToPDFTool;


@protocol HGBImageToPDFToolDelegate <NSObject>

@optional
- (void)ImageToPDFDidSucceed:(HGBImageToPDFTool*)imageToPDF;
- (void)ImageToPDFDidFail:(HGBImageToPDFTool*)imageToPDF;
@end

@interface HGBImageToPDFTool : NSObject
@property (nonatomic, strong) NSString *PDFpath;

/**
 *  @brief  创建PDF文件
 *
 *  @param  image        图片
 *  @param  destFilePath    PDF文件路径
 *  @param  password        要设定的密码
 */
+ (void)createPDFFileWithImage:(UIImage *)image toDestFilePath:(NSString *)destFilePath withPassword:(NSString *)password delegate:(id <HGBImageToPDFToolDelegate>)delegate;


/**
 *  @brief  抛出pdf文件存放地址
 *
 *  @param  filename    NSString型 文件名
 *
 *  @return NSString型 地址
 */
+ (NSString *)pdfDestPath:(NSString *)filename;
@end
