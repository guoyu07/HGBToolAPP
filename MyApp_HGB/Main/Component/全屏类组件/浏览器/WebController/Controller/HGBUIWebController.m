//
//  HGBUIWebController.m
//  测试app
//
//  Created by huangguangbao on 2017/7/11.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBUIWebController.h"
#import "HGBWebHeader.h"
#import "HGBWebViewProgress.h"

@interface HGBUIWebController ()<UIWebViewDelegate,HGBUIWebJSExport>

/**
 web
 */
@property(strong,nonatomic)UIWebView *webView;
/**
 js
 */
@property(strong,nonatomic)JSContext *jsContext;
/**
 加载方式
 */
@property(assign,nonatomic)NSInteger type;

/*
 url字符串
 */
@property(strong,nonatomic)NSString *urlString;


/**
 当前url字符串
 */
@property(strong,nonatomic)NSString *currentUrlString;
/*
 html字符串
 */
@property(strong,nonatomic)NSString *htmlString;




/**
 导航栏标签
 */
@property(nonatomic,assign)BOOL navFlag;
/**
 导航栏标题
 */
@property(nonatomic,strong)NSString *navTitle;
/**
 导航栏左侧按钮类型
 */
@property(nonatomic,assign)BOOL navLeftFlag;

@property (strong, nonatomic) HGBWebViewProgress *progress;




/**
 功能按钮
 */
@property(strong,nonatomic)UIButton *actionButton;
/**
 状态栏方式
 */
@property(assign,nonatomic)NSInteger bottomType;
/**
 底部view
 */
@property(strong,nonatomic)UIView *bottomView;
/**
 返回
 */
@property(strong,nonatomic)UIButton *backButton;
/**
 前进
 */
@property(strong,nonatomic)UIButton *forwordButton;
/**
 关闭
 */
@property(strong,nonatomic)UIButton *closeButton;
/**
 刷新
 */
@property(strong,nonatomic)UIButton *refreshButton;
/**
 消失
 */
@property(strong,nonatomic)UIButton *disappearButton;

/**
 浏览器高度
 */
@property(assign,nonatomic)CGFloat webHeight;
/**
 浏览器位置
 */
@property(assign,nonatomic)CGFloat webY;
/**
 进度条位置
 */
@property(assign,nonatomic)CGFloat webProgressY;
@end

