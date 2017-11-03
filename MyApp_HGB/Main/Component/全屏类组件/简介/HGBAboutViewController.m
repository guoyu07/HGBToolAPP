//
//  HGBAboutViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBAboutViewController.h"
#import "HGBInstructionController.h"

#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"


@interface HGBAboutViewController ()
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBAboutViewController
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
        titleLab.text=@"简介";
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
    self.dataDictionary=@{@"简介:":@[@"简介"]};
    self.keys=@[@"简介:"];

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
            NSString *attentionString=@"活动时间:\n活动报名时间:2017.3.16-2017.4.15\n奖品发放时间:2017.08.07-2017.08.17\n\n活动期限:\n2017.04.17-2017.07.27 共计100天。\n\n报名方式:\n方法一:下载安装“畅通车友会”APP。\n方法二:关注微信“工银牡丹惠上海”公众账号，回复“百日无违章”即可进入报名页面。\n方法三:关注微信FM105.7公众账号，回复“百日无违章”即可进入报名页面。\n\n活动规则:\n一、本活动从3.16日起至8.17止，活动范围上海市；\n二、适用于所有本市行驶车辆，“微型”、“小型”、“轻型”均可，大中型只接受“客车”均可参赛，每个行驶证、每个手机号、每个车牌号仅可参与一次。\n三、凡报名参赛者只要被交警部门或行政执法部门记录一次违规违章行为即告淘汰。只要从04.17日起至07.27止，100天内没有交通违法，并全年参加2次百日无违章活动，均有机会赢取百吨油。\n四、活动期间累计积分第一名的参赛者将获得“百日无违章”一等奖，奖品1吨油（按92#汽油在奖品发放当日的油价发放油卡）；\n五、活动期间所有无违章者均有机会参加电台105.7每日的抽奖活动，活动奖品30升油（奖品发放期间将公布供获奖者可选择的加油站，以报名车辆油品为准）；\n六、凡参加此次“百日无违章”活动的无违章者均可瓜分百吨油，如无违章人数多于1万人则积分排名前1万名均可获得阳光普照奖，活动奖品每人保底8升油（奖品发放期间将公布供获奖者可选择的加油站，以报名车辆油品为准）；\n七、本次活动最终解释权归主办方所有";
            HGBInstructionController *attentionVC=[[HGBInstructionController alloc]init];
            attentionVC.promptStr=attentionString;
            attentionVC.subTitles=@[@"活动时间:",@"活动期限:",@"报名方式:",@"活动规则:"];
            attentionVC.name=@"活动说明";
            [attentionVC createNavigationItemWithTitle:@"活动说明"];
            [self.navigationController pushViewController:attentionVC animated:YES];
        }
    }
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
