//
//  HGBNumberScrollViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/24.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBNumberScrollViewController.h"
#import "HGBNumberScrollAnimatedView.h"

@interface HGBNumberScrollViewController ()

@end

@implementation HGBNumberScrollViewController
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
    titleLab.text=@"数字轮播";
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
 HGBNumberScrollAnimatedView *numberScrollView=[[HGBNumberScrollAnimatedView alloc]initWithFrame:CGRectMake(30, 80,100, 80*hScale)];
    numberScrollView.font = [UIFont boldSystemFontOfSize:72*hScale];
    numberScrollView.textColor = [UIColor redColor];
    [self.view addSubview:numberScrollView];
    numberScrollView.minLength = 1;
    numberScrollView.number =[NSNumber numberWithInteger:0];
    [numberScrollView startAnimation];



    HGBNumberScrollAnimatedView *numberScrollView2=[[HGBNumberScrollAnimatedView alloc]initWithFrame:CGRectMake(30, 180,100, 80*hScale)];
    numberScrollView2.font = [UIFont boldSystemFontOfSize:72*hScale];
    numberScrollView2.textColor = [UIColor redColor];
    [self.view addSubview:numberScrollView2];
    numberScrollView2.minLength = 1;
    numberScrollView2.number =[NSNumber numberWithInteger:0];
    [numberScrollView2 startAnimation];
    static int i=0;
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        numberScrollView2.number =[NSNumber numberWithInteger:i];
        i++;
    }];



}
@end