@implementation HGBUIWebController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _webHeight=kHeight;
        _webProgressY=0;
        _webY=0;
    }
    return self;
}
#pragma mark View life
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
}
#pragma mark 导航栏
//导航栏
-(void)createNavigationItemWithTitle:(NSString *)title
{
    self.navTitle=title;
    [self setUpNavigationItemWithTitle:title WithType:NO];
    
}
-(void)setUpNavigationItemWithTitle:(NSString *)title WithType:(BOOL)type{
    _navFlag=YES;
    self.progress.frame=CGRectMake(0, 64, kWidth, 2);
    if(([self.bottomView superview])){
        _webHeight=kHeight-53;
    }else{
        _webHeight=kHeight;
    }
    if(([self.bottomView superview])){
        self.webY=0;
    }else{
        self.webY=0;
    }
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1];
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor lightGrayColor]];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=self.navTitle;
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0*wScale,0, 200*wScale, 45)];
    
    if(type==NO){
        //左按钮
        UIButton *returnButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
        returnButton.frame=CGRectMake(0,(45-44*hScale)*0.5, 94*wScale, 44*hScale);
        [returnButton setTitle:@"返回" forState:(UIControlStateNormal)];
        returnButton.titleLabel.font=[UIFont systemFontOfSize:32*hScale];
        [returnButton addTarget:self action:@selector(returnhandler:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [returnButton addTarget:self action:@selector(buttonRemoveBlurredHandle:) forControlEvents:(UIControlEventTouchUpOutside)];
        [returnButton addTarget:self action:@selector(buttonRemoveBlurredHandle:) forControlEvents:(UIControlEventTouchCancel)];
        [returnButton addTarget:self action:@selector(buttonBlurredHandle:) forControlEvents:(UIControlEventTouchDown)];
        [leftView addSubview:returnButton];
        
    }else{
        UIButton *returnButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
        returnButton.frame=CGRectMake(0,(45-44*hScale)*0.5, 90*wScale, 44*hScale);
        [returnButton setTitle:@"返回" forState:(UIControlStateNormal)];
        returnButton.titleLabel.font=[UIFont systemFontOfSize:32*hScale];
        [returnButton addTarget:self action:@selector(goBackHandle:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [returnButton addTarget:self action:@selector(buttonRemoveBlurredHandle:) forControlEvents:(UIControlEventTouchUpOutside)];
        [returnButton addTarget:self action:@selector(buttonRemoveBlurredHandle:) forControlEvents:(UIControlEventTouchCancel)];
        [returnButton addTarget:self action:@selector(buttonBlurredHandle:) forControlEvents:(UIControlEventTouchDown)];
        
        
        
        UIButton *closeButton=[UIButton buttonWithType:UIButtonTypeSystem];
        closeButton.frame=CGRectMake(CGRectGetMaxX(returnButton.frame)+10*wScale,(45-44*hScale)*0.5, 80*wScale,44*hScale);
        [closeButton setTitle:@"关闭" forState:(UIControlStateNormal)];
        closeButton.titleLabel.font=[UIFont systemFontOfSize:32*hScale];
        [closeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        
        [closeButton addTarget:self action:@selector(returnhandler:) forControlEvents:(UIControlEventTouchUpInside)];
        [closeButton addTarget:self action:@selector(buttonRemoveBlurredHandle:) forControlEvents:(UIControlEventTouchUpOutside)];
        [closeButton addTarget:self action:@selector(buttonRemoveBlurredHandle:) forControlEvents:(UIControlEventTouchCancel)];
        [closeButton addTarget:self action:@selector(buttonBlurredHandle:) forControlEvents:(UIControlEventTouchDown)];
        
        [leftView addSubview:returnButton];
        [leftView addSubview:closeButton];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
}

#pragma mark 按钮功能
//返回
-(void)returnhandler:(UIButton *)_b{
    _b.backgroundColor=[UIColor clearColor];
    if(self.navigationController){
        NSArray *vcs=self.navigationController.viewControllers;
        if(self==vcs[0]){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }

    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)goBackHandle:(UIButton *)_b{
    _b.backgroundColor=[UIColor clearColor];
    if([self.currentUrlString isEqualToString:self.urlString]||[self.currentUrlString isEqualToString:[NSString stringWithFormat:@"%@/",self.urlString]]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.webView goBack];
    }
    
}
#pragma mark 按钮颜色变化
-(void)buttonBlurredHandle:(UIButton *)_b{
    _b.backgroundColor=[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:0.5];
}
-(void)buttonRemoveBlurredHandle:(UIButton *)_b{
    _b.backgroundColor=[UIColor clearColor];
}
#pragma mark url

/**
 加载url
 
 @param url url-完整url链接
 */
-(void)loadURL:(NSString *)url{
    [self loadWebViewWithString:url andWithType:0];
}
/**
 加载工程内url-简化url
 
 @param url url bundle往下路径
 */
-(void)loadBundleURL:(NSString *)url{
    [self loadWebViewWithString:url andWithType:1];
}
/**
 加载沙盒document文件夹下简化url
 
 @param url url document下路径
 */
-(void)loadDocumentURL:(NSString *)url{
    [self loadWebViewWithString:url andWithType:2];
}
/**
 加载沙盒文件夹下简化url
 
 @param url url 沙盒下路径
 */
-(void)loadMainURL:(NSString *)url{
    [self loadWebViewWithString:url andWithType:3];
}
/**
 加载html表单
 
 @param htmlString html内容
 */
-(void)loadHtmlString:(NSString *)htmlString{
    [self loadWebViewWithString:htmlString andWithType:4];
}
/**
 加载网页
 
 @param string url或内容
 @param type  0:网页 1.本地 2 document 3 html字符串
 */
-(void)loadWebViewWithString:(NSString *)string andWithType:(NSInteger)type
{
    self.webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,_webY, kWidth,_webHeight)];
    if(![self.webView superview]){
        [self.view addSubview:self.webView];
    }
    self.webView.delegate=self;
    self.webView.scalesPageToFit=YES;
    self.webView.backgroundColor=[UIColor whiteColor];
    
    self.progress=[[HGBWebViewProgress alloc]initWithFrame:CGRectMake(0, 0, kWidth, 2)];
    
    
    self.progress.lineColor=[UIColor greenColor];
    if(![self.progress superview]){
        [self.view addSubview:self.progress];
    }
    self.webView.backgroundColor=[UIColor whiteColor];
    
    
    self.type=type;
    
    
    NSURL *loadurl;
    
    NSString *path;
    if(type==1){
        path=[self getMainBundlePath];
        path=[path stringByAppendingPathComponent:string];
        path=[[NSURL fileURLWithPath:path] absoluteString];
        
    }else if (type==2){
        path=[self getDocumentFilePath];
        path=[path stringByAppendingPathComponent:string];
        path=[[NSURL fileURLWithPath:path] absoluteString];
    }else if(type==3){
        path=[self getHomeFilePath];
        path=[path stringByAppendingPathComponent:string];
        path=[[NSURL fileURLWithPath:path] absoluteString];
        
    }else if(type==4){
        self.htmlString=string;
        [self.webView loadHTMLString:string baseURL:nil];
        return;
    }else{
        path=string;
    }
    NSLog(@"%@",path);
    self.urlString=path;
    self.urlString=[self urlFormatString:self.urlString];
    loadurl=[NSURL URLWithString:path];
    self.currentUrlString=self.urlString;
    NSURLRequest *request = [NSURLRequest requestWithURL:loadurl];
    [self.webView loadRequest:request];
    [self.view bringSubviewToFront:self.actionButton];
    
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"CTTX"] = self;
    
}

#pragma mark UIWebDelegate implementation
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%@-%@",request.URL,self.urlString);
    self.currentUrlString=request.URL.absoluteString;
    if(_navFlag){
        //导航栏左侧按钮变更
        if([request.URL.absoluteString isEqualToString:self.urlString]||[request.URL.absoluteString isEqualToString:[NSString stringWithFormat:@"%@/",self.urlString]]){
            self.navLeftFlag=NO;
        }else{
            self.navLeftFlag=YES;
        }
    }
    if ([self.currentUrlString hasPrefix:@"app:"]) {
        NSLog(@"requestString:%@",self.currentUrlString);
        //如果是自己定义的协议, 再截取协议中的方法和参数, 判断无误后在这里手动调用oc方法
//        NSMutableDictionary *param = [self queryStringToDictionary:self.currentUrlString andWithPortString:@"app:"];
    }
    
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.progress startLoadingAnimation];
}

- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    [self.progress endLoadingAnimation];
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"CTTX"] = self;
    
    // 打印异常
    self.jsContext.exceptionHandler =^(JSContext *context, JSValue *exceptionValue){
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    self.jsContext[@"log"] =^(NSString *string){
        NSLog(@"%@", string);
    };
    if(_navFlag){
        //导航栏变化
        [self setUpNavigationItemWithTitle:self.navTitle WithType:self.navLeftFlag];
    }
    return ;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.progress endLoadingAnimation];
}
#pragma mark 工具栏

/**
 打开工具栏
 
 @param type 打开方式 0 显示工具栏开启按钮 1直接显示工具栏
 */
-(void)openToolBarWithType:(NSInteger)type{
    self.bottomType=type;
    [self createFunctionButton];
    [self createBottomFunctionView];
    if(self.bottomType==0){
        self.actionButton.hidden=NO;
        if([self.bottomView superview]){
            [self.bottomView removeFromSuperview];
        }
    }else{
        self.actionButton.hidden=YES;
        if(![self.bottomView superview]){
            [self.view addSubview:self.bottomView];
        }
        if(!_navFlag){
            _webHeight=kHeight-53;
            self.webY=0;
        }else{
            _webHeight=kHeight-117;
            self.webY=0;
        }
    }
    
}

