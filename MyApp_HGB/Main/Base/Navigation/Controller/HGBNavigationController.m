//
//  HGBNavigationController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBNavigationController.h"

@interface HGBNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation HGBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addScreenEdgeGesture];//侧滑
}
#pragma mark 添加侧滑手势
-(void)addScreenEdgeGesture{
    self.navigationController.navigationBar.hidden=NO;
    UIScreenEdgePanGestureRecognizer *pan=[[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(customControllerEdgePopHandle:)];
    pan.delegate=self;
    pan.edges=UIRectEdgeLeft;
    [self.view addGestureRecognizer:pan];
}
#pragma mark 侧滑
- (void)customControllerEdgePopHandle:(UIPanGestureRecognizer *)recognizer
{
    UIViewController *controller=self.topViewController;
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        UIViewController *rootVC=controller.navigationController.childViewControllers[0];
        if(controller==rootVC){
            [controller dismissViewControllerAnimated:YES completion:nil];
        }else{

            [controller.navigationController popViewControllerAnimated:YES];


        }
    }
}
#pragma mark 手势delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL result = NO;
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        result = YES;
    }

    return result;
}
#pragma mark 屏幕方向
- (BOOL)shouldAutorotate
{
    return [self.viewControllers.lastObject shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

@end
