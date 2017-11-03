//
//  HGBCalenderDayView.h
//  测试
//
//  Created by huangguangbao on 2017/10/19.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGBCalenderDayView : UIView
/**
 日期标签
 */
@property(strong,nonatomic)UILabel *dayLabel;


/**
 提示标签
 */
@property(strong,nonatomic)UILabel *promptLabel;
/**
 点击按钮
 */
@property(strong,nonatomic)UIButton *backButton;

@end
