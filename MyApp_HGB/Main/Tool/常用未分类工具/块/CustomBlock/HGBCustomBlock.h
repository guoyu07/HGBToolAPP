//
//  HGBCustomBlock.h
//  测试
//
//  Created by huangguangbao on 2017/8/6.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 任意类型参数块

 @param result 空
 */
typedef void (^CommonBlock)(id result);

/**
 BOOL参数块

 @param flag 标志
 */

typedef void (^CommonFlagBlock)(BOOL flag);

/**
 状态参数块

 @param status 状态
 */
typedef void (^CommonStatusBlock)(NSInteger status);


/**
 通用字符串参数块

 @param string 字符串
 */
typedef void (^CommonStringBlock)(NSString *string);

/**
 通用数组参数块

 @param array 数组
 */
typedef void (^CommonArrayBlock)(NSArray *array);

/**
 通用字典参数块

 @param dictionary 字典
 */
typedef void (^CommonDictionaryBlock)(NSDictionary *dictionary);

/**
 通用返回参数块

 @param code 状态码
 @param message 描述信息
 */
typedef void (^CommonRetrunBlock)(NSString* code,NSString *message);

/**
 通用返回字符串参数块

 @param code 状态码
 @param message 描述信息
 @param string 字符串
 */
typedef void (^CommonRetrunStringBlock)(NSString* code,NSString *message,NSString *string);

/**
 通用返回数组参数块

 @param code 状态码
 @param message 描述信息
 @param array 数组
 */
typedef void (^CommonRetrunArrayBlock)(NSString* code,NSString *message,NSArray *array);

/**
 通用返回字典参数块

 @param code 状态码
 @param message 描述信息
 @param dictionary 字典
 */
typedef void (^CommonRetrunDictionaryBlock)(NSString* code,NSString *message,NSDictionary *dictionary);


