//
//  HGBBarChatViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBarChatViewController.h"
#import "HGBBarChat.h"

@interface HGBBarChatViewController ()<HGBBarChatDelegate>

@end

@implementation HGBBarChatViewController
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
    titleLab.text=@"条形图";
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
    HGBBarValue *value1 = [HGBBarValue getBarValueWithX:10 andWithY:10 andWithColor:[UIColor redColor] andWithIndex:1];
    HGBBarValue *value2 = [HGBBarValue getBarValueWithX:30 andWithY:120 andWithColor:[UIColor cyanColor] andWithIndex:2];
    HGBBarValue *value3 = [HGBBarValue getBarValueWithX:60 andWithY:80 andWithColor:[UIColor yellowColor] andWithIndex:3];
    HGBBarValue *value4 = [HGBBarValue getBarValueWithX:80 andWithY:10 andWithColor:[UIColor blackColor] andWithIndex:4];
    HGBBarValue *value5 = [HGBBarValue getBarValueWithX:100 andWithY:100 andWithColor:[UIColor blueColor] andWithIndex:5];
    HGBBarValue *value6 = [HGBBarValue getBarValueWithX:110 andWithY:109 andWithColor:[UIColor greenColor] andWithIndex:6];
    HGBBarValue *value7 = [HGBBarValue getBarValueWithX:150 andWithY:90 andWithColor:[UIColor grayColor] andWithIndex:7];
    HGBBarValue *value8 = [HGBBarValue getBarValueWithX:180 andWithY:60 andWithColor:[UIColor lightGrayColor] andWithIndex:8];

    NSArray *dataArray = @[value1, value2, value3, value4, value5, value6, value7, value8];

    HGBBarChat *barchart = [[HGBBarChat alloc] initWithFrame:CGRectMake(0, 100, 360, 500) dataArray:dataArray];
    barchart.delegate=self;

    barchart.xDistance = 40;
    barchart.ySectionNum = 9;

    barchart.borderColor = [UIColor redColor];

    barchart.animation = YES;
    [self.view addSubview:barchart];
}
-(void)barChat:(HGBBarChat *)pieChat didClickWithValue:(HGBBarValue *)value{
//    NSLog(@"%f-%f-%ld",value.x,value.y,value.index);
}
@end
