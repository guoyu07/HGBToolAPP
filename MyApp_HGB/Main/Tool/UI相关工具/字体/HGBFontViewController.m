
//
//  HGBFontViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBFontViewController.h"
//#import "HGBFontTool.h"
#import "HGBFontConfig.h"

@interface HGBFontViewController ()

@end

@implementation HGBFontViewController

#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];
    [self viewSetUp];
}
#pragma mark 导航栏
//导航栏
-(void)createNavigationItem
{
    //导航栏
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1];
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=@"字体";
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
#pragma mark UI
/**
 UI
 */
-(void)viewSetUp{
    self.view.backgroundColor=[UIColor whiteColor];
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(10, 100, 200, 30)];
    label1.text=@"字体大小1";
    label1.font=HGBFont(20);
    [self.view addSubview:label1];

    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(10, 150, 200, 30)];
    label2.text=@"字体大小2";
    label2.font=Font14;
    [self.view addSubview:label2];
}

@end
