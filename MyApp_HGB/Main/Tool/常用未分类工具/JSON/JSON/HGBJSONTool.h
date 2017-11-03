//
//  HGBJSONTool.h
//  JSON工具类测试
//
//  Created by huangguangbao on 2017/6/23.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBJSONTool : NSObject
/**
 把Json对象转化成json字符串
 
 @param object json对象
 @return json字符串
 */
+ (NSString *)ObjectToJSONString:(id)object;

/**
 把Json字符串转化成json对象
 
 @param jsonString json字符串
 @return json字符串
 */
+ (id)JSONStringToObject:(NSString *)jsonString;
@end
