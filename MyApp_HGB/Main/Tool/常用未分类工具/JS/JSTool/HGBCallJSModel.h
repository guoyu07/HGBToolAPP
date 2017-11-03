//
//  HGBCallJSModel.h
//  测试
//
//  Created by huangguangbao on 2017/7/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


@interface HGBCallJSModel : NSObject
/**
 调用js方法
 
 @param jsFilePath js文件路径
 @param jsFunction 方法名
 @param jsArguments 参数
 @return 结果
 */
+(JSValue *)callJSInJSFilePath:(NSString *)jsFilePath WithFunction:(NSString *)jsFunction andWithArguments:(NSArray *)jsArguments;
/**
 调用js方法
 
 @param jsString js
 @param jsFunction 方法名
 @param jsArguments 参数
 @return 结果
 */
+(JSValue *)callJSWithJSString:(NSString *)jsString WithFunction:(NSString *)jsFunction andWithArguments:(NSArray *)jsArguments;
@end
