//
//  HGBBottomPopViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBottomPopViewController.h"
#import "HGBBottomSheet.h"
#import "HGBTitleBottomSheet.h"

#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"

/**
 名称:底部弹窗


 调用:1.HGBBottomSheet 底部弹窗
 2.HGBTitleBottomSheet  底部弹窗-带标题底部按钮
 3.HGBBottomSheetDelegate代理
 bottomSheet:didClickButtonWithIndex：点击结果
 bottomSheetDidClickcancelButton:取消
 4.HGBScanControllerDelegate代理
 titleBottomSheet:didClickButtonWithIndex：点击结果
 titleBottomSheet:didClickSecondaryButtonWithIndex：andWithMainIndex：二级点击结果
 titleBottomSheetDidClickcancelButton:取消
 titleBottomSheetDidClickcancelButton:确定


 功能:底部弹窗

 framework:
 Foundation.framework
 UIKit.framework
 */

@interface HGBBottomPopViewController ()<HGBBottomSheetDelegate,HGBTitleBottomSheetDelegate>
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBBottomPopViewController

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
    titleLab.text=@"底部弹出窗";
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
    self.dataDictionary=@{@"底部选择":@[@"底部选择",@"底部弹窗"]};
    self.keys=@[@"底部选择"];

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
            HGBBottomSheet *bottom=[HGBBottomSheet instanceWithDelegate:self InParent:self];
            bottom.titles=@[@"选择1",@"选择2"];
            [bottom popInParentView];


        }else if (indexPath.row==1){
            HGBTitleBottomSheet *bottom=[HGBTitleBottomSheet instanceWithDelegate:self InParent:self];
            bottom.dataSource=@[@{@"title":@"选择1",@"detail":@"选择1",@"type":@"0"},@{@"title":@"选择2",@"detail":@"选择2",@"type":@"1"},@{@"title":@"选择3",@"detail":@"选择3",@"type":@"2"}];
            bottom.popTitle=@"选择";
            bottom.okButtonTitle=@"选择";

            [bottom popInParentView];

        }
        
    }
}

#pragma mark bottom
-(void)bottomSheetDidClickcancelButton:(HGBBottomSheet *)bottomSheet{
    NSLog(@"cancel");
}
-(void)bottomSheet:(HGBBottomSheet *)bottomSheet didClickButtonWithIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
}
#pragma mark bottom title
-(void)titleBottomSheetDidClickOKButton:(HGBTitleBottomSheet *)titleBottomSheet{
    NSLog(@"ok");
}
-(void)titleBottomSheetDidClickCancelButton:(HGBTitleBottomSheet *)titleBottomSheet{
    NSLog(@"cancel");
}
-(void)titleBottomSheet:(HGBTitleBottomSheet *)titleBottomSheet didClickButtonWithIndex:(NSInteger)index{
     NSLog(@"%ld",index);
    titleBottomSheet.typeTitle=@"子选择";
    titleBottomSheet.typeDataSource=@[@{@"title":@"选择1",@"detail":@"选择1",@"type":@"0"},@{@"title":@"选择2",@"detail":@"选择2",@"type":@"1"},@{@"title":@"选择3",@"detail":@"选择3",@"type":@"2"}];
}
-(void)titleBottomSheet:(HGBTitleBottomSheet *)titleBottomSheet didClickSecondaryButtonWithIndex:(NSInteger)idx andWithMainIndex:(NSInteger)index{
    NSLog(@"%ld",index);
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
