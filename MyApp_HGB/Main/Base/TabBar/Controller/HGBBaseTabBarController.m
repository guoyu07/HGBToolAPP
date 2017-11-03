//
//  HGBBaseTabBarController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBaseTabBarController.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height

//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0




@interface HGBBaseTabBarController ()
/**
 标题
 */
@property(strong,nonatomic)NSArray<NSString *> *tabBarTitles;
/**
 图片
 */
@property(strong,nonatomic)NSArray<UIImage *> *tabBarImages;
/**
 控制器
 */
@property(strong,nonatomic)NSArray<UIViewController *> *tabBarControllers;
@end

@implementation HGBBaseTabBarController
#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark 导航栏
/**
 导航栏

 @param title 标题
 */
-(void)createNavigationItemWithTitle:(NSString *)title
{
    //导航栏
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1];
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=@"我的应用";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;

}
#pragma mark  基础
/**
 UI-view
 */
-(void)viewSetUp{

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

}
/**
 设置tabBar选中项

 @param index 标记
 */
-(void)setTabBarSelectIndex:(NSInteger )index{
    if(index>=self.viewControllers.count){
     index=self.viewControllers.count-1;
    }
    self.selectedIndex=index;
}
#pragma mark set
-(void)setTabBarTitles:(NSArray<NSString *> *)tabBarTitles{
    _tabBarTitles=tabBarTitles;
    [self viewSetUp];
}
-(void)setTabBarImages:(NSArray<UIImage *> *)tabBarImages{
    _tabBarImages=tabBarImages;
    [self viewSetUp];
}
-(void)setTabBarControllers:(NSArray<UIViewController *> *)tabBarControllers{
    _tabBarControllers=tabBarControllers;
    [self viewSetUp];
}
@end
