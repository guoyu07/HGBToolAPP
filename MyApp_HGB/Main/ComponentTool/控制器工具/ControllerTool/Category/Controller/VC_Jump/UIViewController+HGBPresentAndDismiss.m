//
//  UIViewController+HGBPresentAndDismiss.m
//  测试
//
//  Created by huangguangbao on 2017/6/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "UIViewController+HGBPresentAndDismiss.h"
#import "UIViewController+HGBModalTransition.h"

@implementation UIViewController (HGBPresentAndDismiss)
#pragma mark Present
/**
 模态视图推出-有导航栏
 
 @param controller 控制器
 */
-(void)presentControllerWithNavgation:(UIViewController *)controller{
     UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:controller];
    nav.transitioningDelegate=self;
    [self presentViewController:nav animated:YES completion:nil];
}


/**
 模态视图推出-无导航栏
 
 @param controller 控制器
 */
-(void)presentController:(UIViewController *)controller{
    controller.transitioningDelegate=self;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark Dismiss
/**
 返回到上一级控制器
 */
-(void)dismissToParentViewController{
    UIViewController *vc = self;
    [vc dismissViewControllerAnimated:YES completion:nil];
}
/**
 返回到根控制器
 */
-(void)dismissToRootViewController
{
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}
/**
 返回到指定控制器
 
 @param controllerName 控制器名称
 */
-(void)dismissToControllerWithControllerName:(NSString *)controllerName{
    UIViewController *vc = self;
    UIViewController *vcc=self;
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
-(void)dismissToControllerWithDismissCount:(NSInteger)count{
    int i=0;
    UIViewController *vc = self;
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
@end
