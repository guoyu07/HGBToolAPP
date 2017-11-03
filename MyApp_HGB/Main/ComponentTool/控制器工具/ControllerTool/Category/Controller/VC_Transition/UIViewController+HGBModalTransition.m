//
//  UIViewController+HGBModalTransition.m
//  测试
//
//  Created by huangguangbao on 2017/6/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "UIViewController+HGBModalTransition.h"
#import "HGBModalTransitionAnimation.h"


@interface UIViewController ()

@end

@implementation UIViewController (HGBModalTransition)
#pragma mark 模态动画代理
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    HGBModalTransitionAnimation *animation=[[HGBModalTransitionAnimation alloc]init];

    animation.animationType = HGBAnimationTypePresent;
    return animation;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    HGBModalTransitionAnimation *animation=[[HGBModalTransitionAnimation alloc]init];
    animation.animationType = HGBAnimationTypeDismiss;
    return animation;
    
}
@end
