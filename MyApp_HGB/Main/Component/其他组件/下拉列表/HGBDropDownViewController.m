//
//  HGBDropDownViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/24.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBDropDownViewController.h"
#import "HGBDropDown.h"
#import "HGBTitleCell.h"

#define identify_period @"cell"

@interface HGBDropDownViewController ()<HGBDropDownDelegate>
/**
 时间范围数据源
 */
@property(strong,nonatomic)NSArray *periodArr;
/**
 选定时间范围
 */
@property(strong,nonatomic)NSDictionary *periodSelectDic;
/**
 下拉菜单
 */
@property (nonatomic, strong) HGBDropDown * dropDown;
/**
 下拉菜单手势
 */
@property (nonatomic, strong) HGBTapGestureRecognizer * tap;
/**
 周期
 */
@property(strong,nonatomic)UILabel *periodLabel;
/**
 周期按钮
 */
@property(strong,nonatomic)UIButton *periodButton;
@end

@implementation HGBDropDownViewController
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
    titleLab.text=@"下拉列表";
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
    self.dropDown = [[HGBDropDown alloc] initWithFrame:CGRectMake(30,100,160, 30) pattern:kDropDownPatternCustom];
    self.dropDown.delegate = self;
    self.dropDown.borderStyle = kDropDownTopicBorderStyleRect;
  self.dropDown.tableViewBackgroundColor=[UIColor clearColor];
    self.dropDown.cornerRadius=10*hScale;
    self.dropDown.borderColor=[UIColor lightGrayColor];
    self.dropDown.shadowOpacity=0.5;

    [self.view addSubview:self.dropDown];

    self.tap = [[HGBTapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:self.tap];
}
#pragma mark dropDownDelegate

- (NSArray *)itemArrayInDropDown:(HGBDropDown *)dropDown{
    return self.periodArr;
}

- (UIView *)viewForTopicInDropDown:(HGBDropDown *)dropDown{
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.dropDown.frame.size.width, self.dropDown.frame.size.height)];

    CGFloat w_p=100;

    self.periodLabel=[[UILabel alloc]initWithFrame:CGRectMake(30*wScale,0*hScale,w_p-30*wScale, 50*hScale)];
    self.periodLabel.text=@"1年内";
    if(self.periodSelectDic){
        NSString *name=[self.periodSelectDic objectForKey:@"name"];
        if(name&&name.length!=0){
            self.periodLabel.text=[NSString stringWithFormat:@"%@",name];
        }
    }

    self.periodLabel.font=[UIFont  systemFontOfSize:32*hScale];
    self.periodLabel.textColor=[UIColor blackColor];
    self.periodLabel.textAlignment=NSTextAlignmentLeft;
    [backView addSubview:self.periodLabel];

    UIImageView *periodImgV=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.periodLabel.frame),0,72*wScale , 50*hScale)];
    periodImgV.image=[UIImage imageNamed:@"icon_vio_down"];
    [backView addSubview:periodImgV];

    self.periodButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.periodButton.frame=CGRectMake(0, 0,backView.frame.size.width, backView.frame.size.height);
    [self.periodButton addTarget:dropDown action:@selector(show) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.periodButton];

    return backView;
}

- (UITableViewCell *)dropDown:(HGBDropDown *)dropDown tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIndentifier = identify_period;
    HGBTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];

    if (!cell) {
        cell = [[HGBTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.titleLab.frame=CGRectMake(0*wScale,21*hScale, self.dropDown.frame.size.width, 30*hScale);
        cell.titleLab.font=[UIFont systemFontOfSize:30*hScale];

        cell.titleLab.textAlignment=NSTextAlignmentCenter;
        cell.titleLab.textColor=[UIColor redColor];
    }

    NSDictionary * dict = self.periodArr[indexPath.row];
    cell.titleLab.text=dict[@"name"];

    return cell;
}

- (CGFloat)dropDown:(HGBDropDown *)dropDown heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72*hScale;
}

- (void)dropDown:(HGBDropDown *)dropDown didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.periodSelectDic=self.periodArr[indexPath.row];
    NSString *name=[self.periodSelectDic objectForKey:@"name"];
    self.periodLabel.text=[NSString stringWithFormat:@"%@",name];
    NSLog(@"%@",self.periodSelectDic);
}
/**
 *  self.view添加手势取消dropDown第一响应
 */
- (void)tapAction{
    [self.dropDown resignDropDownResponder];
}
#pragma mark get

-(NSArray *)periodArr{
    if(_periodArr==nil){
        _periodArr=@[@{@"id":@"1",@"name":@"一年内",@"period":@"12"},@{@"id":@"2",@"name":@"6个月",@"period":@"6"},@{@"id":@"3",@"name":@"3个月",@"period":@"3"}];
    }
    return _periodArr;
}

@end
