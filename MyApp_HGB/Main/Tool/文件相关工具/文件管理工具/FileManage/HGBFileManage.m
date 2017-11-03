//
//  HGBFileManage.m
//  测试
//
//  Created by huangguangbao on 2017/8/24.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBFileManage.h"

@implementation HGBFileManage
/**
 弹出文件管理控制器

 @param parent 父控制器
 */
+(void)popFileManageControllerInParent:(UIViewController *)parent{
    HGBFileManageController *fileVC=[[HGBFileManageController alloc]init];
    fileVC.withoutFileSwitch=NO;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:fileVC];
    [parent presentViewController:nav animated:YES completion:nil];
}
@end
