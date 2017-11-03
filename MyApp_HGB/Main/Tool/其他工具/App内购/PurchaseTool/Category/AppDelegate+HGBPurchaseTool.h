//
//  AppDelegate+HGBPurchaseTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/17.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (HGBPurchaseTool)
/**
 内购初始化

 @param launchOptions 加载参数
 */
-(void)init_Purchase_ServerWithOptions:(NSDictionary *)launchOptions;
@end
