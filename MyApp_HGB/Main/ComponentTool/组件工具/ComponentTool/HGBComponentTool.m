//
//  HGBComponentTool.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBComponentTool.h"
#import "UITabBar+HGBTabBar.h"
@interface HGBComponentTool ()
/**
 角标文字颜色
 */
@property(strong,nonatomic)UIColor *badgeTextColor;
/**
 角标颜色
 */
@property(strong,nonatomic)UIColor *badgeColor;
/**
 标记点颜色颜色
 */
@property(strong,nonatomic)UIColor *pointColor;
@end
@implementation HGBComponentTool
static HGBComponentTool *instance=nil;
/**
 单例
 */
+(instancetype)shareInstance{
    if(instance==nil){
        instance=[[HGBComponentTool alloc]init];
    }
    return instance;
}
#pragma mark 组件复制
/**
 复制view
 */
+(UIView *)duplicateComponent:(UIView *)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}
#pragma mark 导航栏
/**
 设置当前导航栏显示隐藏

 @param isHidden 是否隐藏
 */
+(void)setNavgationBarIsHidden:(BOOL)isHidden{
    UIViewController *controller=[HGBComponentTool currentViewController];
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
    UIViewController *controller=[HGBComponentTool currentViewController];

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
    UIViewController *controller=[HGBComponentTool currentViewController];
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

    UIViewController *controller=[HGBComponentTool currentViewController];

    [controller prefersStatusBarHidden];
    [controller setNeedsStatusBarAppearanceUpdate];
}

/**
 设置状态栏样式-info.plist UIViewControllerBasedStatusBarAppearance NO

 @param statusBarStyle 状态栏样式
 */
