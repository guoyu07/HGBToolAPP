//
//  UINavigationBar+HGBNavigationBar.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/31.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (HGBNavigationBar)
/**
 改变导航栏透明度

 @param scrollView scrollView
 */
- (void)didChangeNavigationBarAlpha:(UIScrollView *)scrollView;
@end
