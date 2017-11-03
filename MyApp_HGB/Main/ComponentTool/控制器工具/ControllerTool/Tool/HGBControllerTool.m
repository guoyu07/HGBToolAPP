//
//  HGBControllerTool.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/16.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBControllerTool.h"
#import "HGBModalTransitionAnimation.h"



#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号

//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0


@interface HGBControllerTool ()
/**
 导航栏背景颜色
 */
@property(nonatomic,strong)UIColor *navBackColor;
/**
 导航栏左按钮颜色
 */
@property(nonatomic,strong)UIColor *navLeftColor;
/**
 导航栏右按钮颜色
 */
@property(nonatomic,strong)UIColor *navRightColor;
@end

@implementation HGBControllerTool
static HGBControllerTool *instance=nil;
#pragma mark init
+ (instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBControllerTool alloc]init];
    }
    return instance;
}
#pragma mark 导航栏整体
/**
 设置当前导航栏显示隐藏

 @param isHidden 是否隐藏
 */
+(void)setNavgationBarIsHidden:(BOOL)isHidden{
    UIViewController *controller=[HGBControllerTool currentViewController];
    controller.navigationController.navigationBar.hidden=isHidden;
}

/**
 修改当前导航栏的颜色

 @param color 颜色
 */
+(void)changeNavgationBarColor:(UIColor *)color{
    if(color==nil){
        return;
    }
    UIViewController *controller=[HGBControllerTool currentViewController];

    controller.navigationController.navigationBar.barTintColor=color;
}
/**
 修改所有导航栏的颜色

 @param color 颜色
 */
+(void)changeAllNavgationBarColor:(UIColor *)color{
    if(color==nil){
        return;
    }
    UIViewController *controller=[HGBControllerTool currentViewController];
    [[UINavigationBar appearance]setBarTintColor:color];
    controller.navigationController.navigationBar.barTintColor=color;

}
#pragma mark 状态栏
/**
 设置状态栏是否隐藏-info.plist UIViewControllerBasedStatusBarAppearance NO

 @param isHidden 是否隐藏
 */
+(void)setStatusBarIsHidden:(BOOL)isHidden{
    [[UIApplication sharedApplication]setStatusBarHidden:isHidden withAnimation:NO];

    UIViewController *controller=[HGBControllerTool currentViewController];

    [controller prefersStatusBarHidden];
    [controller setNeedsStatusBarAppearanceUpdate];
}

/**
 设置状态栏样式-info.plist UIViewControllerBasedStatusBarAppearance NO

 @param statusBarStyle 状态栏样式
 */
+(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{

    [[UIApplication sharedApplication]setStatusBarStyle:statusBarStyle];
    UIViewController *controller=[HGBControllerTool currentViewController];

    [controller setNeedsStatusBarAppearanceUpdate];


}
#pragma mark 导航栏创建
/**
 快捷创建导航栏-仅有标题和左按钮

 @param title 标题
 @param target 目标
 @param action 左按钮事件
 @param controller 控制器
 */
+(void)createNavigationItemWithTitle:(NSString *)title andWithTarget:(id)target andWithLeftAction:(SEL)action inController:(UIViewController *)controller
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
+(void)createNavigationItem:(HGBNavigationItem )type andWithTitles:(NSArray <NSString *>*)titles andWithTarget:(id)target andWithAction:(SEL)action inController:(UIViewController *)controller{
    if(type==HGBNavigationItemTitle){
        [HGBControllerTool createNavigationItemTitleWithTitles:titles andWithTarget:target andWithAction:action inController:controller];
    }else if(type==HGBNavigationItemLeft){
        [HGBControllerTool createNavigationItemLeftWithTitles:titles andWithTarget:target andWithAction:action inController:controller];
    }else{
         [HGBControllerTool createNavigationItemRightWithTitles:titles andWithTarget:target andWithAction:action inController:controller];
    }
}
/**
 创建导航栏-标题按钮多个采用segment

 @param titles 标题集合 R L T
 @param target 目标
 @param action 事件
 @param controller 控制器
 */
+(void)createNavigationItemWithTitles:(NSDictionary *)titles andWithTarget:(id)target andWithAction:(SEL )action inController:(UIViewController *)controller{
    NSArray *leftArray=[titles objectForKey:@"L"];
    NSArray *rightArray=[titles objectForKey:@"R"];
    NSArray *titleArray=[titles objectForKey:@"T"];
    if(titleArray&&[titleArray isKindOfClass:[NSArray class]]){
        [HGBControllerTool createNavigationItemTitleWithTitles:titleArray andWithTarget:target andWithAction:action inController:controller];
    }
    if(titleArray&&[titleArray isKindOfClass:[NSArray class]]){
        [HGBControllerTool createNavigationItemLeftWithTitles:leftArray andWithTarget:target andWithAction:action inController:controller];
    }
    if(rightArray&&[rightArray isKindOfClass:[NSArray class]]){
        [HGBControllerTool createNavigationItemRightWithTitles:rightArray andWithTarget:target andWithAction:action inController:controller];
    }
}
#pragma mark navigationItem
/**
 创建导航栏标题-标题按钮多个采用segment

 @param titles 标题集合
 @param target 目标
 @param action 事件
 @param controller 控制器
 */
+(void)createNavigationItemTitleWithTitles:(NSArray <NSString *>*)titles andWithTarget:(id)target andWithAction:(SEL)action inController:(UIViewController *)controller{
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
            [seg addTarget:self action:action forControlEvents:(UIControlEventValueChanged)];
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
+(void)createNavigationItemLeftWithTitles:(NSArray <NSString *>*)titles andWithTarget:(id)target andWithAction:(SEL)action inController:(UIViewController *)controller{
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
+(void)createNavigationItemRightWithTitles:(NSArray <NSString *>*)titles andWithTarget:(id)target andWithAction:(SEL)action inController:(UIViewController *)controller{
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
    return [HGBControllerTool findBestViewController:viewController];
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
        return [HGBControllerTool findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBControllerTool findBestViewController:svc.viewControllers.lastObject];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBControllerTool findBestViewController:svc.topViewController];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBControllerTool findBestViewController:svc.selectedViewController];
        }else{
            return vc;
        }
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}
#pragma mark Present- Dismiss
/**
 模态视图推出-有导航栏

 @param controller 控制器
 */
