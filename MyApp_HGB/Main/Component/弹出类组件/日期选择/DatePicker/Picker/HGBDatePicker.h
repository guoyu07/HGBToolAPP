//
//  HGBDatePicker.h
//  测试
//
//  Created by huangguangbao on 2017/7/15.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 日期类型
 */
typedef enum HGBDatePickerType
{
    HGBDatePickerTypeNO,
    HGBDatePickerTypeOnlyYearMonth,//只有年月
    HGBDatePickerTypeOnlyMonthDay//只有月日
}HGBDatePickerType;


@class HGBDatePicker;
/**
 日期选择代理
 */
@protocol HGBDatePickerDelegate <NSObject>
/**
 返回结果
 
 @param date 日期
 */
-(void)datePicker:(HGBDatePicker *)datePicker didSelectedDate:(NSDate *)date;

@optional
/**
 返回结果
 
 @param dateString 日期字符串
 */
-(void)datePicker:(HGBDatePicker *)datePicker didSelectedDateToFormatDateString:(NSString *)dateString;
/**
 返回结果

 @param year 年
 @param month 月
 @param day 日
 */
-(void)datePicker:(HGBDatePicker *)datePicker didSelectedDateToYear:(NSString *)year Month:(NSString *)month Day:(NSString *)day;
/**
 取消
 */
-(void)datePickerDidCanceled:(HGBDatePicker *)datePicker;
@end

/**
 日期选择
 */

@interface HGBDatePicker : UIViewController

#pragma mark 通用设置
/**
 日期类型
 */
@property(assign,nonatomic)HGBDatePickerType type;
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


#pragma mark 时间段-年月-月日模式参数
/**
 年限-以当前坐标为基础正为未来 负为过去(权限小于开始日期结束日期)
 */
@property(assign,nonatomic)NSInteger numberOfYears;

/**
 开始日期
 */
@property(strong,nonatomic)NSDate *startDate;
/**
 开始日期
 */
@property(strong,nonatomic)NSString *startDateString;
/**
 结束日期
 */
@property(strong,nonatomic)NSDate *stopDate;//
/**
 结束日期
 */
@property(strong,nonatomic)NSString *stopDateString;//

#pragma mark 方法
/**
 创建
 */
+(instancetype)instanceWithParent:(UIViewController *)parent andWithDelegate:(id<HGBDatePickerDelegate>)delegate;
/**
 弹出视图
 */
-(void)popInParentView;

@end
