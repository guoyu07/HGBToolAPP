//
//  AppDelegate+HGBWeex.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (HGBWeex)
/**
 weex初始化

 @param launchOptions 加载参数
 */
-(void)init_Weex_ServerWithOptions:(NSDictionary *)launchOptions;
@end
