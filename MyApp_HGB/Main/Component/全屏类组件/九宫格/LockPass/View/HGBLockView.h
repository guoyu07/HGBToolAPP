//
//  HGBLockView.h
//  VirtualCard
//
//  Created by huangguangbao on 2017/6/23.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBLockPassStyle.h"
@class HGBLockView;
@protocol HGBLockViewDelegate <NSObject>

/** 结束手势解锁代理事件 */
@optional
- (void)lockView:(HGBLockView *) lockView didFinishedWithPath:(NSString *) path;

@end
@interface HGBLockView : UIButton
@property(assign,nonatomic)BOOL autoRemoveSelected;
/**
 样式
 */
@property(strong,nonatomic)HGBLockPassStyle *style;

/** 代理 */
@property(nonatomic, strong)  id<HGBLockViewDelegate> delegate;
-(void)removeSelector;
@end
