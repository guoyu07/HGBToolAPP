//
//  HTabBarViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HTabBarViewController.h"
#import "H1ViewController.h"
#import "H2ViewController.h"
#import "H3ViewController.h"
#import "HGBTabBar.h"

@interface HTabBarViewController ()<HGBTabBarDelegate>
/**
 *  自定义的tabbar
 */
@property (nonatomic, strong) HGBTabBar *customTabBar;
@end

@implementation HTabBarViewController

#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化tabbar
    [self setupTabbar];
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
    titleLab.text=@"tabBar-Controller";
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
    [self addSubControler:[[H1ViewController alloc]init] withTitle:@"主页" andWithImage:[UIImage imageNamed:@"icon_home_normal"] andWithSelectorImage:[UIImage imageNamed:@"icon_home_select"] andWithNavFlag:YES];
    [self addSubControler:[[H2ViewController alloc]init] withTitle:@"组件" andWithImage:[UIImage imageNamed:@"icon_component_normal"] andWithSelectorImage:[UIImage imageNamed:@"icon_component_select"] andWithNavFlag:YES];
    [self addSubControler:[[H3ViewController alloc]init] withTitle:@"工具" andWithImage:[UIImage imageNamed:@"icon_tool_normal"] andWithSelectorImage:[UIImage imageNamed:@"icon_tool_select"] andWithNavFlag:YES];


}
/**
 *  初始化tabbar
 */
- (void)setupTabbar
{

    HGBTabBar *customTabBar = [[HGBTabBar alloc]init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview: customTabBar];
    self.customTabBar = customTabBar;
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}
#pragma mark func
/**
 添加子控制器

 @param controller 控制器
 @param title 标题
 @param image 图片
 @param selectImage 已选中图片
 @param navFlag 是否有导航栏
 */
-(void)addSubControler:(UIViewController *)controller withTitle:(NSString *)title andWithImage:(UIImage *)image andWithSelectorImage:(UIImage *)selectImage andWithNavFlag:(BOOL)navFlag{
    controller.navigationController.tabBarItem.badgeValue=@"1212";
    UINavigationController *nav;
    if(navFlag){
        nav=[[UINavigationController alloc]initWithRootViewController:controller];
        nav.tabBarItem.image=image;
        nav.tabBarItem.selectedImage=selectImage;
        nav.tabBarItem.title=title;
        [self addChildViewController:nav];
    }else{
        controller.tabBarItem.image=image;
        controller.tabBarItem.selectedImage=selectImage;
        controller.tabBarItem.title=title;
        [self addChildViewController:controller];
    }
    [self.customTabBar addTabBarButtonWithItem:controller.tabBarItem];

}
/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(HGBTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to
{
    if (self.selectedIndex == to && to == 0 ) {//双击刷新制定页面的列表

    }
    self.selectedIndex = to;
}
@end
