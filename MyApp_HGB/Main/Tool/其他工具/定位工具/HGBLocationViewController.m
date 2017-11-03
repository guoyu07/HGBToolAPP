//
//  HGBLocationViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/18.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBLocationViewController.h"
#import "HGBLocation.h"
#import "HGBLocationMapView.h"



#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"



/**
 名称:定位


 调用:1.HGBLocationMapView 地图定位
 2.HGBLocation 定位
 3.HGBLocationCoordinateTool 坐标转换：GCJ WGS Baidu 距离计算
 4.HGBLocationDelegate位置代理
 loaction:didSucessWithLocation:返回位置
 loactionDidFailed:失败
 loaction:didSucessWithLocationInfo:返回位置信息
 5.HGBLocationMapViewDelegate地图代理
 mapview:didSucessWithLocation:返回位置
 mapviewDidFailed:失败
 mapviewDidCanceled:取消
 mapview:didSucessWithLocationInfo:返回位置信息

 framework:
 MapKit.framework
 Foundation.framework
 AVFoundation.framework
 CoreLocation.framework



 权限:  info plist
 位置权限
 <key>NSLocationAlwaysUsageDescription</key>
	<string>$(PRODUCT_NAME)想要访问您的位置</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>$(PRODUCT_NAME)想要访问您的位置</string>

 配置 Capablities Background Modes location updates 打开
 */
@interface HGBLocationViewController ()<HGBLocationDelegate,HGBLocationMapViewDelegate>
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBLocationViewController
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
    titleLab.text=@"定位工具";
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
    self.dataDictionary=@{@"定位工具结果见控制台打印:":@[@"直接定位",@"地图选择位置"]};
    self.keys=@[@"定位工具结果见控制台打印:"];

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
            HGBLocation *location=[HGBLocation shareInstance];
            location.delegate=self;
            [location startLocate];
        }else if (indexPath.row==1){
            HGBLocationMapView *map=[[HGBLocationMapView alloc]init];
            map.delegate=self;
            [map popInParent:self];
            
        }
        
    }
}

#pragma mark location
-(void)loaction:(HGBLocation *)hgblocation didFailedWithError:(NSDictionary *)errorInfo{
    NSLog(@"%@",errorInfo);
}
-(void)loaction:(HGBLocation *)hgblocation didSucessWithLocation:(CLLocation *)location{
    NSLog(@"%@",location);
}
-(void)loaction:(HGBLocation *)hgblocation didSucessWithLocationInfo:(NSDictionary *)locationInfo{
    NSLog(@"%@",locationInfo);
}
#pragma mark map
-(void)mapviewDidCanceled:(HGBLocationMapView *)mapview{
    NSLog(@"cancel");
}
-(void)mapview:(HGBLocationMapView *)mapview didFailedWithError:(NSDictionary *)errorInfo{
    NSLog(@"%@",errorInfo);
}
-(void)mapview:(HGBLocationMapView *)mapview didSucessWithLocation:(CLLocation *)location{
    NSLog(@"%@",location);
}
-(void)mapview:(HGBLocationMapView *)mapview didSucessWithLocationInfo:(NSDictionary *)locationInfo{
    NSLog(@"%@",locationInfo);
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

