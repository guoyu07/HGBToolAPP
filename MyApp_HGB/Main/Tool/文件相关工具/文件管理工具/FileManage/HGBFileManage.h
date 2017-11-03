//
//  HGBFileManage.h
//  测试
//
//  Created by huangguangbao on 2017/8/24.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HGBFileManageController.h"


@interface HGBFileManage : NSObject
/**
 弹出文件管理控制器

 @param parent 父控制器
 */
+(void)popFileManageControllerInParent:(UIViewController *)parent;
@end
