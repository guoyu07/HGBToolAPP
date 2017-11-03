//
//  HGBBageTabBarController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/16.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBageTabBarController.h"
#import "HGBTabBarBage3Controller.h"
#import "HGBTabBarBage2Controller.h"
#import "HGBTabBarBage1Controller.h"

@interface HGBBageTabBarController ()

@end

@implementation HGBBageTabBarController

#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewSetUp];
    [self createNavigationItem];

}


#pragma mark 导航栏
//导航栏
-(void)createNavigationItem
{
    //导航栏
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1];
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=@"tabBar bage";
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
    [self addSubControler:[[HGBTabBarBage1Controller alloc]init] withTitle:@"数字" andWithImage:[UIImage imageNamed:@"icon_home_normal"] andWithSelectorImage:[UIImage imageNamed:@"icon_home_select"] andWithNavFlag:YES];
    [self addSubControler:[[HGBTabBarBage2Controller alloc]init] withTitle:@"字母" andWithImage:[UIImage imageNamed:@"icon_component_normal"] andWithSelectorImage:[UIImage imageNamed:@"icon_component_select"] andWithNavFlag:YES];
    [self addSubControler:[[HGBTabBarBage3Controller alloc]init] withTitle:@"点" andWithImage:[UIImage imageNamed:@"icon_tool_normal"] andWithSelectorImage:[UIImage imageNamed:@"icon_tool_select"] andWithNavFlag:YES];


}
@end
