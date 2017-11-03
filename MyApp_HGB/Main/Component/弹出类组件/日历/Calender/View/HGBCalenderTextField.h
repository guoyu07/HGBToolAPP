//
//  HGBCalenderTextField.h
//  测试
//
//  Created by huangguangbao on 2017/10/24.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGBCalenderTextField : UIView
/**
 文字颜色
 */
@property(strong,nonatomic)UIColor *textColor;
/**
 提示
 */
@property(strong,nonatomic)NSString *placeholder;
/**
 默认日期
 */
@property(strong,nonatomic)NSDate *date;
/**
 右侧图片
 */
@property(strong,nonatomic)UIImage *rightimage;
/**
 进入响应模式
 */
-(void)becomeFirstResponder;
/**
 退出响应模式
 */
-(void)resignFirstResponder;
@end
