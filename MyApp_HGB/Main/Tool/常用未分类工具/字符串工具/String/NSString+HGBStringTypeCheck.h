//
//  NSString+HGBStringTypeCheck.h
//  测试app
//
//  Created by huangguangbao on 2017/6/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HGBStringTypeCheck)
/**
 *  验证字符是否是数字
 *
 *  @return  结果
 */
-(BOOL)isNumString;
/**
 *  验证字符是否是字母
 *
 *  @return  结果
 */
-(BOOL)isWordString;
/**
 *  验证字符是否是汉字
 *
 *  @return  结果
 */
-(BOOL)isChineseString;
/**
 *  检验字符是否是字母或数字
 *
 *  @return 字符串合法性
 */
-(BOOL)isNumOrWordString;
@end