+(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{

    [[UIApplication sharedApplication]setStatusBarStyle:statusBarStyle];
    UIViewController *controller=[HGBComponentTool currentViewController];

    [controller setNeedsStatusBarAppearanceUpdate];


}
#pragma mark tableBar标记点
/**
 tabBar添加标记点

 @param controller controller
 */
+(void)addPointInController:(UIViewController *)controller{
    [HGBComponentTool shareInstance];
    NSInteger index=0;
    for(UIViewController  *vc in controller.tabBarController.viewControllers){
        UIViewController *baseVC;
        if([vc isKindOfClass:[UINavigationController class]]){
            baseVC=vc.childViewControllers[0];
        }else{
            baseVC=vc;
        }
        if(baseVC==controller){
            break;
        }
        index++;
    }


    [controller.tabBarController.tabBar showBadgeOnItemIndex:index andWithColor:instance.pointColor andWithTabItemsCount:controller.tabBarController.viewControllers.count];
}
/**
 设置tabBar提示点颜色

 @param pointColor 角标颜色
 @param controller controller
 */
+(void)setTabBarPointColor:(UIColor *)pointColor inController:(UIViewController *)controller{
    [HGBComponentTool shareInstance];
    instance.pointColor=pointColor;
}
/**
 tabBar标记点隐藏

 @param controller controller
 */
+(void)hideTabBarPointInController:(UIViewController *)controller{
    [HGBComponentTool shareInstance];

    NSInteger index=0;
    for(UIViewController  *vc in controller.tabBarController.viewControllers){
        UIViewController *baseVC;
        if([vc isKindOfClass:[UINavigationController class]]){
            baseVC=vc.childViewControllers[0];
        }else{
            baseVC=vc;
        }
        if(baseVC==controller){
            break;
        }
        index++;
    }
    [controller.tabBarController.tabBar hideBadgeOnItemIndex:index];

}
#pragma mark 应用角标
/**
 设置应用角标

 @param badge 角标
 */
+(void)setApplicationBadge:(NSInteger )badge{
    [UIApplication sharedApplication].applicationIconBadgeNumber=badge;
}
/**
 应用角标+1
 */
+(void)addApplicationBadge{
    NSInteger badge=[UIApplication sharedApplication].applicationIconBadgeNumber;
    badge++;
    [UIApplication sharedApplication].applicationIconBadgeNumber=badge;
}
/**
 应用角标-1
 */
+(void)reduceApplicationBadge{
    NSInteger badge=[UIApplication sharedApplication].applicationIconBadgeNumber;
    if(badge>0){
        badge--;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber=badge;
}
/**
 应用角标隐藏

 */
+(void)hideApplicationBadge{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}

#pragma mark tableBar角标
/**
 设置tabBar角标

 @param badge 角标
 @param controller controller
 */
+(void)setTabBarBadge:(NSString *)badge inController:(UIViewController *)controller{
    [HGBComponentTool shareInstance];
    UITabBarItem *item = controller.tabBarItem;
    NSInteger index=0;

    for(UIViewController  *vc in controller.tabBarController.viewControllers){
        UIViewController *baseVC;
        if([vc isKindOfClass:[UINavigationController class]]){
            baseVC=vc.childViewControllers[0];
        }else{
            baseVC=vc;
        }
        if(baseVC==controller){
            break;
        }
        index++;
    }
    [item setBadgeValue:badge];

    [controller.tabBarController.tabBar showBadgeOnItemIndex:index andWithText:badge andWithTextColor:instance.badgeTextColor andWithBackColor:instance.badgeColor andWithTabItemsCount:controller.tabBarController.viewControllers.count];

}
/**
 tabBar角标+1

 @param controller controller
 */
+(void)addTabBarBadgeInController:(UIViewController *)controller{
//    UITabBarItem *item = controller.tabBarItem;
    [HGBComponentTool shareInstance];

    NSString *bage=controller.tabBarItem.badgeValue;
    NSInteger bageNum=bage.integerValue;
    bageNum++;
    bage=@(bageNum).stringValue;
    controller.tabBarItem.badgeValue=bage;


    NSInteger index=0;
    for(UIViewController  *vc in controller.tabBarController.viewControllers){
        UIViewController *baseVC;
        if([vc isKindOfClass:[UINavigationController class]]){
            baseVC=vc.childViewControllers[0];
        }else{
            baseVC=vc;
        }
        if(baseVC==controller){
            break;
        }
        index++;
    }
     [controller.tabBarController.tabBar showBadgeOnItemIndex:index andWithText:bage andWithTextColor:instance.badgeTextColor andWithBackColor:instance.badgeColor andWithTabItemsCount:controller.tabBarController.viewControllers.count];

}
/**
 tabBar角标-1

 @param controller controller
 */
+(void)reduceTabBarBadgeInController:(UIViewController *)controller{
//    UITabBarItem *item = controller.tabBarItem;
    [HGBComponentTool shareInstance];

    NSString *bage=controller.tabBarItem.badgeValue;
    NSInteger bageNum=bage.integerValue;

    if(bageNum>0){
        bageNum--;
    }
    bage=@(bageNum).stringValue;
    controller.tabBarItem.badgeValue=bage;



    NSInteger index=0;
    for(UIViewController  *vc in controller.tabBarController.viewControllers){
        UIViewController *baseVC;
        if([vc isKindOfClass:[UINavigationController class]]){
            baseVC=vc.childViewControllers[0];
        }else{
            baseVC=vc;
        }
        if(baseVC==controller){
            break;
        }
        index++;
    }
    if([bage isEqualToString:@"0"]){
        [HGBComponentTool hideTabBarBadgeInController:controller];
        return;
    }
    [controller.tabBarController.tabBar showBadgeOnItemIndex:index andWithText:bage andWithTextColor:instance.badgeTextColor andWithBackColor:instance.badgeColor andWithTabItemsCount:controller.tabBarController.viewControllers.count];
}
/**
 tabBar角标隐藏

 @param controller controller
 */
+(void)hideTabBarBadgeInController:(UIViewController *)controller{
//    UITabBarItem *item = controller.tabBarItem;

    [HGBComponentTool shareInstance];

    NSInteger index=0;
    for(UIViewController  *vc in controller.tabBarController.viewControllers){
        UIViewController *baseVC;
        if([vc isKindOfClass:[UINavigationController class]]){
            baseVC=vc.childViewControllers[0];
        }else{
            baseVC=vc;
        }
        if(baseVC==controller){
            break;
        }
        index++;
    }
    [controller.tabBarController.tabBar hideBadgeOnItemIndex:index];
    controller.tabBarItem.badgeValue=nil;
}
/**
 设置tabBar角标颜色

 @param badgeColor 角标颜色
 @param controller controller
 */
+(void)setTabBarBadgeColor:(UIColor *)badgeColor inController:(UIViewController *)controller{
    [HGBComponentTool shareInstance];
    instance.badgeColor=badgeColor;
}

/**
 设置tabBar角标文字颜色

 @param badgeTextColor 角标文字颜色
 @param controller controller
 */
+(void)setTabBarBadgeTextColor:(UIColor *)badgeTextColor inController:(UIViewController *)controller{
    [HGBComponentTool shareInstance];
    instance.badgeTextColor=badgeTextColor;
}
#pragma mark 获取当前控制器

/**
 获取当前控制器

 @return 当前控制器
 */
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [HGBComponentTool findBestViewController:viewController];
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
        return [HGBComponentTool findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBComponentTool findBestViewController:svc.viewControllers.lastObject];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBComponentTool findBestViewController:svc.topViewController];
        }else{
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0){
            return [HGBComponentTool findBestViewController:svc.selectedViewController];
        }else{
            return vc;
        }
    } else {
        return vc;
    }
}
@end
