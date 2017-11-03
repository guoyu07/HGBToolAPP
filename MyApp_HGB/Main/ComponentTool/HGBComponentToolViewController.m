//
//  HGBComponentToolViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBComponentToolViewController.h"
#import "HGBCommonSelectCell.h"

#define Identify_Cell @"cell"


#import "HGBComponentToolController.h"
#import "HGBControllerViewController.h"

#import "HCollectionViewController.h"
#import "HTableViewController.h"
#import "HViewController.h"
#import "HTabBarViewController.h"
#import "HGBNavigationController.h"
#import "HLayoutCollectionViewController.h"

@interface HGBComponentToolViewController ()
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDic;
/**
 数据源
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBComponentToolViewController

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
    titleLab.text=@"组件工具";
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
    self.dataDic=@{@"组件工具:":@[@"控制器工具",@"组件工具"],@"基类:":@[@"Nav-C-V",@"tabBar",@"table",@"collection",@"瀑布流"]};
    self.keys=@[@"组件工具:",@"基类:"];
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
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return @[@"组件工具",@"基类"];
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
            [self presentController:[[HGBControllerViewController alloc]init]];
        }else if (indexPath.row==1){
            [self presentController:[[HGBComponentToolController alloc]init]];
        }else if (indexPath.row==2){

        }else if (indexPath.row==3){

        }else if (indexPath.row==4){

        }else if (indexPath.row==5){

        }
    }else if(indexPath.section==1){
        if(indexPath.row==0){
            HViewController  *controller=[[HViewController alloc]init];
            HGBNavigationController *nav=[[HGBNavigationController alloc]initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }else if (indexPath.row==1){
            [self presentController:[[HTabBarViewController alloc]init] WithNavFlag:NO];
        }else if (indexPath.row==2){
            [self presentController:[[HTableViewController alloc]init] WithNavFlag:YES];
        }else if (indexPath.row==3){
            [self presentController:[[HCollectionViewController alloc]init] WithNavFlag:YES];
        }else if (indexPath.row==4){
            [self presentController:[[HLayoutCollectionViewController alloc]init] WithNavFlag:YES];
        }else if (indexPath.row==5){

        }
    }
}
-(void)presentController:(UIViewController*)controller{
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:controller];
    [self.tabBarController presentViewController:nav animated:YES completion:nil];
}
-(void)presentController:(UIViewController*)controller WithNavFlag:(BOOL)navFlag{

    if(navFlag){
         UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:controller];
         [self.tabBarController presentViewController:nav animated:YES completion:nil];
    }else{
        [self.tabBarController presentViewController:controller animated:YES completion:nil];
    }

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
