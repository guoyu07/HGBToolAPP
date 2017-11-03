//
//  HGBNavigationController.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/26.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGBNavigationController : UINavigationController
@property(assign,nonatomic)BOOL isDismiss;
/**
 导航栏标题
 */
@property(strong,nonatomic)NSString *navTitle;
/**
 左按钮标题
 */
@property(strong,nonatomic)NSString *navLeftButtonTitle;
@end
