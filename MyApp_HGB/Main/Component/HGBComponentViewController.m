//
//  HGBComponentViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBComponentViewController.h"
#import "HGBCommonSelectCell.h"

#import "HGBKeybordController.h"
#import "HGBPromptViewController.h"
#import "HGBBottomPopViewController.h"
#import "HGBBottomSelectViewController.h"
#import "HGBDateViewController.h"
#import "HGBTimeViewController.h"
#import "HGBCalenderViewController.h"


#import "HGBCameraViewController.h"
#import "HGBScanCommonViewController.h"
#import "HGBCodeScanViewController.h"
#import "HGBWebViewController.h"
#import "HGBAboutViewController.h"
#import "HGB9PassViewController.h"
#import "HGBSignViewController.h"
#import "HGBTableSelectorViewController.h"
#import "HGBMapViewController.h"
#import "HGBCordovaViewController.h"
#import "HGBWeexViewController.h"

#import "HGBIndexViewController.h"
#import "HGBCirculateViewController.h"
#import "HGBNumberScrollViewController.h"
#import "HGBSearchBarViewController.h"
#import "HGBImageViewViewController.h"
#import "HGBTextViewController.h"
#import "HGBDropDownViewController.h"
#import "HGBNotificationPopViewController.h"
#import "HGBStarViewController.h"
#import "HGBPageViewController.h"
#import "HGBChatViewController.h"
#import "HGBCenterViewController.h"


#define Identify_Cell @"cell"

@interface HGBComponentViewController ()
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDic;
/**
 数据源
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBComponentViewController

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
    titleLab.text=@"组件";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;
    

}
//返回
-(void)returnhandler{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UI
-(void)viewSetUp{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, kWidth, kHeight-44) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.dataDic=@{@"弹出类组件:":@[@"键盘",@"提示",@"底部弹出窗",@"日期选择",@"时间选择",@"Picker选择",@"日历"],@"全屏类组件:":@[@"相机",@"普通扫描",@"二维码扫描",@"浏览器",@"锁屏",@"简介",@"表格选择",@"签名",@"地图",@"Cordova浏览器",@"Weex浏览器"],@"小组件":@[@"表格索引",@"轮播图",@"数字轮播",@"搜索框",@"图片",@"文本",@"下拉列表",@"消息",@"星星评价",@"页码控制器",@"图表",@"中间弹窗"]};
    self.keys=@[@"弹出类组件:",@"全屏类组件:",@"小组件"];
   
    [self.tableView registerClass:[HGBCommonSelectCell class] forCellReuseIdentifier:Identify_Cell];
    [self.tableView reloadData];
}
#pragma mark table view delegate
#pragma mark table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.keys.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 72 * hScale;
}
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return @[@"弹出",@"全屏",@"小"];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 72* hScale)];
    headView.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    //信息提示栏
    UILabel *tipMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(32 * wScale, 0, kWidth - 32 * wScale, CGRectGetHeight(headView.frame))];
    tipMessageLabel.backgroundColor = [UIColor clearColor];
    NSString *key=self.keys[section];
    tipMessageLabel.text = key;
    tipMessageLabel.textColor = [UIColor grayColor];
    tipMessageLabel.textAlignment = NSTextAlignmentLeft;
    tipMessageLabel.font = [UIFont systemFontOfSize:12.0];
    tipMessageLabel.numberOfLines = 0;
    [headView addSubview:tipMessageLabel];
    return headView;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key=self.keys[section];
    NSArray *data=self.dataDic[key];
    return data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HGBCommonSelectCell *cell=[tableView dequeueReusableCellWithIdentifier:Identify_Cell forIndexPath:indexPath];
    NSString *key=self.keys[indexPath.section];
    NSArray *data=self.dataDic[key];
    NSString *string=[data objectAtIndex:indexPath.row];
    cell.title.text=string;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0){
        if(indexPath.row==0){
            [self presentController:[[HGBKeybordController alloc]init]];
        }else if (indexPath.row==1){
            [self presentController:[[HGBPromptViewController alloc]init]];
        }else if (indexPath.row==2){
            [self presentController:[[HGBBottomPopViewController alloc]init]];
        }else if (indexPath.row==3){
            [self presentController:[[HGBDateViewController alloc]init]];
        }else if (indexPath.row==4){
            [self presentController:[[HGBTimeViewController alloc]init]];
        }else if (indexPath.row==5){
            [self presentController:[[HGBBottomSelectViewController alloc]init]];
        }else if (indexPath.row==6){
            [self presentController:[[HGBCalenderViewController alloc]init]];
        }

    }else if(indexPath.section==1){
        if(indexPath.row==0){
            [self presentController:[[HGBCameraViewController alloc]init]];
        }else if (indexPath.row==1){
            [self presentController:[[HGBScanCommonViewController alloc]init]];
        }else if (indexPath.row==2){
            [self presentController:[[HGBCodeScanViewController alloc]init]];
        }else if (indexPath.row==3){
            [self presentController:[[HGBWebViewController alloc]init]];
        }else if (indexPath.row==4){
            [self presentController:[[HGB9PassViewController alloc]init]];
        }else if (indexPath.row==5){
            [self presentController:[[HGBAboutViewController alloc]init]];
        }else if (indexPath.row==6){
            [self presentController:[[HGBTableSelectorViewController alloc]init]];
        }else if (indexPath.row==7){
            [self presentController:[[HGBSignViewController alloc]init]];
        }else if (indexPath.row==8){
            [self presentController:[[HGBMapViewController alloc]init]];
        }else if (indexPath.row==9){

            [self presentController:[[HGBCordovaViewController alloc]init]];
        }else if (indexPath.row==10){

            [self presentController:[[HGBWeexViewController alloc]init]];
        }
    }else if(indexPath.section==2){
        if(indexPath.row==0){
            [self presentController:[[HGBIndexViewController alloc]init]];
        }else if (indexPath.row==1){
            [self presentController:[[HGBCirculateViewController alloc]init]];
        }else if (indexPath.row==2){
            [self presentController:[[HGBNumberScrollViewController alloc]init]];
        }else if (indexPath.row==3){
            [self presentController:[[HGBSearchBarViewController alloc]init]];
        }else if (indexPath.row==4){
            [self presentController:[[HGBImageViewViewController alloc]init]];
        }else if (indexPath.row==5){
            [self presentController:[[HGBTextViewController alloc]init]];
        }else if (indexPath.row==6){
            [self presentController:[[HGBDropDownViewController alloc]init]];
        }else if (indexPath.row==7){
            [self presentController:[[HGBNotificationPopViewController alloc]init]];
        }else if (indexPath.row==8){
            [self presentController:[[HGBStarViewController alloc]init]];
        }else if (indexPath.row==9){

            [self presentController:[[HGBPageViewController alloc]init]];
        }else if (indexPath.row==10){
            [self presentController:[[HGBChatViewController alloc]init]];
            
        }else if (indexPath.row==11){
            [self presentController:[[HGBCenterViewController alloc]init]];

        }
    }
}
-(void)presentController:(UIViewController*)controller{
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:controller];
    [self.tabBarController presentViewController:nav animated:YES completion:nil];
}
#pragma mark get
-(NSDictionary *)dataDic{
    if(_dataDic==nil){
        _dataDic=[NSDictionary dictionary];
    }
    return _dataDic;
}
-(NSArray *)keys{
    if(_keys==nil){
        _keys=[NSArray array];
    }
    return _keys;
}
@end
