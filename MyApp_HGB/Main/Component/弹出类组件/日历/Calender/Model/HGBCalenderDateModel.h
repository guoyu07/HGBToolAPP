//
//  HGBCalenderDateModel.h
//  测试
//
//  Created by huangguangbao on 2017/10/19.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBCalenderDateModel : NSObject
/**
 是否已设置
 */
@property(assign,nonatomic)BOOL isSet;
/**
 日期
 */
@property(strong,nonatomic)NSDate *date;
/**
 年
 */
@property(assign,nonatomic)NSInteger year;
/**
 月
 */
@property(assign,nonatomic)NSInteger month;
/**
 日
 */
@property(assign,nonatomic)NSInteger day;
/**
 周
 */
@property(assign,nonatomic)NSInteger week;
@end