+(void)presentControllerWithNavgation:(UIViewController *)controller{
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:controller];
    [[HGBControllerTool currentViewController] presentViewController:nav animated:YES completion:nil];
}


/**
 模态视图推出-无导航栏

 @param controller 控制器
 */
+(void)presentController:(UIViewController *)controller{

    [[HGBControllerTool currentViewController] presentViewController:controller animated:YES completion:nil];
}

/**
 返回到上一级控制器
 */
+(void)dismissToParentViewController{
    UIViewController *vc = [HGBControllerTool currentViewController];
    [vc dismissViewControllerAnimated:YES completion:nil];
}
/**
 返回到根控制器
 */
+(void)dismissToRootViewController
{
    UIViewController *vc = [HGBControllerTool currentViewController];
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}
/**
 返回到指定控制器

 @param controllerName 控制器名称
 */
+(void)dismissToControllerWithControllerName:(NSString *)controllerName{
    UIViewController *vc = [HGBControllerTool currentViewController];
    UIViewController *vcc=[HGBControllerTool currentViewController];
    while (vc.presentingViewController) {
        NSArray *controllers;
        if([vc.presentingViewController isKindOfClass:[UINavigationController class]]){
            UINavigationController *nav=(UINavigationController *)vc.presentingViewController;
            controllers=nav.childViewControllers;

        }
        BOOL breakFlag=NO;
        for(UIViewController *c in controllers){
            NSString *cName=[NSStringFromClass([c class]) copy];
            if([controllerName isEqualToString:cName]){
                breakFlag=YES;
                [vcc dismissViewControllerAnimated:YES completion:nil];
                break;
            }
            vcc = c;

        }
        if(breakFlag==YES){
            vc=vcc;
            break;
        }
        if([controllerName isEqualToString:NSStringFromClass([vc.presentingViewController class])]){
            vc = vc.presentingViewController;
            [vc dismissViewControllerAnimated:YES completion:nil];

            break;
        }
        vc = vc.presentingViewController;

    }
}
/**
 返回指定次数

 @param count 返回层数
 */
+(void)dismissToControllerWithDismissCount:(NSInteger)count{
    int i=0;
    UIViewController *vc = [HGBControllerTool currentViewController];
    if(count==0){
        return;
    }else if(count==1){
        [vc dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    while (vc.presentingViewController) {
        if(i>=count){
            break;
        }
        vc = vc.presentingViewController;
        i++;
    }

    [vc dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Push-Pop
/**
 视图推出

 @param controller 控制器
 */
+(void)pushController:(UIViewController *)controller{
    [[HGBControllerTool currentViewController].navigationController pushViewController:controller animated:YES];
}

/**
 返回到上一层控制器
 */
+(void)popToParentViewController{
    UIViewController *vc = [HGBControllerTool currentViewController];
    [vc.navigationController popViewControllerAnimated:YES];
}
/**
 返回到根层视图控制器
 */
+(void)popToRootViewController{
    UIViewController *vc = [HGBControllerTool currentViewController];
    [vc.navigationController popToRootViewControllerAnimated:YES];
}

/**
 返回到指定层控制器

 @param controllerName 控制器名称
 */
+(void)popToControllerWithControllerName:(NSString *)controllerName{
    UIViewController *vc = [HGBControllerTool currentViewController];
    if(controllerName==nil||controllerName.length==0){
        return;
    }
    if(![vc.parentViewController isKindOfClass:[UINavigationController class]]){
        return;
    }
    NSArray *controllers=[HGBControllerTool currentViewController].navigationController.viewControllers;
    NSInteger n=0;
    for(UIViewController *v in controllers){
        NSLog(@"%@",NSStringFromClass([v class]));
        if([NSStringFromClass([v class]) isEqualToString:controllerName]){
            n=[controllers indexOfObject:v];
            break;
        }
    }

    for(long i=controllers.count-1;i>n;i--){
        UIViewController *vc=controllers[i];
        [vc.navigationController popViewControllerAnimated:YES];
    }

}

/**
 返回指定次数

 @param count 返回层数
 */
+(void)popToControllerWithPopCount:(NSInteger)count{
    UIViewController *vc = [HGBControllerTool currentViewController];
    if(![vc.parentViewController isKindOfClass:[UINavigationController class]]){
        return;
    }
    NSArray *controllers=[HGBControllerTool currentViewController].navigationController.viewControllers;
    for(long i=count;i>0;i--){
        UIViewController *vc=controllers[i];
        [vc.navigationController popViewControllerAnimated:YES];
    }
}
@end
