
//
//  AppDelegate+HGBBaiduMap.m
//  测试
//
//  Created by huangguangbao on 2017/10/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate+HGBBaiduMap.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@implementation AppDelegate (HGBBaiduMap)
#pragma mark 百度地图
/**
 百度地图初始化

 @param baiduMapAppKey AppKey
 @param launchOptions 加载参数
 */
-(void)init_BaiduMap_ServerWithBaiduMapAppKey:(NSString *)baiduMapAppKey andWithLaunchOptions:(NSDictionary *)launchOptions{
    if(baiduMapAppKey==nil||baiduMapAppKey.length==0){
        baiduMapAppKey=@"fEH1pg9fLuIHZ6ubiyAhEHfNaKkrwHei";
    }
    BMKMapManager *mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [mapManager start:baiduMapAppKey  generalDelegate:nil];
    if (!ret) {
        //        NSLog(@"manager start failed!");
    }

}
@end
