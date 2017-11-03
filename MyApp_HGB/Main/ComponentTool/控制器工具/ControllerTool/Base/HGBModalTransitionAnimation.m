//
//  HGBModalTransitionAnimation.m
//  测试
//
//  Created by huangguangbao on 2017/6/29.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBModalTransitionAnimation.h"


#define kWith [[UIScreen mainScreen]bounds].size.width
@implementation HGBModalTransitionAnimation
//动画持续时间，单位是秒
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
    
}
//动画效果
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * toView = toViewController.view;
    UIView * fromView = fromViewController.view;
    if (self.animationType == HGBAnimationTypePresent) {
        //得到toVC完全呈现后的frame
        CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
        //First放下面
        [transitionContext.containerView addSubview:fromView];
        //Third放上面
        [transitionContext.containerView addSubview:toView];
        toView.frame = CGRectOffset(finalFrame, [UIScreen mainScreen].bounds.size.width, 0);
        //进行动画
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            toView.frame = finalFrame;
        } completion:^(BOOL finished) {
            //添加视图
            [[transitionContext containerView] addSubview:toView];
            //结束Transition
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        //得到toVC完全呈现后的frame
        CGRect finalFrame = [[UIScreen mainScreen] bounds];
        finalFrame.origin.x = kWith;
        //First 放下面
        [transitionContext.containerView addSubview:toView];
        //Third 放上面
        [transitionContext.containerView addSubview:fromView];
        fromView.frame = [[UIScreen mainScreen] bounds];
        //进行动画
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            fromView.frame = finalFrame;
        } completion:^(BOOL finished) {
            //添加视图
            [[transitionContext containerView] addSubview:toView];
            //结束Transition
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}
@end