/**
 功能按钮设置
 */
-(void)createFunctionButton{
    self.actionButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.actionButton.frame=CGRectMake(kWidth-100, kHeight-64-100, 66, 66);
    self.actionButton.alpha=0.5;
    self.actionButton.layer.masksToBounds=YES;
    self.actionButton.hidden=YES;
    self.actionButton.layer.cornerRadius=33;
    self.actionButton.layer.borderWidth=3;
    self.actionButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    
    self.actionButton.backgroundColor=[UIColor grayColor];
    [self.actionButton addTarget:self action:@selector(actionButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.actionButton];
    
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandler:)];
    [self.actionButton addGestureRecognizer:pan];
}
-(void)actionButtonHandle:(UIButton *)_b{
    if([self.bottomView superview]){
        if(_navFlag){
            self.webHeight=kHeight;
        }else{
            self.webHeight=kHeight;
        }
        [self.view addSubview:self.bottomView];
    }else{
        self.webHeight=kHeight;
        if(_navFlag){
            self.webHeight=kHeight-53;
        }else{
            self.webHeight=kHeight-53;
        }
        [self.view addSubview:self.bottomView];
        
    }
    self.actionButton.hidden=YES;
    
}
-(void)panHandler:(UIPanGestureRecognizer *)_p
{
    CGPoint point= [_p locationInView:self.view];
    self.actionButton.center=point;
    
}


/**
 工具栏设置
 */
-(void)createBottomFunctionView{
    self.bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-53, kWidth,53)];
    self.bottomView.backgroundColor=[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
    CGFloat width=42;
    CGFloat height=42;
    CGFloat y=5.5;
    CGFloat margin=(kWidth-42*5)/6;
    
    self.closeButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.closeButton setImage:[UIImage imageNamed:@"HGBWebView.bundle/wv_stop.png"] forState:(UIControlStateNormal)];
    self.closeButton.frame=CGRectMake(margin, y, width, height);
    [self.closeButton addTarget:self action:@selector(closeButtonHandler:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView addSubview:self.closeButton];
    
    self.backButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.backButton setImage:[UIImage imageNamed:@"HGBWebView.bundle/wv_back.png"] forState:(UIControlStateNormal)];
    self.backButton.frame=CGRectMake(margin*2+width*1, y, width, height);
    [self.backButton addTarget:self action:@selector(backButtonHandler:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView addSubview:self.backButton];
    
    
    self.forwordButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.forwordButton setImage:[UIImage imageNamed:@"HGBWebView.bundle/wv_forward.png"] forState:(UIControlStateNormal)];
    self.forwordButton.frame=CGRectMake(margin*3+width*2, y, width, height);
    [self.forwordButton addTarget:self action:@selector(forwardButtonHandler:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView addSubview:self.forwordButton];
    
    
    
    self.refreshButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.refreshButton setImage:[UIImage imageNamed:@"HGBWebView.bundle/wv_refresh.png"] forState:(UIControlStateNormal)];
    self.refreshButton.frame=CGRectMake(margin*4+width*3, y, width, height);
    [self.refreshButton addTarget:self action:@selector(refreshButtonHandler:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView addSubview:self.refreshButton];
    
    
    self.disappearButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.disappearButton setImage:[UIImage imageNamed:@"HGBWebView.bundle/wv_disappear.png"] forState:(UIControlStateNormal)];
    self.disappearButton.frame=CGRectMake(margin*5+width*4, y, width, height);
    [self.disappearButton addTarget:self action:@selector(disappearButtonHandler:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView addSubview:self.disappearButton];
}



/**
 返回
 */
-(void)backButtonHandler:(UIButton *)_b{
    UIWebView *webview=(UIWebView *)self.webView;
    [webview goBack];
}
/**
 前进
 */
-(void)forwardButtonHandler:(UIButton *)_b{
    UIWebView *webview=(UIWebView *)self.webView;
    [webview goForward];
}
/**
 刷新
 */
