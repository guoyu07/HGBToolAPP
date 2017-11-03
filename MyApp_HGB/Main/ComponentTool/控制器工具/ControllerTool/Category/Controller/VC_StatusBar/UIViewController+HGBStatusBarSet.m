
//
//  UIViewController+HGBStatusBarSet.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/27.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "UIViewController+HGBStatusBarSet.h"

@implementation UIViewController (HGBStatusBarSet)
#pragma mark 状态栏
/**
 设置状态栏是否隐藏-info.plist UIViewControllerBasedStatusBarAppearance NO

 @param isHidden 是否隐藏
 */
-(void)setStatusBarIsHidden:(BOOL)isHidden{
    [[UIApplication sharedApplication]setStatusBarHidden:isHidden withAnimation:NO];


    [self prefersStatusBarHidden];
    [self setNeedsStatusBarAppearanceUpdate];
}

/**
 设置状态栏样式-info.plist UIViewControllerBasedStatusBarAppearance NO

 @param statusBarStyle 状态栏样式
 */
-(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{

    [[UIApplication sharedApplication]setStatusBarStyle:statusBarStyle];


    [self setNeedsStatusBarAppearanceUpdate];


}
@end
