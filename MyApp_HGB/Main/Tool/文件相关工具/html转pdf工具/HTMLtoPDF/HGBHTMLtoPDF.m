//
//  HGBHTMLtoPDF.m
//  企鹅
//
//  Created by huangguangbao on 2017/8/4.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBHTMLtoPDF.h"

@interface HGBHTMLtoPDF ()
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSString *HTML;
@property (nonatomic, strong) NSString *PDFpath;
@property (nonatomic, strong) NSData *PDFdata;
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) UIEdgeInsets pageMargins;
@end

@interface HGBPDFPrintPageRenderer : UIPrintPageRenderer

- (NSData*) printToPDF;
-(void)printToPDFWithCompleteBlock:(void(^)(NSData *pdfData))completeBlock;

@end

@implementation HGBHTMLtoPDF
static HGBHTMLtoPDF *instance=nil;
@synthesize URL=_URL,webview,delegate=_delegate,PDFpath=_PDFpath,pageSize=_pageSize,pageMargins=_pageMargins;
#pragma mark function

// Create PDF by passing in the URL to a webpage
+ (id)createPDFWithURL:(NSURL*)URL pathForPDF:(NSString*)PDFpath delegate:(id <HGBHTMLtoPDFDelegate>)delegate pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins
{
    HGBHTMLtoPDF *creator = [[HGBHTMLtoPDF alloc] initWithURL:URL delegate:delegate pathForPDF:PDFpath pageSize:pageSize margins:pageMargins];
    instance=creator;

    return creator;
}

// Create PDF by passing in the HTML as a String
+ (id)createPDFWithHTML:(NSString*)HTML pathForPDF:(NSString*)PDFpath delegate:(id <HGBHTMLtoPDFDelegate>)delegate
               pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins
{
    HGBHTMLtoPDF *creator = [[HGBHTMLtoPDF alloc] initWithHTML:HTML baseURL:nil delegate:delegate pathForPDF:PDFpath pageSize:pageSize margins:pageMargins];
    instance=creator;
    return creator;
}

// Create PDF by passing in the HTML as a String, with a base URL
+ (id)createPDFWithHTML:(NSString*)HTML baseURL:(NSURL*)baseURL pathForPDF:(NSString*)PDFpath delegate:(id <HGBHTMLtoPDFDelegate>)delegate
               pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins
{
    HGBHTMLtoPDF *creator = [[HGBHTMLtoPDF alloc] initWithHTML:HTML baseURL:baseURL delegate:delegate pathForPDF:PDFpath pageSize:pageSize margins:pageMargins];
    instance=creator;
    return creator;
}
+ (id)createPDFWithURL:(NSURL*)URL pathForPDF:(NSString*)PDFpath pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins successBlock:(HGBHTMLtoPDFCompletionBlock)successBlock errorBlock:(HGBHTMLtoPDFCompletionBlock)errorBlock
{
    HGBHTMLtoPDF *creator = [[HGBHTMLtoPDF alloc] initWithURL:URL delegate:nil pathForPDF:PDFpath pageSize:pageSize margins:pageMargins];
    instance=creator;
    creator.successBlock = successBlock;
    creator.errorBlock = errorBlock;

    return creator;
}

+ (id)createPDFWithHTML:(NSString*)HTML pathForPDF:(NSString*)PDFpath pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins successBlock:(HGBHTMLtoPDFCompletionBlock)successBlock errorBlock:(HGBHTMLtoPDFCompletionBlock)errorBlock
{
    HGBHTMLtoPDF *creator = [[HGBHTMLtoPDF alloc] initWithHTML:HTML baseURL:nil delegate:nil pathForPDF:PDFpath pageSize:pageSize margins:pageMargins];

    creator.successBlock = successBlock;
    creator.errorBlock = errorBlock;
    instance=creator;

    return creator;
}

+ (id)createPDFWithHTML:(NSString*)HTML baseURL:(NSURL*)baseURL pathForPDF:(NSString*)PDFpath pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins successBlock:(HGBHTMLtoPDFCompletionBlock)successBlock errorBlock:(HGBHTMLtoPDFCompletionBlock)errorBlock
{
    HGBHTMLtoPDF *creator = [[HGBHTMLtoPDF alloc] initWithHTML:HTML baseURL:baseURL delegate:nil pathForPDF:PDFpath pageSize:pageSize margins:pageMargins];
    creator.successBlock = successBlock;
    creator.errorBlock = errorBlock;
    instance=creator;

    return creator;
}
#pragma mark init

- (id)init
{
    if (self = [super init])
    {
        self.PDFdata = nil;
    }
    return self;
}

- (id)initWithURL:(NSURL*)URL delegate:(id <HGBHTMLtoPDFDelegate>)delegate pathForPDF:(NSString*)PDFpath pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins
{
    if (self = [super init])
    {
        self.URL = URL;
        self.delegate = delegate;
        self.PDFpath = PDFpath;
        NSString *dirPath=[PDFpath stringByDeletingLastPathComponent];
        if(![HGBHTMLtoPDF isExitAtFilePath:dirPath]){
            [HGBHTMLtoPDF createDirectoryPath:dirPath];
        }


        self.pageMargins = pageMargins;
        self.pageSize = pageSize;

        [self forceLoadView];
    }
    return self;
}

