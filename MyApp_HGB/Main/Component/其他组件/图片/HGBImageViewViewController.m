//
//  HGBImageViewViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/24.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBImageViewViewController.h"
#import "HGBImageView.h"

@interface HGBImageViewViewController ()

@end

@implementation HGBImageViewViewController

#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];//导航栏
    [self viewSetUp];//UI



}
#pragma mark 导航栏
//导航栏
-(void)createNavigationItem
{
    //导航栏
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.0/256 green:191.0/256 blue:256.0/256 alpha:1];
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:0.0/256 green:191.0/256 blue:256.0/256 alpha:1]];
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=@"图片";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;


    //左键
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回"  style:UIBarButtonItemStylePlain target:self action:@selector(returnhandler)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -15, 0, 5)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];

}
//返回
-(void)returnhandler{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark view
-(void)viewSetUp{
    self.view.backgroundColor=[UIColor whiteColor];
    HGBImageView *imgV1=[[HGBImageView alloc]initWithFrame:CGRectMake(10, 80, 120, 120)];
    imgV1.image=[UIImage imageNamed:@"cir2"];
    [imgV1 addTarget:self action:@selector(hello)];
    imgV1.type=HGBImageViewTypeNO;
    [self.view addSubview:imgV1];

    HGBImageView *imgV2=[[HGBImageView alloc]initWithFrame:CGRectMake(230, 80, 120, 120)];
    imgV2.type=HGBImageViewTypeNOLimit;
    imgV2.codeTitle=@"hello";
    imgV2.codeString=@"12212";
    imgV2.image=[UIImage imageNamed:@"cir2"];
    [imgV2 addTarget:self action:@selector(hello)];
    [self.view addSubview:imgV2];

    HGBImageView *imgV3=[[HGBImageView alloc]initWithFrame:CGRectMake(10, 200, 120, 120)];
    imgV3.type=HGBImageViewTypeOnlyTool;
    imgV3.codeTitle=@"hello";
    imgV3.codeString=@"12212";
    imgV3.image=[UIImage imageNamed:@"cir2"];
     [imgV3 addTarget:self action:@selector(hello)];
    [self.view addSubview:imgV3];


    HGBImageView *imgV4=[[HGBImageView alloc]initWithFrame:CGRectMake(230, 200, 120, 120)];
    imgV4.type=HGBImageViewTypeOnlyAction;
    imgV4.codeTitle=@"hello";
    imgV4.image=[UIImage imageNamed:@"cir2"];
    imgV4.codeString=@"12212";
    [imgV4 addTarget:self action:@selector(hello)];
    [self.view addSubview:imgV4];
}
-(void)hello{
    NSLog(@"hello");
}
@end
