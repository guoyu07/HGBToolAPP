//
//  AppDelegate+HGBSEDataBase.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/20.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (HGBSEDataBase)
/**
 数据库初始化

 @param launchOptions 加载参数
 */
-(void)init_SEDataBase_ServerWithOptions:(NSDictionary *)launchOptions;
@end
