//
//  NSString+HGBStringCheck.h
//  测试app
//
//  Created by huangguangbao on 2017/6/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HGBStringCheck)
/**
 *  手机号验证－宽松
 *
 *
 *  @return 是否是手机号
 */
- (BOOL)isMobileNumber;
/**
 *  手机号验证－严谨
 *
 *  @return 是否是手机号
 */
- (BOOL)isStrictMobileNumber;
/**
 *  身份证验证-宽松
 *
 *
 *  @return 是否正确
 */
-(BOOL)isIDCardNum;
/**
 *  身份证验证-严格
 *
 *  @return 是否正确
 */
-(BOOL)isStritIDCardNum;
/**
 *  性别判断
 *
 *  @return 性别
 */
-(BOOL)isAWomanIdCardNum;

/**
 *  邮箱验证
 *
 *  @return 是否正确
 */
-(BOOL)isValidateEmail;
/**
 *  邮编验证
 *
 *  @return 是否正确
 */
-(BOOL)isZipCodeNum;
@end
