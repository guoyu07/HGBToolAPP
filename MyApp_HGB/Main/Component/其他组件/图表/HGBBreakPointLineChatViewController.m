//
//  HGBBreakPointLineChatViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBreakPointLineChatViewController.h"
#import "HGBBrokenLineChat.h"
@interface HGBBreakPointLineChatViewController ()<HGBBrokenLineChatDelegate>

@end

@implementation HGBBreakPointLineChatViewController
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
    titleLab.text=@"折线图";
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

    HGBBrokenLineValue *value1 = [HGBBrokenLineValue getBrokenLineValueWithX:10 andWithY:10 andWithColor:[UIColor redColor] andWithIndex:1];
    HGBBrokenLineValue *value2 = [HGBBrokenLineValue getBrokenLineValueWithX:30 andWithY:120 andWithColor:[UIColor redColor] andWithIndex:2];
    HGBBrokenLineValue *value3 = [HGBBrokenLineValue getBrokenLineValueWithX:60 andWithY:80 andWithColor:[UIColor redColor] andWithIndex:3];
    HGBBrokenLineValue *value4 = [HGBBrokenLineValue getBrokenLineValueWithX:80 andWithY:10 andWithColor:[UIColor redColor] andWithIndex:4];
    HGBBrokenLineValue *value5 = [HGBBrokenLineValue getBrokenLineValueWithX:100 andWithY:100 andWithColor:[UIColor redColor] andWithIndex:5];
    HGBBrokenLineValue *value6 = [HGBBrokenLineValue getBrokenLineValueWithX:110 andWithY:109 andWithColor:[UIColor redColor] andWithIndex:6];
    HGBBrokenLineValue *value7 = [HGBBrokenLineValue getBrokenLineValueWithX:150 andWithY:90 andWithColor:[UIColor redColor] andWithIndex:7];
    HGBBrokenLineValue *value8 = [HGBBrokenLineValue getBrokenLineValueWithX:180 andWithY:60 andWithColor:[UIColor redColor] andWithIndex:8];

    NSArray *dataArray = @[value1, value2, value3, value4, value5, value6, value7, value8];

    HGBBrokenLineChat *brokenline = [[HGBBrokenLineChat alloc] initWithFrame:CGRectMake(0, 100, 300, 500) dataArray:dataArray];
    brokenline.animation = YES;
    brokenline.xSectionNum = 10;
    brokenline.ySectionNum = 10;
    brokenline.needCloud = YES;
    brokenline.showPoint = YES;
    brokenline.delegate=self;
    [self.view addSubview:brokenline];
}
-(void)brokenLineChat:(HGBBrokenLineChat *)brokenLineChat didClickWithValue:(HGBBrokenLineValue *)value{
    NSLog(@"%f-%f-%ld",value.x,value.y,value.index);
}
@end
