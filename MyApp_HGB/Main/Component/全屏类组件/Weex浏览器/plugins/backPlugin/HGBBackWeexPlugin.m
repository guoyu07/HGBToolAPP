//
//  HGBBackWeexPlugin.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBackWeexPlugin.h"

@interface HGBBackWeexPlugin()

/*
 

 成功返回
 */
@property (nonatomic,copy)WXModuleCallback sucessCallback;
/*
 失败返回
 */
@property (nonatomic,copy)WXModuleCallback failCallback;

@end
@implementation HGBBackWeexPlugin

WX_EXPORT_METHOD(@selector(getBack:::))

/**
 返回

 @param arguments html传参数
 @param sucessCallback 回调
 @param failCallback 失败回调
 */
- (void)getBack:(NSDictionary *)arguments :(WXModuleCallback)sucessCallback :(WXModuleCallback)failCallback{
    UIViewController *vc=[self currentViewController];
    [vc dismissViewControllerAnimated:YES completion:nil];
    sucessCallback(@"sucess");
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
@end
