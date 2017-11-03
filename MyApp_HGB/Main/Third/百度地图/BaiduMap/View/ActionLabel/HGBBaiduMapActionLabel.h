//
//  HGBBaiduMapActionLabel.h
//  测试
//
//  Created by huangguangbao on 2017/11/2.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 可点击标签
 */
@interface HGBBaiduMapActionLabel : UILabel
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
/**
 事件

 @param target 目标
 @param action 事件
 */
-(void)addTarget:(id)target action:(SEL)action;
@end
