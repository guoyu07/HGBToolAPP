//
//  HGBTimePicker.h
//  测试
//
//  Created by huangguangbao on 2017/7/16.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 时间类型
 */
typedef enum HGBTimePickerType
{
    HGBTimePickerTypeNO,//无限制
    HGBTimePickerTypeOnlyHourMinute//只有时分
}HGBTimePickerType;


@class HGBTimePicker;
/**
 时间选择代理
 */
@protocol HGBTimePickerDelegate <NSObject>
/**
 返回结果
 
 @param time 时间
 */
-(void)timePicker:(HGBTimePicker *)timePicker didSelectedTime:(NSDate *)time;

@optional
/**
 返回结果
 
 @param timeString 时间字符串
 */
-(void)timePicker:(HGBTimePicker *)timePicker didSelectedTimeToFormatTimeString:(NSString *)timeString;
/**
 返回结果
 
 @param hour 时
 @param minute 分
 @param second 秒
 */
-(void)timePicker:(HGBTimePicker *)timePicker didSelectedTimeToHour:(NSString *)hour Minute:(NSString *)minute Second:(NSString *)second;
/**
 取消
 */
-(void)timePickerDidCanceled:(HGBTimePicker *)timePicker;
@end

/**
 时间选择
 */

@interface HGBTimePicker : UIViewController
#pragma mark 通用
/**
 时间类型
 */
@property(assign,nonatomic)HGBTimePickerType type;
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
 选中时间
 */
@property(strong,nonatomic)NSDate *selectedTime;
/**
 选中时间
 */
@property(strong,nonatomic)NSString *selectedTimeString;


#pragma mark 过去或未来年限

#pragma mark 时间段-年月-月日模式参数
/**
 时限-以当前坐标为基础正为未来 负为过去(权限小于开始时间结束时间)
 */
@property(assign,nonatomic)NSInteger numberOfHours;
/**
 开始时间
 */
@property(strong,nonatomic)NSDate *startTime;
/**
 开始时间
 */
@property(strong,nonatomic)NSString *startTimeString;

/**
 结束时间
 */
@property(strong,nonatomic)NSDate *stopTime;//
/**
 结束时间
 */
@property(strong,nonatomic)NSString *stopTimeString;//


/**
 创建
 */
+(instancetype)instanceWithParent:(UIViewController *)parent andWithDelegate:(id<HGBTimePickerDelegate>)delegate;
/**
 弹出视图
 */
-(void)popInParentView;

@end
