//
//  HGBComponentToolController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBComponentToolController.h"
#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"

#import "HGBComponentTool.h"
#import "HGBBageTabBarController.h"
#import "HGBApplicationBageViewController.h"

@interface HGBComponentToolController ()
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDic;
/**
 数据源
 */
@property(strong,nonatomic)NSArray *keys;

/**
 状态栏样式
 */
@property(assign,nonatomic)UIStatusBarStyle statusBarStyle;
/**
 状态栏显示隐藏
 */
@property(assign,nonatomic)BOOL isHiddenStatusBar;
/**
 表头
 */
@property(strong,nonatomic)UIView *headerView;

/**
 提示标签
 */
@property(strong,nonatomic)UILabel *promptLabel;

@end

@implementation HGBComponentToolController

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
    self.dataDic=@{@"组件工具:":@[@"组件复制",@"修改当前导航栏颜色",@"修改当所有导航栏颜色",@"导航栏隐藏/显示",@"状态栏隐藏/显示",@"修改状态栏样式",@"tabBar角标",@"应用角标"]};
    self.keys=@[@"组件工具:"];
    [self.tableView registerClass:[HGBCommonSelectCell class] forCellReuseIdentifier:Identify_Cell];
    [self.tableView reloadData];

    self.headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    self.headerView.backgroundColor=[UIColor whiteColor];
    self.tableView.tableFooterView=self.headerView;

   self.promptLabel= [[UILabel alloc]initWithFrame:CGRectMake(30* wScale, 30*hScale,100*wScale, 100*hScale)];
    self.promptLabel.backgroundColor = [UIColor clearColor];
    self.promptLabel.text = @"hello";
    self.promptLabel.textColor = [UIColor blueColor];
    self.promptLabel.backgroundColor=[UIColor yellowColor];
    self.promptLabel.textAlignment = NSTextAlignmentLeft;
    self.promptLabel.font = [UIFont systemFontOfSize:12.0];
    self.promptLabel.numberOfLines = 0;
    [self.headerView addSubview:self.promptLabel];

}
#pragma mark table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.keys.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 72 * hScale;
}
//-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return @[@"常用第三方"];
//}

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

            static CGFloat x=0;
            if(x==0){
                x=30*wScale;
            }
            x=x+130*wScale;
           CGRect rect=CGRectMake(x, self.promptLabel.frame.origin.y, self.promptLabel.frame.size.width, self.promptLabel.frame.size.height); rect.origin.x=rect.origin.x+130*wScale;
            UIView *v=[HGBComponentTool duplicateComponent:self.promptLabel];
            v.frame=rect;
            [self.headerView addSubview:v];
        }else if(indexPath.row==1){
            static BOOL flag=0;
            if(flag==NO){
                [HGBComponentTool changeNavgationBarColor:[UIColor redColor]];
                flag=YES;
            }else{
                [HGBComponentTool changeNavgationBarColor:[UIColor blueColor]];
                flag=NO;
            }
        }else if (indexPath.row==2){
            static BOOL flag=0;
            if(flag==NO){
                [HGBComponentTool changeAllNavgationBarColor:[UIColor redColor]];
                flag=YES;
            }else{
                [HGBComponentTool changeAllNavgationBarColor:[UIColor blueColor]];
                flag=NO;
            }

        }else if (indexPath.row==3){
            static BOOL flag=0;
            if(flag){
                [HGBComponentTool setNavgationBarIsHidden:NO];
                flag=NO;
            }else{
                [HGBComponentTool setNavgationBarIsHidden:YES];
                flag=YES;
            }


        }else if (indexPath.row==4){
            static BOOL flag=0;
            if(flag){
                [HGBComponentTool setStatusBarIsHidden:NO];
                flag=NO;
            }else{
                [HGBComponentTool setStatusBarIsHidden:YES];
                flag=YES;
            }
        }else if (indexPath.row==5){
            static BOOL flag=0;
            if(flag){
                [HGBComponentTool setStatusBarStyle:(UIStatusBarStyleDefault)];
                flag=NO;
            }else{
                [HGBComponentTool setStatusBarStyle:(UIStatusBarStyleLightContent)];
                flag=YES;
            }
        }else if (indexPath.row==6){
            [self presentController:[[HGBBageTabBarController alloc]init]];
        }else if (indexPath.row==7){
            [self presentControllerWithNav:[[HGBApplicationBageViewController alloc]init]];
        }
    }
}
-(void)presentController:(UIViewController*)controller{

    [self presentViewController:controller animated:YES completion:nil];
}
-(void)presentControllerWithNav:(UIViewController*)controller{
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
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
