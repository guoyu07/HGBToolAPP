//
//  HGBHTMLtoPDF.h
//  企鹅
//
//  Created by huangguangbao on 2017/8/4.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>


#define basePageSize9 CGSizeMake(595.2,841.8*9)
#define basePageSize3 CGSizeMake(595.2,841.8*3)
#define basePageSize CGSizeMake(595.2,841.8*1)

#define kPaperSizeLetter CGSizeMake(612,792)


@class HGBHTMLtoPDF;

typedef void (^HGBHTMLtoPDFCompletionBlock)(HGBHTMLtoPDF* htmlToPDF);

@protocol HGBHTMLtoPDFDelegate <NSObject>

@optional
- (void)HTMLtoPDFDidSucceed:(HGBHTMLtoPDF*)htmlToPDF;
- (void)HTMLtoPDFDidFail:(HGBHTMLtoPDF*)htmlToPDF;
@end
@interface HGBHTMLtoPDF : UIViewController<UIWebViewDelegate>

@property (nonatomic, copy) HGBHTMLtoPDFCompletionBlock successBlock;
@property (nonatomic, copy) HGBHTMLtoPDFCompletionBlock errorBlock;

@property (nonatomic, weak) id <HGBHTMLtoPDFDelegate> delegate;

@property (nonatomic, strong, readonly) NSString *PDFpath;
@property (nonatomic, strong, readonly) NSData *PDFdata;

+ (id)createPDFWithURL:(NSURL*)URL pathForPDF:(NSString*)PDFpath delegate:(id <HGBHTMLtoPDFDelegate>)delegate pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins;
+ (id)createPDFWithHTML:(NSString*)HTML pathForPDF:(NSString*)PDFpath delegate:(id <HGBHTMLtoPDFDelegate>)delegate pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins;
+ (id)createPDFWithHTML:(NSString*)HTML baseURL:(NSURL*)baseURL pathForPDF:(NSString*)PDFpath delegate:(id <HGBHTMLtoPDFDelegate>)delegate pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins;

+ (id)createPDFWithURL:(NSURL*)URL pathForPDF:(NSString*)PDFpath pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins successBlock:(HGBHTMLtoPDFCompletionBlock)successBlock errorBlock:(HGBHTMLtoPDFCompletionBlock)errorBlock;
+ (id)createPDFWithHTML:(NSString*)HTML pathForPDF:(NSString*)PDFpath pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins successBlock:(HGBHTMLtoPDFCompletionBlock)successBlock errorBlock:(HGBHTMLtoPDFCompletionBlock)errorBlock;
+ (id)createPDFWithHTML:(NSString*)HTML baseURL:(NSURL*)baseURL pathForPDF:(NSString*)PDFpath pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins successBlock:(HGBHTMLtoPDFCompletionBlock)successBlock errorBlock:(HGBHTMLtoPDFCompletionBlock)errorBlock;

@end
