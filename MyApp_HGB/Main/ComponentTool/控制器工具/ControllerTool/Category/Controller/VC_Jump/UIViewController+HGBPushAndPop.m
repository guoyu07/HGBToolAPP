//
//  UIViewController+HGBPushAndPop.m
//  测试
//
//  Created by huangguangbao on 2017/6/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "UIViewController+HGBPushAndPop.h"

@implementation UIViewController (HGBPushAndPop)
#pragma mark Push
/**
 视图推出
 
 @param controller 控制器
 */
-(void)pushController:(UIViewController *)controller{
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark Pop

/**
 返回到上一层控制器
 */
-(void)popToParentViewController{
    UIViewController *vc = self;
    [vc.navigationController popViewControllerAnimated:YES];
}
/**
 返回到根层视图控制器
 */
-(void)popToRootViewController{
    UIViewController *vc = self;
    [vc.navigationController popToRootViewControllerAnimated:YES];
}

/**
 返回到指定层控制器
 
 @param controllerName 控制器名称
 */
-(void)popToControllerWithControllerName:(NSString *)controllerName{
    UIViewController *vc = self;
    if(controllerName==nil||controllerName.length==0){
        return;
    }
    if(![vc.parentViewController isKindOfClass:[UINavigationController class]]){
        return;
    }
    NSArray *controllers=self.navigationController.viewControllers;
    NSInteger n=0;
    for(UIViewController *v in controllers){
       
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
-(void)popToControllerWithPopCount:(NSInteger)count{
    UIViewController *vc = self;
    if(![vc.parentViewController isKindOfClass:[UINavigationController class]]){
        return;
    }
    NSArray *controllers=self.navigationController.viewControllers;
    for(long i=count;i>0;i--){
        UIViewController *vc=controllers[i];
        [vc.navigationController popViewControllerAnimated:YES];
    }
}
@end
