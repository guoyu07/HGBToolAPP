//
//  HGBCodeViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/21.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCodeViewController.h"
#import "HGBScanController.h"
#import "HGBQROrBarCodeTool.h"

#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"


@interface HGBCodeViewController ()<HGBScanControllerDelegate>
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
/**
 图片框
 */
@property(strong,nonatomic)UIImageView *imageView;
@end

@implementation HGBCodeViewController

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
    titleLab.text=@"应用信息工具";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;


    //左键
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回"  style:UIBarButtonItemStylePlain target:self action:@selector(returnhandler)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -15, 0, 5)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];

    //右键
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"二维码条形码扫描"  style:UIBarButtonItemStylePlain target:self action:@selector(scanHandle)];
    [self.navigationItem.rightBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -15, 0, 5)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];


}
//返回
-(void)returnhandler{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)scanHandle{
    HGBScanController *scanVC=[[HGBScanController alloc]init];
    scanVC.delegate=self;

    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:scanVC];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark UI
-(void)viewSetUp{


    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, kWidth, kHeight) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.dataDictionary=@{@"生成":@[@"普通股二维码生成",@"logo二维码生成",@"条形码生成"],@"识别":@[@"识别图中二维码",@"扫描二维码条形码"]};
    self.keys=@[@"生成",@"识别"];

    [self.tableView registerClass:[HGBCommonSelectCell class] forCellReuseIdentifier:Identify_Cell];
    [self.tableView reloadData];

    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth,200)];
    headerView.backgroundColor=[UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];

    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake((kWidth-160)*0.5, 20, 160, 160)];
    self.imageView.backgroundColor=[UIColor lightGrayColor];
    [headerView addSubview:self.imageView];
    self.tableView.tableHeaderView=headerView;
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
            self.imageView.image=[HGBQROrBarCodeTool createQRCodeImageWithString:@"hello"];
        }else if (indexPath.row==1){

            self.imageView.image=[HGBQROrBarCodeTool createQRCodeImageWithString:@"hello" andWithLogoImage:[UIImage imageNamed:@"qrcodelogo"]];
        }else if (indexPath.row==2){
            self.imageView.image=[HGBQROrBarCodeTool createBarCodeWithString:@"hello"];

        }



    }else if (indexPath.section==1){
        if (indexPath.row==0){
            if(self.imageView.image){
                NSLog(@"%@",[HGBQROrBarCodeTool identifyQRCodeImage:self.imageView.image]);
            }else{
                NSLog(@"请先生成二维码");
            }
        }else if (indexPath.row==1){
            HGBScanController *scanVC=[[HGBScanController alloc]init];
            scanVC.delegate=self;

            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:scanVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}
#pragma mark delegate
-(void)scanDidCanceled:(HGBScanController *)scan{
    NSLog(@"cancel");
}
-(void)scan:(HGBScanController *)scan didFailedWithError:(NSDictionary *)errorInfo{
    NSLog(@"%@",errorInfo);
}
-(void)scan:(HGBScanController *)scan didFinishWithResult:(NSString *)result{
    NSLog(@"%@",result);
    [self alertWithPrompt:result];
}
#pragma mark 提示
/**
 展示内容

 @param prompt 提示
*/
-(void)alertWithPrompt:(NSString *)prompt{
#ifdef KiOS8Later
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
#else
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:prompt delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
#endif
}
#pragma mark 获取当前控制器

/**
 获取当前控制器

 @return 当前控制器
 */
-(UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}

/**
 寻找上层控制器

 @param vc 控制器
 @return 上层控制器
*/
- (UIViewController *)findBestViewController:(UIViewController *)vc
    {
        if (vc.presentedViewController) {
            // Return presented view controller
            return [self findBestViewController:vc.presentedViewController];
        } else if ([vc isKindOfClass:[UISplitViewController class]]) {
            // Return right hand side
            UISplitViewController *svc = (UISplitViewController *) vc;
            if (svc.viewControllers.count > 0){
                return [self findBestViewController:svc.viewControllers.lastObject];
            }else{
                return vc;
            }
        } else if ([vc isKindOfClass:[UINavigationController class]]) {
            // Return top view
            UINavigationController *svc = (UINavigationController *) vc;
            if (svc.viewControllers.count > 0){
                return [self findBestViewController:svc.topViewController];
            }else{
                return vc;
            }
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            // Return visible view
            UITabBarController *svc = (UITabBarController *) vc;
            if (svc.viewControllers.count > 0){
                return [self findBestViewController:svc.selectedViewController];
            }else{
                return vc;
            }
        } else {
            return vc;
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
