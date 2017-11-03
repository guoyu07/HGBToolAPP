//
//  HGBPieChatViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBPieChatViewController.h"
#import "HGBPieChat.h"

@interface HGBPieChatViewController ()<HGBPieChatDelegate>

@end

@implementation HGBPieChatViewController
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
    titleLab.text=@"饼状图";
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
-(void)viewSetUp{
    self.view.backgroundColor=[UIColor whiteColor];
    
    HGBPieValue *value1 = [HGBPieValue getPieValueWithNumber:30 andWithColor:[UIColor redColor] andWithText:@"1" andWithIndex:1];
    HGBPieValue *value2 = [HGBPieValue getPieValueWithNumber:20 andWithColor:[UIColor blueColor] andWithText:@"2" andWithIndex:2];
    HGBPieValue *value3 = [HGBPieValue getPieValueWithNumber:40 andWithColor:[UIColor greenColor] andWithText:@"3" andWithIndex:3];
    HGBPieValue *value4 = [HGBPieValue getPieValueWithNumber:50 andWithColor:[UIColor grayColor] andWithText:@"4" andWithIndex:4];
    HGBPieValue *value5 = [HGBPieValue getPieValueWithNumber:60 andWithColor:[UIColor magentaColor] andWithText:@"5" andWithIndex:5];

    HGBPieChat *pieChart = [[HGBPieChat alloc] initWithFrame:CGRectMake(20, 100, 200, 150) dataArray:@[value1, value2, value3, value4, value5]];
    pieChart.radius = 100;
    pieChart.needAnimation = YES;
    pieChart.draWAlong = NO;
    pieChart.showText = YES;
    pieChart.delegate=self;
    [self.view addSubview:pieChart];
}
-(void)pieChat:(HGBPieChat *)pieChat didClickWithValue:(HGBPieValue *)value{
    NSLog(@"%f-%f-%@-%ld",value.number,value.percent,value.text,value.index);
}
@end
