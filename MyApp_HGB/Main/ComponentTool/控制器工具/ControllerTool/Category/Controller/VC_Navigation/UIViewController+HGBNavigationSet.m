//
//  UIViewController+HGBNavigationSet.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/27.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "UIViewController+HGBNavigationSet.h"


#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0

@implementation UIViewController (HGBNavigationSet)
#pragma mark 导航栏整体
/**
 设置当前导航栏显示隐藏

 @param isHidden 是否隐藏
 */
-(void)setNavgationBarIsHidden:(BOOL)isHidden{
    self.navigationController.navigationBar.hidden=isHidden;
}

/**
 修改当前导航栏的颜色

 @param color 颜色
 */
-(void)changeNavgationBarColor:(UIColor *)color{
    if(color==nil){
        return;
    }

    self.navigationController.navigationBar.barTintColor=color;
}
/**
 修改所有导航栏的颜色

 @param color 颜色
 */
-(void)changeAllNavgationBarColor:(UIColor *)color{
    if(color==nil){
        return;
    }
    [[UINavigationBar appearance]setBarTintColor:color];
    self.navigationController.navigationBar.barTintColor=color;

}

#pragma mark 导航栏创建
/**
 快捷创建导航栏-仅有标题和左按钮

 @param title 标题
 @param target 目标
 @param action 左按钮事件
 @param controller 控制器
 */
