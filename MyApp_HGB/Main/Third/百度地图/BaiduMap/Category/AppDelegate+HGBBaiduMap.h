//
//  AppDelegate+HGBBaiduMap.h
//  测试
//
//  Created by huangguangbao on 2017/10/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (HGBBaiduMap)
/**
 百度地图初始化

 @param baiduMapAppKey AppKey
 @param launchOptions 加载参数
 */
-(void)init_BaiduMap_ServerWithBaiduMapAppKey:(NSString *)baiduMapAppKey andWithLaunchOptions:(NSDictionary *)launchOptions;
@end
