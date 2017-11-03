//
//  HGBCirculateViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/24.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCirculateViewController.h"

#import "HGBCirculateScrollView.h"
@interface HGBCirculateViewController ()
@property(strong,nonatomic)NSArray *dataSource;
@end

@implementation HGBCirculateViewController
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
    titleLab.text=@"轮播图";
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
    HGBCirculateScrollView* scollView1=[[HGBCirculateScrollView alloc]initWithFrame:CGRectMake(10,80, 160,320)];
    scollView1.PageControlPageIndicatorTintColor = [UIColor whiteColor];
    scollView1.pageControlCurrentPageIndicatorTintColor = [UIColor redColor];
    scollView1.autoTime = [NSNumber numberWithFloat:12.0f];

    [self.view addSubview:scollView1];

    NSMutableArray *viewArray=[NSMutableArray array];
    for(int  i=0;i<self.dataSource.count;i++){
        NSString *imageName=self.dataSource[i];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scollView1.frame.size.width,scollView1.frame.size.height)];
        imageView.image=[UIImage imageNamed:imageName];
        [viewArray addObject:imageView];
    }
   scollView1.slideViewsArray=viewArray;
   scollView1.isVerticalScroll=NO;
   scollView1.autoTime = [NSNumber numberWithFloat:4.0f];
    scollView1.layer.masksToBounds=YES;
    scollView1.layer.borderColor=[[UIColor redColor]CGColor];
    scollView1.layer.borderWidth=2;
  [scollView1 startLoading];


    HGBCirculateScrollView* scollView2=[[HGBCirculateScrollView alloc]initWithFrame:CGRectMake(180,80, 160,320)];
    scollView2.PageControlPageIndicatorTintColor = [UIColor whiteColor];
    scollView2.pageControlCurrentPageIndicatorTintColor = [UIColor redColor];
    scollView2.layer.masksToBounds=YES;
    scollView2.layer.borderColor=[[UIColor redColor]CGColor];
    scollView2.layer.borderWidth=2;

    scollView2.autoTime = [NSNumber numberWithFloat:12.0f];

    [self.view addSubview:scollView2];
    NSMutableArray *viewArray2=[NSMutableArray array];
    for(int  i=0;i<self.dataSource.count;i++){
        NSString *imageName=self.dataSource[i];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scollView2.frame.size.width, scollView2.frame.size.height)];
        imageView.image=[UIImage imageNamed:imageName];
        [viewArray2 addObject:imageView];
    }
    scollView2.slideViewsArray=viewArray2;
    scollView2.isVerticalScroll=YES;
    scollView2.withoutAutoScroll=YES;
    scollView2.autoTime = [NSNumber numberWithFloat:4.0f];
    [scollView2 startLoading];








}
#pragma mark get
-(NSArray *)dataSource{
    if(_dataSource==nil){
        _dataSource=@[@"cir0",@"cir1",@"cir2",@"cir3"];
    }
    return _dataSource;
}

@end
