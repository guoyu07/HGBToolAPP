//
//  HGBMailModel.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/31.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBMailModel : NSObject
/**
 名
 */
@property(nonatomic,copy)NSString *firstname;
/**
 姓
 */
@property(nonatomic,copy)NSString *lastname;
/**
 全名
 */
@property(nonatomic,copy)NSString *fullname;
/**
 公司
 */
@property(nonatomic,copy)NSString *company;

/**
 地址
 */
@property(nonatomic,copy)NSString *address;
/**
 生日
 */
@property(nonatomic,copy)NSDate *birthDate;
/**
 日期
 */
@property(nonatomic,copy)NSDate *date;
/**
 手机号
 */
@property(nonatomic,copy)NSString *phoneNumber;
/**
 手机号集合
 */
@property(nonatomic,copy)NSArray *phoneNumbers;
/**
 电子邮件集合
 */
@property(nonatomic,copy)NSArray *emailNumbers;
@end
