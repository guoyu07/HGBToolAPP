
//
//  HGBBottomSelectViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBottomSelectViewController.h"
#import "HGBOnePicker.h"
#import "HGBTwoPicker.h"
#import "HGBThreePicker.h"
#import "HGBCommonSelectCell.h"



/**
 名称:单项选择器

 调用:1.HGBOnePicker 单项选择器
 2.HGBOnePickerDelegate代理
 onePicker:didSelectedWithTitle:(NSString *)title：获取结果
 onePickerDidCanceled：取消

 功能:单项选择-支持默认选择

 framework:
 UIKit.framework

 
 名称:两项选择器

 调用:1.HGBTwoPicker 两项选择器
 2.HGBTwoPickerDelegate代理
 twoPicker:didSelectedWithTitleArr:(NSArray *)arr：获取结果
 twoPickerDidCanceled：取消

 功能:两项选择-支持默认选择

 framework:
 UIKit.framework
 
 
 名称:三项选择器

 调用:1.HGBThreePicker 三项选择器
 2.HGBThreePickerDelegate代理
 threePicker: didSelectedWithTitleArr:：结果
 threePickerDidCanceled：取消


 功能:三项选择-支持默认选择

 framework:
 UIKit.framework
 */

#define Identify_Cell @"cell"

@interface HGBBottomSelectViewController ()<HGBOnePickerDelegate,HGBTwoPickerDelegate,HGBThreePickerDelegate>
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBBottomSelectViewController

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
    titleLab.text=@"picker底部选择";
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
#pragma mark UI
-(void)viewSetUp{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, kWidth, kHeight) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.dataDictionary=@{@"picker选择":@[@"单项选择",@"两项选择",@"三项选择"]};
    self.keys=@[@"picker选择"];

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
    if(indexPath.section==0){
        
        if (indexPath.row==0){
            HGBOnePicker *picker=[HGBOnePicker instanceWithParent:self andWithDelegate:self];
            picker.titleStr=@"单项选择";
            picker.selectedItem=@"选择1";
            picker.dataSource=@[@"选择0",@"选择1",@"选择2",@"选择3"];
            [picker popInParentView];
        }else if (indexPath.row==1){
            HGBTwoPicker *picker=[HGBTwoPicker instanceWithParent:self andWithDelegate:self];
            picker.titleStr=@"两项选择";
            picker.selectedItems=@[@"选择1",@"选择11"];
            picker.dataSource=@{@"选择0":@[@"选择00",@"选择01",@"选择02",@"选择03"],@"选择1":@[@"选择10",@"选择11",@"选择12",@"选择13"]};
            [picker popInParentView];
        }else if (indexPath.row==2){
            HGBThreePicker *picker=[HGBThreePicker instanceWithParent:self andWithDelegate:self];
            picker.titleStr=@"三项选择";
            picker.selectedItems=@[@"选择1",@"选择11",@"选择111"];
            picker.dataSource=@{@"选择0":@{@"选择00":@[@"000",@"001"]},@"选择1":@{@"选择10":@[@"选择100",@"选择101"],@"选择11":@[@"选择110",@"选择111",@"选择112"]}};
            [picker popInParentView];
        }

        
    }
}
#pragma mark one
-(void)onePicker:(HGBOnePicker *)picker didSelectedWithTitle:(NSString *)title{
    NSLog(@"%@",title);
}
-(void)onePickerDidCanceled:(HGBOnePicker *)picker{
    NSLog(@"cancel");
}
#pragma mark two
-(void)twoPickerDidCanceled:(HGBTwoPicker *)picker{
    NSLog(@"cancel");
}
-(void)twoPicker:(HGBTwoPicker *)picker didSelectedWithTitleArr:(NSArray *)arr{
    NSLog(@"%@",arr);
}
#pragma mark three
-(void)threePickerDidCanceled:(HGBThreePicker *)picker{
    NSLog(@"cancel");
}
-(void)threePicker:(HGBThreePicker *)picker didSelectedWithTitleArr:(NSArray *)arr{
    NSLog(@"%@",arr);
}
#pragma mark get
-(NSDictionary *)dataDictionary{
    if(_dataDictionary==nil){
        _dataDictionary=[NSDictionary dictionary];
    }
    return _dataDictionary;
}
-(NSArray *)keys{
    if(_keys==nil){
        _keys=[NSArray array];
    }
    return _keys;
}
@end
