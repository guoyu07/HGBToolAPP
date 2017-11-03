//
//  UIViewController+HGBCurrentController.h
//  测试
//
//  Created by huangguangbao on 2017/6/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HGBCurrentController)
/**
 获取当前控制器
 
 @return 当前控制器
 */
+ (UIViewController *)currentViewController;
@end
