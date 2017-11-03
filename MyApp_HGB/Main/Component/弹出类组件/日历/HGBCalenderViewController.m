//
//  HGBCalenderViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/24.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCalenderViewController.h"
#import "HGBCalenderView.h"
#import "HGBCalenderPicker.h"
#import "HGBCalenderTextField.h"

#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"


@interface HGBCalenderViewController ()<HGBCalenderViewDelegate,HGBCalenderPickerDelegate>
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBCalenderViewController

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
    titleLab.text=@"日历";
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
    self.dataDictionary=@{@"日历:":@[@"日历弹窗"]};
    self.keys=@[@"日历:"];

    [self.tableView registerClass:[HGBCommonSelectCell class] forCellReuseIdentifier:Identify_Cell];
    [self.tableView reloadData];
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-200*hScale)];
    self.tableView.tableFooterView=headerView;
    HGBCalenderView *calenderView=[[HGBCalenderView alloc]initWithFrame:CGRectMake(10, 10,200, 200)];
    calenderView.promptDic =[NSMutableDictionary dictionaryWithDictionary:@{ @"2017":@{@"10":@{@"23":@"hello"}}}];
    calenderView.delegate=self;

    [headerView addSubview:calenderView];

    HGBCalenderTextField *text=[[HGBCalenderTextField alloc]initWithFrame:CGRectMake(10, 230, 200, 50)];
    text.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:text];
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
            HGBCalenderPicker *pick=[HGBCalenderPicker instanceWithParent:self andWithDelegate:self];
            pick.selectedDateString=@"20171011";
            [pick popInParentView];

        }else if (indexPath.row==1){

        }

    }
}
#pragma mark calenderDelegate

-(void)calender:(HGBCalenderPicker *)calender didFinishWithDate:(NSDate *)date{
    NSLog(@"%@",date);
}
-(void)calender:(HGBCalenderPicker *)calender didFinishWithYear:(NSInteger)year andWithMonth:(NSInteger)month andWithDay:(NSInteger)day andWithWeek:(NSInteger)week{
    NSLog(@"%ld-%ld-%ld-%ld",year,month,day,week);
}
#pragma mark calenderViewDelegate
-(void)calenderView:(HGBCalenderView *)calender didFinishWithYear:(NSInteger)year andWithMonth:(NSInteger)month andWithDay:(NSInteger)day andWithWeek:(NSInteger)week{
    NSLog(@"%ld-%ld-%ld-%ld",year,month,day,week);
}
-(void)calenderView:(HGBCalenderView *)calender didFinishWithDate:(NSDate *)date{
    NSLog(@"%@",date);
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