- (id)initWithHTML:(NSString*)HTML baseURL:(NSURL*)baseURL delegate:(id <HGBHTMLtoPDFDelegate>)delegate
        pathForPDF:(NSString*)PDFpath pageSize:(CGSize)pageSize margins:(UIEdgeInsets)pageMargins
{
    if (self = [super init])
    {
        self.HTML = HTML;

        self.URL = baseURL;
        self.delegate = delegate;
        self.PDFpath = PDFpath;
        NSString *dirPath=[PDFpath stringByDeletingLastPathComponent];
        if(![HGBHTMLtoPDF isExitAtFilePath:dirPath]){
            [HGBHTMLtoPDF createDirectoryPath:dirPath];
        }

        self.pageMargins = pageMargins;
        self.pageSize = pageSize;

        [self forceLoadView];
    }
    return self;
}

- (void)forceLoadView
{
    [[UIApplication sharedApplication].delegate.window addSubview:self.view];

    self.view.frame = CGRectMake(0, 0, 1, 1);
    self.view.alpha = 0.0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.webview = [[UIWebView alloc] initWithFrame:self.view.frame];
    webview.delegate = self;

    [self.view addSubview:webview];

    if(self.URL==nil&&self.HTML==nil){
        if(self.delegate&&[self.delegate respondsToSelector:@selector(HTMLtoPDFDidFail:)]){
            [self.delegate HTMLtoPDFDidFail:self];
        }
        return;
    }
    if (self.HTML == nil) {
        [webview loadRequest:[NSURLRequest requestWithURL:self.URL]];
    }else{
        [webview loadHTMLString:self.HTML baseURL:self.URL];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.isLoading) return;

    HGBPDFPrintPageRenderer *render = [[HGBPDFPrintPageRenderer alloc] init];

    [render addPrintFormatter:webView.viewPrintFormatter startingAtPageAtIndex:0];

    CGRect printableRect = CGRectMake(self.pageMargins.left,
                                      self.pageMargins.top,
                                      self.pageSize.width - self.pageMargins.left - self.pageMargins.right,
                                      self.pageSize.height - self.pageMargins.top - self.pageMargins.bottom);

    CGRect paperRect = CGRectMake(0, 0, self.pageSize.width, self.pageSize.height);

    [render setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];

    self.PDFdata = [render printToPDF];

    if (self.PDFpath) {
        [self.PDFdata writeToFile: self.PDFpath  atomically: YES];
    }



    if (self.delegate && [self.delegate respondsToSelector:@selector(HTMLtoPDFDidSucceed:)])
        [self.delegate HTMLtoPDFDidSucceed:self];

    if(self.successBlock) {
        self.successBlock(self);
    }
    instance=nil;


}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (webView.isLoading) return;

    [self terminateWebTask];

    if (self.delegate && [self.delegate respondsToSelector:@selector(HTMLtoPDFDidFail:)])
        [self.delegate HTMLtoPDFDidFail:self];

    if(self.errorBlock) {
        self.errorBlock(self);
    }
    instance=nil;

}

- (void)terminateWebTask
{
    [self.webview stopLoading];
    self.webview.delegate = nil;
    [self.webview removeFromSuperview];

    [self.view removeFromSuperview];

    self.webview = nil;
}
#pragma mark 文件
/**
 创建文件夹

 @param directoryPath 路径
 @return 结果
 */
+(BOOL)createDirectoryPath:(NSString *)directoryPath{
    if([HGBHTMLtoPDF isExitAtFilePath:directoryPath]){
        return YES;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];
    BOOL flag=[filemanage createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:nil];
    if(flag){
        return YES;
    }else{
        return NO;
    }
}
/**
 文档是否存在

 @param filePath 归档的路径
 @return 结果
 */
+(BOOL)isExitAtFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return NO;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isExit=[filemanage fileExistsAtPath:filePath];
    return isExit;
}

@end

@implementation HGBPDFPrintPageRenderer

-(void)printToPDFWithCompleteBlock:(void(^)(NSData *pdfData))completeBlock
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableData *pdfData = [NSMutableData data];

        UIGraphicsBeginPDFContextToData( pdfData, self.paperRect, nil );

        [self prepareForDrawingPages: NSMakeRange(0, self.numberOfPages)];

        CGRect bounds = UIGraphicsGetPDFContextBounds();
        UIGraphicsBeginPDFPage();
        NSInteger i=0;
        for ( i = 0 ; i < self.numberOfPages ; i++ )
        {
            [self drawPageAtIndex:i inRect: bounds];

        }
        
        UIGraphicsEndPDFContext();
        completeBlock(pdfData);
    });

}

- (NSData*) printToPDF
{
    NSMutableData *pdfData = [NSMutableData data];

    UIGraphicsBeginPDFContextToData( pdfData, self.paperRect, nil );

    [self prepareForDrawingPages: NSMakeRange(0, self.numberOfPages)];

    CGRect bounds = UIGraphicsGetPDFContextBounds();
    UIGraphicsBeginPDFPage();
    NSInteger i=0;
    for ( i = 0 ; i < self.numberOfPages ; i++ )
    {
        [self drawPageAtIndex:i inRect: bounds];

    }

    UIGraphicsEndPDFContext();
    
    return pdfData;
}
@end

