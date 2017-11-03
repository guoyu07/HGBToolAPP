//
//  HGBCordovaController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCordovaController.h"


#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0


@interface HGBCordovaController ()
/**
 状态栏view
 */
@property(strong,nonatomic)UIView *statusBarView;
/**
 功能按钮
 */
@property(strong,nonatomic)UIButton *actionButton;

@end

@implementation HGBCordovaController
#pragma mark init
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *docmentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSLog(@"%@",docmentPath);
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *wwwPath = [docmentPath stringByAppendingPathComponent:@"www/"];
        if ([fileMgr fileExistsAtPath:wwwPath]) {
            self.wwwFolderName = [NSString stringWithFormat:@"file:///%@",wwwPath];
        }else{
            self.wwwFolderName = @"www/";
        }
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
    // you can do so here.

    [super viewWillAppear:animated];
    self.webView.frame=CGRectMake(self.webView.frame.origin.x,20, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-20);
    if(![self.statusBarView superview]){
        self.statusBarView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 20)];
        self.statusBarView.backgroundColor=[UIColor whiteColor];

        [self.view addSubview:self.statusBarView];
        [self.view bringSubviewToFront:self.actionButton];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackButton];
}

#pragma mark 功能按钮
-(void)createBackButton{
    [self creatFunctionButton];
}
-(void)creatFunctionButton{
    self.actionButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.actionButton.frame=CGRectMake(kWidth-100, kHeight-64-100,128*hScale,128*wScale);

    if(self.returnButtonPositionType==HGBCordovaCloseButtonPositionTypeTopLeft){
        self.actionButton.frame=CGRectMake(5,5,128*hScale,128*wScale);
    }else if (self.returnButtonPositionType==HGBCordovaCloseButtonPositionTypeTopRight){
        self.actionButton.frame=CGRectMake(kWidth-5-128*wScale,5,128*hScale,128*wScale);
    }else if (self.returnButtonPositionType==HGBCordovaCloseButtonPositionTypeBottomRight){
        self.actionButton.frame=CGRectMake(kWidth-5-128*wScale,kHeight-5-128*hScale,128*hScale,128*wScale);
    }else if (self.returnButtonPositionType==HGBCordovaCloseButtonPositionTypeBottomLeft){
        self.actionButton.frame=CGRectMake(5,kHeight-5-128*hScale,128*hScale,128*wScale);
    }
    [self.actionButton setImage:[[UIImage imageNamed:@"HGBCordovaBundle.bundle/webview_close.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:(UIControlStateNormal)];
    [self.actionButton addTarget:self action:@selector(actionButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.actionButton];
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandler:)];
    [self.actionButton addGestureRecognizer:pan];
    if(self.isShowReturnButton){
        self.actionButton.hidden=NO;
    }else{
        self.actionButton.hidden=YES;
    }
}
-(void)actionButtonHandle:(UIButton *)_b{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)panHandler:(UIPanGestureRecognizer *)_p
{
    if(self.returnButtonDragType==HGBCordovaCloseButtonDragTypeNO){

    }else if(self.returnButtonDragType==HGBCordovaCloseButtonDragTypeNOLimit){
        CGPoint point= [_p locationInView:self.view];
        self.actionButton.center=point;
    }else if(self.returnButtonDragType==HGBCordovaCloseButtonDragTypeBorder){
        CGPoint point= [_p locationInView:self.view];
        self.actionButton.center=point;

        if(_p.state==UIGestureRecognizerStateEnded){
            CGFloat l=0.0,t=0.0,b=0.0,r=0.0;

            l=point.x;
            t=point.y;
            r=kWidth-point.x;
            b=kHeight-point.y;
            CGFloat position=[self getMinFromArray:@[[NSString stringWithFormat:@"%f",t],[NSString stringWithFormat:@"%f",b],[NSString stringWithFormat:@"%f",r],[NSString stringWithFormat:@"%f",l]]];
            NSLog(@"%@-%f",@[[NSString stringWithFormat:@"%f",t],[NSString stringWithFormat:@"%f",b],[NSString stringWithFormat:@"%f",r],[NSString stringWithFormat:@"%f",l]],position);
            if(position==l){
                self.actionButton.frame=CGRectMake(5,self.actionButton.frame.origin.y , self.actionButton.frame.size.width, self.actionButton.frame.size.height);
            }else if (position==r){
                self.actionButton.frame=CGRectMake(kWidth-5-self.actionButton.frame.size.width,self.actionButton.frame.origin.y , self.actionButton.frame.size.width, self.actionButton.frame.size.height);
            }else if (position==t){
                self.actionButton.frame=CGRectMake(self.actionButton.frame.origin.x,5 , self.actionButton.frame.size.width, self.actionButton.frame.size.height);
            }else if (position==b){
                self.actionButton.frame=CGRectMake(self.actionButton.frame.origin.x,kHeight-5-self.actionButton.frame.size.height, self.actionButton.frame.size.width, self.actionButton.frame.size.height);
            }


        }

    }

}
-(CGFloat )getMinFromArray:(NSArray *)array{
    if(array.count>0){
        NSString* postion=array[0];
        for(NSString *i in array){
            if(i.floatValue<postion.floatValue){
                postion=i;
            }
        }
        return postion.floatValue;
    }else{
        return 0;
    }
}
/* Comment out the block below to over-ride */

/*
 - (UIWebView*) newCordovaViewWithFrame:(CGRect)bounds
 {
 return[super newCordovaViewWithFrame:bounds];
 }

 - (NSUInteger)supportedInterfaceOrientations
 {
 return [super supportedInterfaceOrientations];
 }

 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
 }

 - (BOOL)shouldAutorotate
 {
 return [super shouldAutorotate];
 }
 */
@end

@implementation HGBCordovaCommandDelegate

/* To override the methods, uncomment the line in the init function(s)
 in MainViewController.m
 */

#pragma mark CDVCommandDelegate implementation

- (id)getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

- (NSString*)pathForResource:(NSString*)resourcepath
{
    return [super pathForResource:resourcepath];
}

@end

@implementation HGBCordovaCommandQueue

/* To override, uncomment the line in the init function(s)
 in MainViewController.m
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

@end
