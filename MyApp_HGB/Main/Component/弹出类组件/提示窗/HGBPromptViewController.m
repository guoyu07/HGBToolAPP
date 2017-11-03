//
//  HGBPromptViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBPromptViewController.h"
#import "HGBPromptTool.h"


#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"


/**
 名称:提示弹窗


 调用:1.HGBAlertTool 提示弹窗封装
 2.HGBPromgressHud  吐司封装

 功能：提示弹窗

 framework:
 UIKit.framework
 */
@interface HGBPromptViewController ()
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBPromptViewController

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
    titleLab.text=@"提示窗";
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
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, kWidth, kHeight) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.dataDictionary=@{@"alert:":@[@"单键-提示",@"单键-标题提示",@"单键-标题提示-功能",@"单键-标题提示-按钮标题-功能",@"双键-标题提示-按钮标题-功能",@"多键-标题提示-按钮标题-功能",@"提示框配置"],@"HUD:":@[@"提示",@"提示-标题",@"提示-时间",@"底部提示",@"加载提示"],@"sheet":@[@"不带标题",@"带标题",@"提示框配置"]};
  ;
    self.keys=@[@"alert:",@"sheet",@"HUD:"];;
    [self.tableView registerClass:[HGBCommonSelectCell class] forCellReuseIdentifier:Identify_Cell];
    [self.tableView reloadData];
}
#pragma mark table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.keys.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 72 * hScale;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 72 * hScale)];
    headView.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    //信息提示栏
    UILabel *tipMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(32 * wScale, 0, kWidth - 32 * wScale, CGRectGetHeight(headView.frame))];
    tipMessageLabel.backgroundColor = [UIColor clearColor];
     tipMessageLabel.text =self.keys[section];
    tipMessageLabel.textColor = [UIColor grayColor];
    tipMessageLabel.textAlignment = NSTextAlignmentLeft;
    tipMessageLabel.font = [UIFont systemFontOfSize:12.0];
    tipMessageLabel.numberOfLines = 0;
    [headView addSubview:tipMessageLabel];
    return headView;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key=self.keys[section];
    NSArray *dataAraay=[self.dataDictionary objectForKey:key];
    return  dataAraay.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HGBCommonSelectCell *cell=[tableView dequeueReusableCellWithIdentifier:Identify_Cell forIndexPath:indexPath];
    NSString *key=self.keys[indexPath.section];
    NSArray *dataArray=[self.dataDictionary objectForKey:key];
    cell.title.text=dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [HGBAlertTool setTitleColor:nil];
    [HGBAlertTool setTitleFontSize:0];
    [HGBAlertTool setSubTitleFontSize:0];
    [HGBAlertTool setSubTitleColor:nil];
    [HGBAlertTool setButtonTitleColor:nil];
    [HGBAlertTool setButtonTitleFontSize:0];
    if(indexPath.section==0){
        if (indexPath.row==0){
            [HGBAlertTool alertWithPrompt:@"hello1" InParent:self];

        }else if (indexPath.row==1){
            [HGBAlertTool alertPromptWithTitle:@"hello2" andWithPrompt:@"hello world2" InParent:self];

        }else if (indexPath.row==2){
            [HGBAlertTool alertWithTitle:@"hello 3" andWithPrompt:@"hello world3" andWithClickBlock:^(NSInteger index) {
                NSLog(@"hello world3");
            } InParent:self];



        }else if (indexPath.row==3){
            [HGBAlertTool alertWithTitle:@"hello4" andWithPrompt:@"hello world4" andWithConfirmButtonTitle:@"hello4" andWithClickBlock:^(NSInteger index) {
                 NSLog(@"hello world4");
            } InParent:self];

        }else if (indexPath.row==4){
            [HGBAlertTool alertWithTitle:@"hello5" andWithPrompt:@"hello world5" andWithConfirmButtonTitle:@"hello5-0" andWithCancelButtonTitle:@"hello5-1" andWithClickBlock:^(NSInteger index) {
                if(index==0){
                    NSLog(@"hello5-0");

                }else if (index==1){
                     NSLog(@"hello5-1");
                }
            } InParent:self];

        }else if (indexPath.row==5){
            [HGBAlertTool alertWithTitle:@"hello6" andWithPrompt:@"hello world6" andWithButtonTitles:@[@"hello6-0",@"hello6-1",@"hello6-2",@"hello6-3"] andWithClickBlock:^(NSInteger index) {
                NSLog(@"hello6-%ld",index);
            } InParent:self];
        }else if (indexPath.row==6){
            [HGBAlertTool setTitleColor:[UIColor redColor]];
            [HGBAlertTool setTitleFontSize:7];
            [HGBAlertTool setSubTitleFontSize:6];
            [HGBAlertTool setSubTitleColor:[UIColor grayColor]];
            [HGBAlertTool setButtonTitleColor:[UIColor yellowColor]];
            [HGBAlertTool setButtonTitleFontSize:10];
            [HGBAlertTool alertWithTitle:@"hello7" andWithPrompt:@"hello world7" andWithButtonTitles:@[@"hello7-0",@"hello7-1",@"hello6-7",@"hello7-3"] andWithClickBlock:^(NSInteger index) {
                NSLog(@"hello7-%ld",index);
            } InParent:self];
        }

        
    }else if (indexPath.section==1){
        if (indexPath.row==0){

            [HGBAlertTool sheetWithButtonTitles:@[@"1",@"2",@"3",@"4",@"5"] andWithClickBlock:^(NSInteger index) {
                 NSLog(@"hello1-%ld",index);
            } InParent:self];
        }else if (indexPath.row==1){
            [HGBAlertTool sheetWithTitle:@"hello1" andWithPrompt:@"hello world1" andWithButtonTitles:@[@"1",@"2",@"3",@"4",@"5"] andWithClickBlock:^(NSInteger index) {
                 NSLog(@"hello1-%ld",index);
            } InParent:self];
        }else if (indexPath.row==2){
            [HGBAlertTool setTitleColor:[UIColor redColor]];
            [HGBAlertTool setTitleFontSize:7];
            [HGBAlertTool setSubTitleFontSize:6];
            [HGBAlertTool setSubTitleColor:[UIColor grayColor]];
            [HGBAlertTool setButtonTitleColor:[UIColor yellowColor]];
            [HGBAlertTool setButtonTitleFontSize:10];
            [HGBAlertTool sheetWithTitle:@"hello2" andWithPrompt:@"hello world2" andWithButtonTitles:@[@"1",@"2",@"3",@"4",@"5"] andWithClickBlock:^(NSInteger index) {
                NSLog(@"hello2-%ld",index);
            } InParent:self];
        }
    }else if (indexPath.section==2){
        if (indexPath.row==0){

            [HGBPromgressHud showHUDResult:@"hello6" ToView:self.view];
        }else if (indexPath.row==1){
            [HGBPromgressHud setShowTitle:@"hello7"];
            [HGBPromgressHud showHUDResult:@"hello7" ToView:self.view];

        }else if (indexPath.row==2){
            [HGBPromgressHud setShowDuration:5];
            [HGBPromgressHud setShowTitle:@"提示"];
            [HGBPromgressHud showHUDResult:@"hello8" ToView:self.view];

        }else if (indexPath.row==3){
            [HGBPromgressHud setShowTitle:@"提示"];
            [HGBPromgressHud showHUDResult:@"hello" WithoutBackToView:self.view];

        }else if (indexPath.row==4){
            [HGBPromgressHud showHUDSaveToView:self.view];
            [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
                [HGBPromgressHud hideSave];
            }];
            
        }
    }
}



@end
