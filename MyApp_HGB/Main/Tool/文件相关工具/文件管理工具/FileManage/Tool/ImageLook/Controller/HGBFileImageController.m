//
//  HGBFileImageController.m
//  测试
//
//  Created by huangguangbao on 2017/8/17.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBFileImageController.h"
#import "HGBFileImageView.h"
#import "HGBFileManageHeader.h"
#import "HGBFileOutAppOpenFileTool.h"

@interface HGBFileImageController ()
@property(strong,nonatomic)HGBFileImageView *imgV;
@end

@implementation HGBFileImageController
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

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"HGBFileManageToolBundle.bundle/icon_threepoint.png"]  style:(UIBarButtonItemStylePlain) target:self action:@selector(openWithOtherType)];

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

#pragma mark 其他方式打开
-(void)openWithOtherType{
    [HGBFileOutAppOpenFileTool openFileWithExetenAppWithUrl:self.url inParent:self andWithCompleteBlock:^(NSInteger status) {
    }];
}
#pragma mark view
-(void)viewSetUp{
    self.view.backgroundColor=[UIColor colorWithRed:246.0/256 green:246.0/256 blue:246.0/256 alpha:1];
    UIImage *image;
    if(self.url&&self.url.length!=0){
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]];
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



    self.imgV=[[HGBFileImageView alloc]initWithFrame:frame];
    self.imgV.image=image;
    self.imgV.type=HGBFileImageViewTypeOnlyTool;
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
@end
