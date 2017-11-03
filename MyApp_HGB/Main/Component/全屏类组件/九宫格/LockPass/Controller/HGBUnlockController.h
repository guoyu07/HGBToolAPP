//
//  HGBUnlockController.h
//  测试
//
//  Created by huangguangbao on 2017/6/28.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBLockPassStyle.h"


/**
 解锁结果
 */
typedef enum HGBUnlockStatus
{
    HGBUnlockStatusSucess,//成功
    HGBUnlockStatusFail,//失败
    HGBUnlockStatusCancel//取消

}HGBUnlockStatus;

@class HGBUnlockController;
@protocol HGBUnlockControllerDelegate <NSObject>

/**
 结束手势验证代理事件

 @param result 返回状态 
 */
- (void)unlock:(HGBUnlockController *)unlock didFinishedWithResult:(HGBUnlockStatus)result;

@end
@interface HGBUnlockController : UIViewController
/**
 选择次数
 */
@property(assign,nonatomic)NSInteger setCount;
/**
 密码
 */
@property(strong,nonatomic)NSString *password;
/**
 样式
 */
@property(strong,nonatomic)HGBLockPassStyle *style;

@property(assign,nonatomic)id<HGBUnlockControllerDelegate>delegate;
@end
