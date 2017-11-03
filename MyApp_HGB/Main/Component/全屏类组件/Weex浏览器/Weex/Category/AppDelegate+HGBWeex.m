//
//  AppDelegate+HGBWeex.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate+HGBWeex.h"
#import "WeexSDKManager.h"
@implementation AppDelegate (HGBWeex)
/**
 weex初始化

 @param launchOptions 加载参数
 */
-(void)init_Weex_ServerWithOptions:(NSDictionary *)launchOptions{
    [WeexSDKManager baseSetup];
}
@end