-(void)refreshButtonHandler:(UIButton *)_b{
    UIWebView *webview=(UIWebView *)self.webView;
    [webview reload];
    if(self.htmlString.length!=0){
        if(self.currentUrlString==nil||self.currentUrlString.length==0){
            [self.webView loadHTMLString:self.currentUrlString baseURL:nil];
        }
    }
}
/**
 关闭
 */
-(void)closeButtonHandler:(UIButton *)_b{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 消失
 */
-(void)disappearButtonHandler:(UIButton *)_b{
    if(!_navFlag){
        self.webHeight=kHeight;
    }else{
        self.webHeight=kHeight;
    }
    if([self.bottomView superview]){
        [self.bottomView removeFromSuperview];
    }
    if(self.bottomType==0){
        self.actionButton.hidden=NO;
    }else{
        self.actionButton.hidden=YES;
    }
}
#pragma mark 位置
-(void)setNavFlag:(BOOL)navFlag{
    _navFlag=navFlag;
    if(navFlag){
        if(([self.bottomView superview])){
            _webHeight=kHeight-53;
        }else{
            _webHeight=kHeight;
        }
    }else{
        if(([self.bottomView superview])){
            _webHeight=kHeight-53;
        }else{
            _webHeight=kHeight-0;
        }
    }
    self.webY=0;

   
}
-(void)setWebY:(CGFloat)webY{
    _webY=webY;
    NSLog(@"%f-%f-%f",_webY,_webHeight,kHeight);
     self.webView.frame=CGRectMake(0,_webY, kWidth,_webHeight);
    
}
-(void)setWebHeight:(CGFloat)webHeight{
    _webHeight=webHeight;
    self.webView.frame=CGRectMake(0,_webY, kWidth,_webHeight);
}
#pragma mark form表单转化
/**
 将form表单转化为html
 
 @param formStr form表单
 @return html
 */
-(NSString *)transToHtmlFromFormString:(NSString *)formStr{
    NSString *htmlStr=[NSString stringWithFormat:@"<%%@ page language=\"java\" contentType=\"text/html;charset=GBK\" pageEncoding=\"GBK\"%%><!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\"> <html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=GBK\"><title>表单提交</title></head><body>${%@}</body></html>",formStr];
    return htmlStr;
}
#pragma mark 调用js
-(void)callJSWithString:(NSString *)string WithCompeleteBlock:(void (^)(id value))completeBlock{
    id value=[self.webView stringByEvaluatingJavaScriptFromString:string];
    completeBlock(value);
}
#pragma mark url字符处理
/**
 *  url字符处理
 *
 *  @param urlString 原url
 *
 *  @return 新url
 */
-(NSString *)urlFormatString:(NSString *)urlString{
    return [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
#pragma mark get接口参数
//get参数转字典
- (NSMutableDictionary*)queryStringToDictionary:(NSString*)string andWithPortString:(NSString *)portString{
    string=[string stringByReplacingOccurrencesOfString:portString withString:string];
    NSMutableArray *elements = (NSMutableArray*)[string componentsSeparatedByString:@"&"];
    [elements removeObjectAtIndex:0];
    NSMutableDictionary *retval = [NSMutableDictionary dictionaryWithCapacity:[elements count]];
    for(NSString *e in elements) {
        NSArray *pair = [e componentsSeparatedByString:@"="];
        [retval setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
    }
    return retval;
}
#pragma mark bundle
/**
 获取主资源文件路径

 @return 主资源文件路径
 */
-(NSString *)getMainBundlePath{
    return [[NSBundle mainBundle]resourcePath];
}
#pragma mark 沙盒途径
/**
 获取沙盒根路径

 @return 沙盒根路径
 */
-(NSString *)getHomeFilePath{
    return NSHomeDirectory();
}
/**
 获取沙盒Document路径
 
 @return Document路径
 */
-(NSString *)getDocumentFilePath{
    NSString  *path_huang =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    return path_huang;
}
/**
 通过文件路径获取url

 @param filePath 文件路径
  @return url
 */
-(NSString *)getUrlFromFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return nil;
    }
    NSURL *url_huang=[NSURL fileURLWithPath:filePath];
    return [url_huang absoluteString];
}
@end