-(void)createNavigationItemWithTitle:(NSString *)title andWithTarget:(id)target andWithLeftAction:(SEL)action inController:(UIViewController *)controller
{
    //导航栏
    controller.navigationController.navigationBar.barTintColor=[UIColor redColor];
    [[UINavigationBar appearance]setBarTintColor:[UIColor redColor]];
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=title;
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    controller.navigationItem.titleView=titleLab;

    //左键
    if(target&&action){
        controller.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:target action:action];
        [controller.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        [controller.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    }

}
/**
 创建导航栏-标题按钮多个采用segment

 @param type  导航栏类型
 @param titles 标题集合
 @param target 目标
 @param action 事件
 @param controller 控制器
 */
-(void)createNavigationItem:(HGBNavItem )type andWithTitles:(NSArray <NSString *>*)titles andWithTarget:(id)target andWithAction:(SEL)action inController:(UIViewController *)controller{
    if(type==HGBNavItemTitle){
        [self createNavigationItemTitleWithTitles:titles andWithTarget:target andWithAction:action inController:controller];
    }else if(type==HGBNavItemLeft){
        [self createNavigationItemLeftWithTitles:titles andWithTarget:target andWithAction:action inController:controller];
    }else{
        [self createNavigationItemRightWithTitles:titles andWithTarget:target andWithAction:action inController:controller];
    }
}
/**
 创建导航栏-标题按钮多个采用segment

 @param titles 标题集合 R L T
 @param target 目标
 @param action 事件
 @param controller 控制器
 */
-(void)createNavigationItemWithTitles:(NSDictionary *)titles andWithTarget:(id)target andWithAction:(SEL )action inController:(UIViewController *)controller{
    NSArray *leftArray=[titles objectForKey:@"L"];
    NSArray *rightArray=[titles objectForKey:@"R"];
    NSArray *titleArray=[titles objectForKey:@"T"];
    if(titleArray&&[titleArray isKindOfClass:[NSArray class]]){
        [self createNavigationItemTitleWithTitles:titleArray andWithTarget:target andWithAction:action inController:controller];
    }
    if(titleArray&&[titleArray isKindOfClass:[NSArray class]]){
        [self createNavigationItemLeftWithTitles:leftArray andWithTarget:target andWithAction:action inController:controller];
    }
    if(rightArray&&[rightArray isKindOfClass:[NSArray class]]){
        [self createNavigationItemRightWithTitles:rightArray andWithTarget:target andWithAction:action inController:controller];
    }
}
#pragma mark navitem
/**
 创建导航栏标题-标题按钮多个采用segment

 @param titles 标题集合
 @param target 目标
 @param action 事件
 @param controller 控制器
 */
-(void)createNavigationItemTitleWithTitles:(NSArray <NSString *>*)titles andWithTarget:(id)target andWithAction:(SEL)action inController:(UIViewController *)controller{
    if(titles==nil&&titles.count==0){
        return;
    }
    if(titles.count==1){
        //导航栏
        controller.navigationController.navigationBar.barTintColor=[UIColor redColor];
        [[UINavigationBar appearance]setBarTintColor:[UIColor redColor]];
        //标题
        UIButton *titleButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
        titleButton.frame=CGRectMake(0, 0, 136*wScale, 16);
        titleButton.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        [titleButton setTitle:titles[0] forState:(UIControlStateNormal)];
        [titleButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        titleButton.tag=0;
        if(action&&target){
            [titleButton addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
        }
        controller.navigationItem.titleView=titleButton;
    }else{
        UISegmentedControl *seg=[[UISegmentedControl alloc]initWithFrame:CGRectMake(0, 8.5,50*wScale*titles.count, 27)];
        seg.tintColor = [UIColor whiteColor];
        for(int i=0;i<titles.count;i++){
            NSString *name =titles[i];
            [seg insertSegmentWithTitle:name atIndex:i animated:YES];
        }
        if(action&&target){
            [seg addTarget:target action:action forControlEvents:(UIControlEventValueChanged)];
        }
        seg.selectedSegmentIndex=0;
        controller.navigationItem.titleView=seg;
    }

}
/**
 创建导航栏左按钮

 @param titles 标题集合
 @param target 目标
 @param action 事件
 @param controller 控制器
 */
-(void)createNavigationItemLeftWithTitles:(NSArray <NSString *>*)titles andWithTarget:(id)target andWithAction:(SEL)action inController:(UIViewController *)controller{
    if(titles==nil&&titles.count==0){
        return;
    }
    if(titles.count==1){
        controller.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:titles[0] style:UIBarButtonItemStylePlain target:target action:action];

    }else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 8.5,50*wScale*titles.count, 27)];

        for(int i=0;i<titles.count;i++){
            NSString *name =titles[i];
            UIButton *button=[UIButton buttonWithType:(UIButtonTypeSystem)];
            button.frame=CGRectMake(50*wScale*i, 0, 50*wScale, 27);
            [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [button setTitle:name forState:(UIControlStateNormal)];
            if(action&&target){
                [button addTarget:target action:action forControlEvents:(UIControlEventValueChanged)];
            }
            button.tag=i+200;
            [view addSubview:button];
        }



        controller.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:view];
    }
    [controller.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [controller.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}
/**
 创建导航栏右按钮

 @param titles 标题集合
 @param target 目标
 @param action 事件
 @param controller 控制器
 */
-(void)createNavigationItemRightWithTitles:(NSArray <NSString *>*)titles andWithTarget:(id)target andWithAction:(SEL)action inController:(UIViewController *)controller{
    if(titles==nil&&titles.count==0){
        return;
    }
    if(titles.count==1){
        controller.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:titles[0] style:UIBarButtonItemStylePlain target:target action:action];


    }else{
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 8.5,50*wScale*titles.count, 27)];

        for(int i=0;i<titles.count;i++){
            NSString *name =titles[i];
            UIButton *button=[UIButton buttonWithType:(UIButtonTypeSystem)];
            button.frame=CGRectMake(50*wScale*i, 0, 50*wScale, 27);
            [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [button setTitle:name forState:(UIControlStateNormal)];
            if(action&&target){
                [button addTarget:target action:action forControlEvents:(UIControlEventValueChanged)];
            }
            button.tag=i+300;
            [view addSubview:button];
        }



        controller.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:view];
    }
    [controller.navigationItem.rightBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [controller.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

#pragma mark 获取当前控制器
/**
 获取当前控制器

 @return 当前控制器
 */
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController findBestViewController:viewController];
}
/**
 寻找上层控制器

 @param vc 控制器
 @return 上层控制器
 */
+ (UIViewController *)findBestViewController:(UIViewController *)vc
{
    if (vc.presentedViewController) {
        // Return presented view controller
        return [UIViewController findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0){
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0){
            return [UIViewController findBestViewController:svc.topViewController];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0){
            return [UIViewController findBestViewController:svc.selectedViewController];
        }else{
            return vc;
        }
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}
@end
