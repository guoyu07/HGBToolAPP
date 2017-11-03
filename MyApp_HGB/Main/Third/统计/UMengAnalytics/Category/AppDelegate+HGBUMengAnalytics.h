//
//  AppDelegate+HGBUMengAnalytics.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (HGBUMengAnalytics)
/**
 友盟统计初始化

 @param UMengAnalyticsAppKey AppKey
 @param launchOptions 加载参数
 */
-(void)init_UMengAnalytics_ServerWithUMengAnalyticsAppKey:(NSString *)UMengAnalyticsAppKey andWithLaunchOptions:(NSDictionary *)launchOptions;
@end
