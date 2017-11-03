//
//  HGBCalenderPicker.h
//  测试
//
//  Created by huangguangbao on 2017/10/24.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>



@class HGBCalenderPicker;
/**
 日历代理
 */
@protocol HGBCalenderPickerDelegate <NSObject>
/**
 返回日历点击的结果

 @param date 选中日期
 */
-(void)calender:(HGBCalenderPicker *)calender didFinishWithDate:(NSDate *)date;
@optional
/**
 返回日历点击的结果

 @param year 选中年
 @param month 选中月
 @param day 选中日
 @param week 选中周
 */
-(void)calender:(HGBCalenderPicker *)calender didFinishWithYear:(NSInteger )year andWithMonth:(NSInteger )month andWithDay:(NSInteger )day andWithWeek:(NSInteger )week;
/**
 取消扫描
 */
-(void)calenderDidCanceled:(HGBCalenderPicker *)calender;

@end

/**
 日期选择
 */

@interface HGBCalenderPicker : UIViewController

#pragma mark 通用设置
/**
 标识
 */
@property(assign,nonatomic)NSInteger index;

/**
 标题
 */
@property (nonatomic,strong)NSString *titleStr;

/**
 字体颜色
 */
@property(strong,nonatomic)UIColor *textColor;
/**
 字体大小
 */
@property(assign,nonatomic)CGFloat fontSize;



/**
 选中日期
 */
@property(strong,nonatomic)NSDate *selectedDate;

/**
 选中日期
 */
@property(strong,nonatomic)NSString *selectedDateString;


#pragma mark 方法
/**
 创建
 */
+(instancetype)instanceWithParent:(UIViewController *)parent andWithDelegate:(id<HGBCalenderPickerDelegate>)delegate;
/**
 弹出视图
 */
-(void)popInParentView;
@end
