//
//  HGBSetLockController.h
//  测试
//
//  Created by huangguangbao on 2017/6/28.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBLockPassStyle.h"

@class HGBSetLockController;

@protocol HGBSetLockControllerDelegate <NSObject>

/**
 结束手势解锁代理事件

 @param path 路径 为空时取消
 */
- (void)lockSet:(HGBSetLockController *)lockSet didFinishedWithPath:(NSString *)path;
@optional

/**
 取消扫描
 */
-(void)lockSetDidCanceled:(HGBSetLockController *)lockSet;
@end

@interface HGBSetLockController : UIViewController
/**
 样式
 */
@property(strong,nonatomic)HGBLockPassStyle *style;
@property(strong,nonatomic)id<HGBSetLockControllerDelegate>delegate;
@end
