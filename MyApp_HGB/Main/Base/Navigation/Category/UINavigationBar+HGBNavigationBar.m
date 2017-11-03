//
//  UINavigationBar+HGBNavigationBar.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/31.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "UINavigationBar+HGBNavigationBar.h"

@implementation UINavigationBar (HGBNavigationBar)
/**
 改变导航栏透明度

 @param scrollView scrollView
 */
- (void)didChangeNavigationBarAlpha:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= 64){
        CGFloat alpha = (64.f - scrollView.contentOffset.y);
        self.alpha = (alpha / 100.f);
    }
}
@end
