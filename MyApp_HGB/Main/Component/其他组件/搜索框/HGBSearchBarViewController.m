//
//  HGBSearchBarViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/24.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBSearchBarViewController.h"
#import "HGBSearchBar.h"
@interface HGBSearchBarViewController ()<HGBSearchBarDelegate>
@property(strong,nonatomic)HGBSearchBar *search;
@end

@implementation HGBSearchBarViewController
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
    titleLab.text=@"搜索框";
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
#pragma mark view
-(void)viewSetUp{
     self.view.backgroundColor=[UIColor whiteColor];
    HGBSearchBar *search=[[HGBSearchBar alloc]initWithFrame:CGRectMake(10, 80, 200, 30)];
    search.placeholder=@"请输入搜索内容";
    search.delegate=self;
    self.search=search;
    [self.view addSubview:search];
    [search becomeFirstResponder];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.search resignFirstResponder];
}
#pragma mark searchdelegate
-(void)searchBarDidEndEdit:(HGBSearchBar *)searchBar{
    NSLog(@"end");
}
-(void)searchBarDidBecomeEdit:(HGBSearchBar *)searchBar{
    NSLog(@"start");
}
-(void)searchButtonDidClicked:(HGBSearchBar *)searchBar{
    NSLog(@"search");
}
-(void)searchBar:(HGBSearchBar *)searchBar stringDidChanged:(NSString *)string{
    NSLog(@"%@",string);
}
-(void)searchBarCompeleteButtonClicked:(HGBSearchBar *)searchBar{
    NSLog(@"compelete");
}
@end
