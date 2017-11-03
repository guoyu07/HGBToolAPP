//
//  HGBMediaImageController.m
//  测试
//
//  Created by huangguangbao on 2017/8/23.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBMediaImageController.h"
#import "HGBMediaImageView.h"


#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0



@interface HGBMediaImageController ()
@property(strong,nonatomic)HGBMediaImageView *imgV;
@end

@implementation HGBMediaImageController
#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];//导航栏
    [self viewSetUp];//ui


}
#pragma mark 导航栏
//导航栏
-(void)createNavigationItem
{
    //导航栏
    self.navigationController.navigationBar.barTintColor=[UIColor orangeColor];
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=[self.url lastPathComponent];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;

    //左键
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnhandler)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];

}
//返回
-(void)returnhandler{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(fileImageControllerDidClosed)]){
        [self.delegate fileImageControllerDidClosed];
    }
    UIViewController *rootVC=self.navigationController.childViewControllers[0];
    if([self.parentViewController isKindOfClass:[UINavigationController class]]){
        if(self==rootVC){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark view
-(void)viewSetUp{
    self.view.backgroundColor=[UIColor colorWithRed:246.0/256 green:246.0/256 blue:246.0/256 alpha:1];
    UIImage *image;
    if(self.url&&self.url.length!=0){
        NSURL *url;
        if([self.url containsString:@"http"]){
            url =[NSURL URLWithString:self.url];
        }else{
            NSString *path=[[NSURL URLWithString:self.url]path];
            path=[self getCompletePathFromSimplifyFilePath:path];
            url=[NSURL fileURLWithPath:path];

        }

        NSData *data=[NSData dataWithContentsOfURL:url];
        image=[UIImage imageWithData:data];
    }
    CGRect frame;
    CGFloat width=image.size.width;
    CGFloat height=image.size.height;
    if(image.size.width>(kWidth-60*wScale)||image.size.height>(kHeight-64-60*hScale)){

        if((image.size.width/kWidth)>(image.size.width/(kHeight-64))){
            width=kWidth-60*wScale;
            height=image.size.height*((kWidth-60*wScale)/image.size.width);

        }else{
            height=(kHeight-64-60*hScale);
            width=image.size.width*((kHeight-64-60*hScale)/image.size.height);
        }
    }else{
        width=image.size.width;
        height=image.size.height;
    }
    frame=CGRectMake((kWidth-width)*0.5, (kHeight-64-height)*0.5+64, width, height);



    self.imgV=[[HGBMediaImageView alloc]initWithFrame:frame];
    self.imgV.image=image;
    self.imgV.type=HGBMediaImageViewTypeOnlyTool;
    self.imgV.codeString=[self identifyQRCodeImage:image];
    self.imgV.codeTitle=@"识别二维码链接";
    [self.view addSubview:self.imgV];
}
#pragma mark 二维码识别
/**
 *   二维码识别
 *
 *  @param image    二维码图片
 *
 *  return          二维码
 */
-(NSString *)identifyQRCodeImage:(UIImage *)image{
    //2.初始化一个监测器
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];

    //监测到的结果数组
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >=1) {
        /**结果对象 */
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *result = feature.messageString;
        return result;
    }
    return nil;
    
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
#pragma mark bundle
/**
 获取主资源文件路径

 @return 主资源文件路径
 */
-(NSString *)getMainBundlePath{
    return [[NSBundle mainBundle]resourcePath];
}
#pragma mark 沙盒
/**
 获取沙盒根路径

 @return 根路径
 */
-(NSString *)getHomeFilePath{
    NSString *path_huang=NSHomeDirectory();
    return path_huang;
}
/**
 获取沙盒Document路径

 @return Document路径
 */
-(NSString *)getDocumentFilePath{
    NSString  *path_huang =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    return path_huang;
}
#pragma mark 文件
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
@end
