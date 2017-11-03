//
//  HGBPredicateTool.h
//  测试
//
//  Created by huangguangbao on 2017/8/6.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 匹配类型
 */
typedef enum HGBPredicateType
{
    HGBPredicateTypeEqual,//相等
    HGBPredicateTypeLike,//相似
    HGBPredicateTypeMatch//匹配

}HGBPredicateType;

@interface HGBPredicateTool : NSObject
/**
 字符串校验

 @param string 字符串
 @param condition 条件
 @return 结果
 */
+(BOOL)evaluateString:(NSString *)string WithCondition:(NSString *)condition;
/**
 谓词工具-便捷版

 @param object 对象
 @param condition 条件
 @param type 类型
 @return 结果
 */
+(BOOL)evaluateObject:(id)object WithPredicateCondition:(NSString *)condition andWithType:(HGBPredicateType )type;

/**
 谓词工具

 @param predicateString predicate
 @param object 对象
 @return 结果
 */
+(BOOL)evaluateObject:(id)object WithPredicateFormat:(NSString *)predicateString,...;


@end
