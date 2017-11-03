//
//  HGBDeviceViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/19.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBDeviceViewController.h"

#import "HGBDeviceInfoTool.h"
#import "HGBBatteryTool.h"

#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"



@interface HGBDeviceViewController ()<HGBBatteryToolDelegate>
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBDeviceViewController

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
    titleLab.text=@"设备信息工具";
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
    self.dataDictionary=@{@"设备信息":@[@"获取手机序列号",@"获取ip",@"获取手机别名",@"获取系统名称",@"获取手机系统版本",@"获取手机基本型号",@"获取设备型号",@"电池信息",@"CPU信息实例:厂家",@"内存信息实例:总内存"]};
    self.keys=@[@"设备信息"];

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
            NSLog(@"惟一标识:%@",[HGBDeviceInfoTool getUniqueIdentifier]);

        }else if (indexPath.row==1){
            NSLog(@"IP地址:%@",[HGBDeviceInfoTool getIPAddress]);

        }else if (indexPath.row==2){
            NSLog(@"手机别名:%@",[HGBDeviceInfoTool getUserPhoneName]);

        }else if (indexPath.row==3){
            NSLog(@"系统名称:%@",[HGBDeviceInfoTool getSystemName]);

        }else if (indexPath.row==4){
            NSLog(@"系统版本:%@",[HGBDeviceInfoTool getPhoneVersion]);

        }else if (indexPath.row==5){
            NSLog(@"获取手机型号:%@",[HGBDeviceInfoTool getPhoneModel]);
            NSLog(@"获取设备型号:%@",[HGBDeviceInfoTool getLocalPhoneModel]);

        }else if (indexPath.row==6){
            NSLog(@"获取设备型号:%@",[HGBDeviceInfoTool getDeviceModelName]);


        }else if (indexPath.row==7){
            [HGBBatteryTool sharedInstance].delegate=self;
            [[HGBBatteryTool sharedInstance]startBatteryMonitoring];

        }else if (indexPath.row==8){
            NSLog(@"CPU厂家:%@",[HGBDeviceInfoTool getCPUProcessor]);

        }else if (indexPath.row==9){
            NSLog(@"总内存:%lld",[HGBDeviceInfoTool getTotalMemory]);

        }



        
    }
}
#pragma mark delegate
-(void)batteryStatusDidUpdated:(HGBBatteryTool *)battery{
    NSLog(@"电池状态:%@-电压:%f-电量:%ld-电量百分比:%ld-总电量:%lu",battery.status,battery.voltage,battery.levelMAH,battery.levelPercent,battery.capacity);
    [battery stopBatteryMonitoring];
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
