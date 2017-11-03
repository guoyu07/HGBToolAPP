//
//  HGBThreePicker.h
//  CTTX
//
//  Created by huangguangbao on 17/1/5.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGBThreePicker;
/**
 三项选择代理
 */
@protocol HGBThreePickerDelegate <NSObject>
/**
 选择

 @param arr 信息
 */
-(void)threePicker:(HGBThreePicker *)picker didSelectedWithTitleArr:(NSArray *)arr;
@optional
/**
 取消
 */
-(void)threePickerDidCanceled:(HGBThreePicker *)picker;
@end

/**
 三项选择
 */
@interface HGBThreePicker : UIViewController
/**
 标题
 */
@property (nonatomic,strong)NSString *titleStr;
/**
 标识
 */
@property(assign,nonatomic)NSInteger tag;
/**
  字体颜色
 */
@property(strong,nonatomic)UIColor *textColor;
/**
 字体大小
 */
@property(assign,nonatomic)CGFloat fontSize;

/**
 选中项
 */
@property(strong,nonatomic)NSArray *selectedItems;
/**
 数据源:dic-dic-arr
 */
@property (nonatomic,strong)NSDictionary *dataSource;
/**
 创建
 */
+(instancetype)instanceWithParent:(UIViewController *)parent andWithDelegate:(id<HGBThreePickerDelegate>)delegate;
/**
 弹出视图
 */
-(void)popInParentView;
@end
