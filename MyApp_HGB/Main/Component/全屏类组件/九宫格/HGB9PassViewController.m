//
//  HGB9PassViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGB9PassViewController.h"


#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"


#import "HGBSetLockController.h"
#import "HGBUnlockController.h"




#ifndef SYSTEM_VERSION
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号

#endif

#ifndef KiOS6Later
#define KiOS6Later (SYSTEM_VERSION >= 6)
#endif

#ifndef KiOS7Later
#define KiOS7Later (SYSTEM_VERSION >= 7)
#endif

#ifndef KiOS8Later
#define KiOS8Later (SYSTEM_VERSION >= 8)
#endif

#ifndef KiOS9Later
#define KiOS9Later (SYSTEM_VERSION >= 9)
#endif

#ifndef KiOS10Later
#define KiOS10Later (SYSTEM_VERSION >= 10)
#endif




@interface HGB9PassViewController ()<HGBUnlockControllerDelegate,HGBSetLockControllerDelegate>
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
/**
 密码
 */
@property(strong,nonatomic)NSString *key;
@end

@implementation HGB9PassViewController
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
        titleLab.text=@"九宫格";
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
    self.dataDictionary=@{@"九宫格:":@[@"九宫格设置密码",@"九宫格解密"]};
    self.keys=@[@"九宫格:"];

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
            HGBSetLockController *lockVC=[[HGBSetLockController alloc]init];
            lockVC.delegate=self;

            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:lockVC];
            [self presentViewController:nav animated:YES completion:nil];
        }else if (indexPath.row==1){
            if(self.key==nil){
                [self alertWithPrompt:@"请先设置密码"];
                return;
            }
            HGBUnlockController *lockVC=[[HGBUnlockController alloc]init];
            lockVC.delegate=self;
            lockVC.password=self.key;

            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:lockVC];
            [self presentViewController:nav animated:YES completion:nil];
        }

    }
}
#pragma mark delegate
-(void)lockSetDidCanceled:(HGBSetLockController *)lockSet{
    NSLog(@"cancel");
}
-(void)lockSet:(HGBSetLockController *)lockSet didFinishedWithPath:(NSString *)path{
    self.key=path;
}
-(void)unlock:(HGBUnlockController *)unlock didFinishedWithResult:(HGBUnlockStatus)result{
    NSLog(@"%u",result);
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
