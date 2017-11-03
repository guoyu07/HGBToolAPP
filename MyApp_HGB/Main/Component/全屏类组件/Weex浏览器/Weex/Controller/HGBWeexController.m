//
//  HGBWeexController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBWeexController.h"
#import "HGBWeexPluginManager.h"
#import <WeexSDK/WeexSDK.h>
#import "WeexSDKManager.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0




@interface HGBWeexController ()
@property(strong,nonatomic)WXSDKInstance *instance;
@property(strong,nonatomic)UIView *weexView;
/**
 功能按钮
 */
@property(strong,nonatomic)UIButton *actionButton;

@end

@implementation HGBWeexController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createBackButton];
    _instance = [[WXSDKInstance alloc] init];
    _instance.viewController = self;
    _instance.frame = self.view.frame;
    __weak HGBWeexController* weakSelf= self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
    };
    _instance.onFailed = ^(NSError *error) {
        //process failure
    };
    _instance.renderFinish = ^ (UIView *view) {
        [weakSelf.view bringSubviewToFront:weakSelf.actionButton];
    };
    [self renderInUrl:nil];


}
-(void)renderInUrl:(NSString *)urlString{

    _instance = [[WXSDKInstance alloc] init];
    _instance.viewController = self;
    _instance.frame = self.view.frame;
    __weak HGBWeexController* weakSelf= self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
    };
    _instance.onFailed = ^(NSError *error) {
        //process failure
    };
    __weak HGBWeexController *weakSelf2=self;
    _instance.renderFinish = ^ (UIView *view) {
        [weakSelf2.view bringSubviewToFront:weakSelf2.actionButton];

    };


    NSURL *url;
    if(urlString==nil||urlString.length==0){
        if(self.url&&self.url.length!=0){
            [HGBWeexPluginManager registerWeexPlugin];
            [WeexSDKManager initWeexSDK];
            urlString=self.url;
        }else{
            NSString *path=[[NSBundle mainBundle]pathForResource:@"bundlejs" ofType:nil];

            if([self isExitAtFilePath:[path stringByAppendingPathComponent:@"index.js"]]){
                path=[path stringByAppendingPathComponent:@"index.js"];
            }else{
                path=[path stringByAppendingPathComponent:@"app.weex.js"];
            }
            urlString=path;
        }
    }

    NSLog(@"%@",urlString);
    if([urlString containsString:@"http"]||[urlString containsString:@"https"]){
        url=[NSURL URLWithString:urlString];
        [_instance renderWithURL:url options:@{@"bundleUrl":[url absoluteString]} data:[[NSData alloc]initWithContentsOfURL:url]];
        [self.view bringSubviewToFront:self.actionButton];
        return;
    }
    if(urlString&&([urlString containsString:@"file:"])){
        url = [NSURL URLWithString:urlString];
    }else{
        urlString=[self getCompletePathFromSimplifyFilePath:urlString];
        url = [NSURL fileURLWithPath:urlString];

    }
    if([self isExitAtFilePath:url.path]){
        [_instance renderWithURL:url options:@{@"bundleUrl":[url absoluteString]} data:[[NSData alloc]initWithContentsOfURL:url]];
    }else{
        NSLog(@"路径不存在");
    }
}
- (void)dealloc
{
    [_instance destroyInstance];
}
#pragma mark 功能按钮
-(void)createBackButton{
    [self creatFunctionButton];
}
-(void)creatFunctionButton{
    self.actionButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.actionButton.frame=CGRectMake(kWidth-100, kHeight-64-100,128*hScale,128*wScale);

    if(self.returnButtonPositionType==HGBWeexCloseButtonPositionTypeTopLeft){
        self.actionButton.frame=CGRectMake(5,5,128*hScale,128*wScale);
    }else if (self.returnButtonPositionType==HGBWeexCloseButtonPositionTypeTopRight){
        self.actionButton.frame=CGRectMake(kWidth-5-128*wScale,5,128*hScale,128*wScale);
    }else if (self.returnButtonPositionType==HGBWeexCloseButtonPositionTypeBottomRight){
        self.actionButton.frame=CGRectMake(kWidth-5-128*wScale,kHeight-5-128*hScale,128*hScale,128*wScale);
    }else if (self.returnButtonPositionType==HGBWeexCloseButtonPositionTypeBottomLeft){
        self.actionButton.frame=CGRectMake(5,kHeight-5-128*hScale,128*hScale,128*wScale);
    }
    [self.actionButton setImage:[[UIImage imageNamed:@"HGBWeexBundle.bundle/webview_close.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:(UIControlStateNormal)];
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
    if(self.returnButtonDragType==HGBWeexCloseButtonDragTypeNO){

    }else if(self.returnButtonDragType==HGBWeexCloseButtonDragTypeNOLimit){
        CGPoint point= [_p locationInView:self.view];
        self.actionButton.center=point;
    }else if(self.returnButtonDragType==HGBWeexCloseButtonDragTypeBorder){
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
#pragma mark 获取文件完整路径

/**
 将简化路径转化为完整路径

 @param simplifyFilePath 简化路径
 @return 完整路径
 */
-(NSString *)getCompletePathFromSimplifyFilePath:(NSString *)simplifyFilePath{
    NSString *path=[simplifyFilePath copy];
    if(![self isExitAtFilePath:path]){
        path=[[self getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
        if(![self isExitAtFilePath:path]){
            path=[[self getDocumentFilePath] stringByAppendingPathComponent:simplifyFilePath];
            if(![self isExitAtFilePath:path]){
                path=[[self getMainBundlePath] stringByAppendingPathComponent:simplifyFilePath];
                if(![self isExitAtFilePath:path]){
                    path=simplifyFilePath;
                }

            }

        }

    }
    return path;
}
/**
 将简化目标路径转化为完整路径

 @param simplifyFilePath 简化路径
 @return 完整路径
 */
-(NSString *)getDestinationCompletePathFromSimplifyFilePath:(NSString *)simplifyFilePath{
    if(!([simplifyFilePath containsString:[self getHomeFilePath]]||[simplifyFilePath containsString:[self getMainBundlePath]])){
        simplifyFilePath=[[self getHomeFilePath] stringByAppendingPathComponent:simplifyFilePath];
    }
    return simplifyFilePath;
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
#pragma mark path to url
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
#pragma mark 文档通用
/**
 文件拷贝

 @param srcPath 文件路径
 @param filePath 复制文件路径
 @return 结果
 */
-(BOOL)copyFilePath:(NSString *)srcPath ToPath:(NSString *)filePath{
    if(![self isExitAtFilePath:srcPath]){
        return NO;
    }
    NSString *directoryPath=[filePath stringByDeletingLastPathComponent];
    if(![self isExitAtFilePath:directoryPath]){
        [self createDirectoryPath:directoryPath];
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL flag=[filemanage copyItemAtPath:srcPath toPath:filePath error:nil];
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
-(BOOL)isExitAtFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return NO;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isExit=[filemanage fileExistsAtPath:filePath];
    return isExit;
}

#pragma mark 文件夹
/**
 创建文件夹

 @param directoryPath 路径
 @return 结果
 */
-(BOOL)createDirectoryPath:(NSString *)directoryPath{
    if([self isExitAtFilePath:directoryPath]){
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
@end

