//
//  AppDelegate+HGBUMShare.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/11/2.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (HGBUMShare)
/**
 友盟分享初始化

 @param launchOptions 加载参数
 */
-(void)init_UMShare_ServerWithLaunchOptions:(NSDictionary *)launchOptions;
@end
